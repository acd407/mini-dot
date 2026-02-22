# 用于编译任务的非特权 LXC 容器

## 1. 引言：Linux LXC 容器技术

Linux 容器（LXC）是一种操作系统级虚拟化技术，通过在单一 Linux 内核上运行多个独立且隔离的系统环境，实现了**轻量级虚拟化**。与传统的虚拟机相比，LXC 容器具有**资源占用更低**、**启动速度更快**的优势，同时保持了类似虚拟机的环境隔离性。

本文主要介绍**非特权容器**（Unprivileged Containers）。这类容器以普通用户身份运行，将容器内的 root 用户映射到宿主机的非特权用户 ID，从而**显著提升系统的安全性**，减小潜在攻击面。

## 2. 故事背景

很多开发项目在其主页上提供了**构建项目**和**安装依赖项**的指导，但大多数指南都基于 **Debian/Ubuntu** 系统。某些项目甚至未在非 Debian 系统上进行测试，导致其他发行版（如 **Arch Linux**）用户在构建过程中遇到诸多困难。

另一个实际原因是，**Arch Linux** 的滚动更新机制较为占用磁盘空间。因此，笔者倾向于将一些不常更新的软件（如交叉编译工具链）放置在 **Flatpak** 或 **LXC 容器**中。这类工具链体积较大，更新频率低，非常适合通过 LXC 容器进行管理。

为什么不使用 **Docker**？尽管 Docker 也能满足需求，但它需要常驻后台进程，并且通常需要 root 权限。相比之下，**LXC 更轻量、更贴近系统层面**，也更符合本文的使用场景——Docker 更适合用于服务部署，而 LXC 更适用于环境隔离与编译任务。

## 3. 主要操作步骤

### 3.1 环境准备与安装

LXC 的安装过程因发行版而异，此处不再赘述，请根据所用系统自行安装。

### 3.2 为用户配置 SubUID/SubGID

为用于管理容器的用户（例如 `acd407`）分配子 UID 和子 GID：

```bash
sudo usermod -v 100000-165535 acd407  # 设置 subuid
sudo usermod -w 100000-165535 acd407  # 设置 subgid
```

可通过以下命令查看分配结果：

```bash
grep $USER /etc/subuid
grep $USER /etc/subgid
```

示例输出如下：

```
acd407:100000:65536
acd407:100000:65536
```

### 3.3 创建 LXC 用户配置文件

首先创建配置目录：

```bash
mkdir -p ~/.config/lxc
```

编辑 `~/.config/lxc/default.conf`，写入如下内容：

```
lxc.net.0.type = veth
lxc.net.0.link = br0
lxc.net.0.flags = up
lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx

lxc.idmap = u 0 100000 1000
lxc.idmap = g 0 100000 1000
lxc.idmap = u 1000 1000 1
lxc.idmap = g 1000 1000 1
lxc.idmap = u 1001 101001 64535
lxc.idmap = g 1001 101001 64535

lxc.mount.entry = /home/acd407/repository LXC_ROOTFS/mnt none bind,create=dir 0 0
```

#### 配置说明：

- **网络部分**：
```
lxc.net.0.type = veth
lxc.net.0.link = br0
lxc.net.0.flags = up
lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx
```
此处配置使用一个**外部管理的网桥**（如 `br0`）。如果希望继续使用 LXC 默认的 `lxcbr0`，可保留默认配置。

- **ID 映射部分**：
```
lxc.idmap = u 0 100000 1000
lxc.idmap = g 0 100000 1000
lxc.idmap = u 1000 1000 1
lxc.idmap = g 1000 1000 1
lxc.idmap = u 1001 101001 64535
lxc.idmap = g 1001 101001 64535
```
该配置实现了 UID/GID 的映射：
- 将容器内的 0–999 和 1001–65535 分别映射到宿主机的 100000–100999 和 101001–165535；
- 容器内的 UID 1000 直接映射到宿主机的 UID 1000。

这样做是为了在绑定挂载宿主目录时，保持文件所有权的一致性。

- **挂载条目**：
```
lxc.mount.entry = /home/acd407/repository LXC_ROOTFS/mnt none bind,create=dir 0 0
```
  将宿主的 `/home/acd407/repository` 绑定挂载到容器的 `/mnt` 目录，`create=dir` 表示若目录不存在则自动创建。

> `~/.config/lxc/default.conf` 是一个模板文件。使用 `lxc-create` 创建容器时，LXC 会自动将 `LXC_ROOTFS` 等变量替换为容器的实际路径。

### 3.4 配置网络权限

允许用户创建 veth 设备并连接到网桥（如 `br0`）：

```bash
echo "acd407 veth br0 10" | sudo tee -a /etc/lxc/lxc-usernet
```

该命令允许用户 `acd407` 最多创建 10 个 veth 设备对，并将其连接到 `br0` 网桥。

### 3.5 创建并启动非特权容器

以下以创建一个 Debian 容器为例：

```bash
lxc-create --name debian --template download -- --dist debian --release trixie --arch amd64
lxc-start debian
lxc-attach -n debian --clear-env --set-var TERM=linux

# 更换为中科大镜像源以加速访问
sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
apt update
# 根据自己的需求装点软件
apt install wget curl git vis fastfetch vivid fish foot-terminfo gpg

# 创建与宿主机同UID的用户
useradd -m -u 1000 -s /usr/bin/fish acd407
passwd acd407
usermod -aG sudo acd407

# 复制 SSH 配置
cp -r .ssh/ /var/lib/lxc/debian/rootfs/home/acd407/

# 以用户身份进入容器，克隆配置仓库
lxc-attach -n debian --clear-env --set-var TERM=$TERM -- su -l $USER
git clone git@github.com:acd407/dot.git # 我自己的配置文件仓库
rm -rf .config/ && mv dot/ .config/
```

好啦，一套小连招下来，系统就基本可用了。

#### 总结

我将项目目录挂载到容器的`/mnt`目录下，那么，容器内`cd`到`/mnt`，就可以愉快的开始编译了。容器的编译结果对于宿主机还是完全可见的。

用相同的方法，还可以配置容器和宿主机使用相同的`ccache`缓存，这里就不再赘述了。

---
*本文内容基于 LXC 及相关 Linux 技术文档编写，实际操作请根据您使用的发行版和 LXC 版本进行调整。*
