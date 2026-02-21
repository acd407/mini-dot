> 本文记录了我在 Android 设备上成功部署并运行 LXC（Linux Containers）容器的全过程。目标是提供一种可行、可复现的方法，并分享过程中踩过的坑与解决方案。

# 前置条件

在开始之前，请确保满足以下条件：

- **设备已 root**（Magisk 或 KernelSU 均可）；
- **内核支持 LXC 所需的配置选项**；
- **具备合适的编译环境**（交叉编译或原生编译均可）。

本文采用“原生编译 + musl 静态链接”的方案，基于 Alpine Linux 构建 LXC 工具链。当然，其他路径（如使用 NDK、glibc 交叉编译等）也是可行的，但本文仅聚焦于一条经过验证的路径。

---

# 一、内核准备：打补丁以支持 LXC

我的目标设备运行的是 **Android 12 + GKI 5.10 内核**。幸运的是，社区已有针对该内核版本的 LXC 支持补丁：

🔗 [https://github.com/1orz/android-gki-custom](https://github.com/1orz/android-gki-custom)

## 选择内核分支

最初我尝试使用设备原厂对应的 GKI 分支，但因年代久远，连国内镜像源都难以拉取。观察发现，Android 对内核的小版本号（patch level）并不敏感，因此我最终选用了最新的 `common-android12-5.10-2025-12` 分支。

## 处理补丁冲突

在应用补丁时，`overlayfs_dont_make_DCACHE_OP_HASH_and_DCACHE_OP_COMPARE_weird.patch` 出现了冲突。不过问题不大——只需手动修改对应源文件即可解决。此处不再赘述具体操作。

![kernel-cfg](https://img2024.cnblogs.com/blog/1987269/202512/1987269-20251214122755165-731554043.png)

打完补丁后，运行 `lxc-checkconfig`，结果令人满意，关键功能均已启用。

---

# 二、构建 LXC：为何选择 Alpine + 静态链接？

LXC 依赖多个系统库，如：
- `libcap`
- `libseccomp`
- `openssl`

若使用 **Android NDK**，其 Bionic libc 兼容性较差，且近年 LXC 对 Android 的支持几乎停滞，移植成本高。

若选择 **交叉编译**，则需自行编译所有依赖库，过程繁琐。更麻烦的是，主流 aarch64 交叉工具链基于 glibc，无法生成完全静态链接的二进制文件。

于是，我转向 **musl libc 生态**——这正是 **Alpine Linux** 的优势所在。Alpine 提供了大量预编译的静态库，完美契合需求。

## 利用 binfmt 实现跨架构构建

我之前花了几篇文章讨论“[非特权LXC容器](https://zhuanlan.zhihu.com/p/1951768488260637015)”：

这里我们补齐其中的重要一环：`binfmt`。

为了在 x86_64 主机上“原生”构建 aarch64 的 Alpine 环境，我借助了 Linux 的 `binfmt_misc` 机制：

`binfmt_misc`可以实现执行其他架构程序的效果，比如这样：

```
[acd407@ideapad bin]$ arch
x86_64
[acd407@ideapad bin]$ file tar
tar: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, for Android 31, built by NDK r23c (8568313), stripped
[acd407@ideapad bin]$ ./tar --version
tar (GNU tar) 1.34
Copyright (C) 2021 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by John Gilmore and Jay Fenlason.

```

下一步，在 Arch Linux 上安装 QEMU 用户态模拟器

```bash 
sudo pacman -S qemu-user-static-binfmt
```

该包会自动注册 `qemu-aarch64-static` 到 binfmt，使得系统能透明执行 ARM64 可执行文件。

![binfmt](https://img2024.cnblogs.com/blog/1987269/202512/1987269-20251214122908318-1352138170.png)

接着，创建一个非特权的 aarch64 Alpine LXC 容器：

```bash
lxc-create --name alpine-aarch64 \
  --template download \
  -- --server mirrors.cernet.edu.cn/lxc-images \
     --dist alpine \
     --release edge \
     --arch arm64
```

并在容器配置中添加：

```conf
lxc.mount.entry = /usr/bin/qemu-aarch64-static usr/bin/qemu-aarch64-static none bind,optional,create=file 0 0
```

这样，容器启动后即可直接运行 ARM64 程序。

⚠️ 注意：由于内核限制，**转译环境下无法提权**（即不能使用 `sudo`），必须以 root 身份操作。

---

# 三、编译 LXC：静态链接 + 裁剪配置

进入 Alpine 容器后，安装所需静态开发包：

```sh
apk add build-base meson git \
  openssl-dev openssl-libs-static \
  libseccomp-dev libseccomp-static \
  libcap-dev libcap-static
```

## 修改 Meson 构建脚本

默认 LXC 会同时生成动态库和静态库。为实现纯静态链接，我对 `meson.build` 做了如下调整：

```diff
diff --git a/meson.build b/meson.build
index 4b3a8f07f..0497c2736 100644
--- a/meson.build
+++ b/meson.build
@@ -892,18 +892,10 @@ subdir('src/lxc/pam')
 
 liblxc_link_whole = [liblxc_static]
 
-liblxc = shared_library(
-    'lxc',
-    version: liblxc_version,
-    include_directories: liblxc_includes,
-    link_args: ['-DPIC'],
-    c_args: ['-DPIC'],
-    link_whole: liblxc_link_whole,
-    dependencies: liblxc_dependencies,
-    install: true)
+liblxc = liblxc_static
 
 liblxc_dep = declare_dependency(
-    link_with: liblxc,
+    link_with: liblxc_static,
     dependencies: liblxc_dependencies)
 
 # Rest of sub-directories.
diff --git a/src/lxc/cmd/meson.build b/src/lxc/cmd/meson.build
index edfb98662..707c18e9f 100644
--- a/src/lxc/cmd/meson.build
+++ b/src/lxc/cmd/meson.build
@@ -47,8 +47,8 @@ cmd_lxc_init_static_sources = files(
     '../string_utils.h') + include_sources
 
 cmd_lxc_monitord_sources = files('lxc_monitord.c')
-cmd_lxc_user_nic_sources = files('lxc_user_nic.c') + cmd_common_sources + netns_ifaddrs_sources
-cmd_lxc_usernsexec_sources = files('lxc_usernsexec.c') + cmd_common_sources + netns_ifaddrs_sources
+cmd_lxc_user_nic_sources = files('lxc_user_nic.c')
+cmd_lxc_usernsexec_sources = files('lxc_usernsexec.c')
 
 cmd_lxc_checkconfig = configure_file(
     configuration: dummy_config_data,
```

同时简化了部分命令行工具的依赖（移除不必要的公共源文件引用）。

## 配置构建参数

使用以下命令配置 Meson：

```bash
meson setup --reconfigure build \
  -Dtools-multicall=true \
  -Dtools=false \
  -Ddistrosysconfdir=conf.d \
  -Dinstall-init-files=false \
  -Dman=false \
  -Dinit-script=sysvinit \
  -Ddbus=false \
  -Dstrip=true \
  -Dselinux=false \
  -Dapparmor=false \
  -Dprefix=/data/local/tmp/lxc \
  -Ddata-path=/data/local/tmp/lxc/var/lib/lxc \
  -Druntime-path=/data/local/tmp/lxc/run \
  -Dlog-path=/data/local/tmp/lxc/var/log/lxc \
  -Dc_link_args="-static" \
  --localstatedir=/data/local/tmp/lxc/var
```

> 目录 `/data/local/tmp` 是 Android 上少数可写且允许执行二进制文件的位置，无需 Magisk 模块即可使用。

LXC的每个文件、目录究竟在什么地方，启用了那些LXC组件，可以通过`meson`的输出获取，比如这样的：

```
Message: lxc 6.0.0
     Meson version:			1.10.0
     prefix directory:		/data/local/tmp/lxc
     bin directory:			/data/local/tmp/lxc/bin
     data directory:		/data/local/tmp/lxc/share
     doc directory:			/data/local/tmp/lxc/share/doc/lxc
     include directory:		/data/local/tmp/lxc/include
     lib directory:			/data/local/tmp/lxc/lib
     libexec directory:		/data/local/tmp/lxc/libexec
     local state directory:	/data/local/tmp/lxc/var
     sbin directory:		/data/local/tmp/lxc/sbin
     sysconf directory:		/data/local/tmp/lxc/etc
     lxc cgroup pattern:		
     lxc init directory:	/data/local/tmp/lxc/libexec
     runtime path:			/data/local/tmp/lxc/run
     lxc default config:	/data/local/tmp/lxc/etc/lxc/default.conf
     lxc global config:		/data/local/tmp/lxc/etc/lxc/lxc.conf
     lxc hook directory:		/data/local/tmp/lxc/share/lxc/hooks
     lxc hook bin directory:	/data/local/tmp/lxc/libexec/lxc/hooks
     lxc rootfs mount directory:	/data/local/tmp/lxc/lib/lxc/rootfs
     log path:			/data/local/tmp/lxc/var/log/lxc
     lxc path:			/data/local/tmp/lxc/var/lib/lxc
     lxc template config:		/data/local/tmp/lxc/share/lxc/config
     lxc template directory:	/data/local/tmp/lxc/share/lxc/templates
     lxc user network config:	/data/local/tmp/lxc/etc/lxc/lxc-usernet
     lxc user network database:	/data/local/tmp/lxc/run/lxc/nics
```

接下来，构建并安装到本地目录：

```bash
DESTDIR=./target ninja -C build install
```

随后通过 `tar` 打包并通过 `adb push` 推送到设备。

---

# 四、运行前的环境配置

## 设置环境变量

在 Android 上运行 LXC 前，需设置必要环境变量：

```bash
#!/system/bin/sh
export HOME=/data/local/tmp/root
export PATH="/data/local/tmp/lxc/bin:$PATH"
```

LXC 的 `lxc-create` 会使用 `$HOME/.cache` 缓存模板下载内容，因此必须指定有效的 `HOME`。

## 网络配置

默认配置尝试创建 `lxcbr0` 网桥，但在 Android 上可能失败。为简化起见，我将 `config/etc/default.conf.lxcbr` 修改为：

```conf
lxc.net.0.type = none
```

实测表明，即使禁用网络命名空间，root 和非特权用户仍可通过 host 网络正常联网（可能因 Android 的 netns 行为特殊）。

---

# 五、缺失工具的补充

Android 自带的 `toybox` 功能有限，缺少 `getopt` 和完整版 `tar`：

- **`getopt`**：可用静态版 BusyBox 替代；
- **`tar`**：BusyBox 的 tar 不支持 `--anchored` 选项，会导致 `lxc-download` 模板失败。

有两种解决方案：

1. 修改 `templates/lxc-download.in`，强制定义 `IS_BSD_TAR=1`；
2. 使用预编译的 GNU tar 静态二进制（推荐）：

   - [https://github.com/Rprop/tar-android-static](https://github.com/Rprop/tar-android-static)
   - [https://github.com/Moe-sushi/tar-static](https://github.com/Moe-sushi/tar-static)

---

# 六、关于 sudo 与权限

## 宿主机 binfmt 容器
在 binfmt 转译环境中，**无法使用 `sudo`**。这是 Linux 内核的安全限制（详见 [DeepWiki 解释](https://deepwiki.com/search/-bprminterp-binfmt_57ad8fe3-0d66-426b-96a2-3d30f3b50353?mode=fast)），并非 bug。

因此，所有特权操作需直接以 root 身份执行，不能寄希望于`su`和`sudo`。

## 安卓 LXC 容器

[参考这里](https://blog.akina.moe/2024/08/11/android-lxc-md/#%E6%99%AE%E9%80%9A%E7%94%A8%E6%88%B7%E6%97%A0%E6%B3%95%E4%BD%BF%E7%94%A8-sudo)

---

# 七、效果展示

一切就绪后，即可正常使用 LXC：

![ans1](https://img2024.cnblogs.com/blog/1987269/202512/1987269-20251214122934479-564610384.png)

![ans2](https://img2024.cnblogs.com/blog/1987269/202512/1987269-20251214122942968-406906494.png)

容器运行稳定，功能完整，与标准 Linux 环境无异。

---

# 结语

本文提供了一条在 Android 上运行 LXC 容器的可行路径：**GKI 内核打补丁 + Alpine 静态构建 + binfmt 跨架构支持 + 精简部署**。虽然过程略显曲折，但每一步均有明确依据和替代方案。

希望这篇记录能为后来者节省时间。欢迎在评论区交流你的尝试与改进！
