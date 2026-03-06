# 关于 Redrix（HP Elite Dragonfly Chromebook）在 Linux 下的部分问题和解决方案

![fastfetch](https://img2024.cnblogs.com/blog/1987269/202603/1987269-20260304173655364-1135983054.png)

| 符号 | 意义                             |
|------|----------------------------------|
| ✅    | 没有任何问题，或者瑕疵不影响使用 |
| ⚠️    | 存在影响使用的小问题             |
| ❌    | 存在大问题，或完全不可用         |

---

## 指纹识别 ✅

对libfprint打[补丁](https://gitlab.freedesktop.org/libfprint/libfprint/-/merge_requests/512)后可以正常工作了。
至于具体要如何添加指纹、设置pam规则，这就是libfprint的内容了。

我也在AUR上打了一个包[libfprint-crfpmoc-git](https://aur.archlinux.org/libfprint-crfpmoc-git.git)。

## IPU6摄像头 ✅

只要能通过 `cam -l` 发现摄像头，就问题不大。

```bash
$ cam -l 2>/dev/null
Available cameras:
1: 'hi556' (\_SB_.PCI0.I2C2.CAM0)
```

此时，虽然`libcamera`可以使用，但很多依赖传统v4l2的程序会出问题，
因为IPU6不提供经典可用的`/dev/video0`，而是分成小块，但每一个都不可用：

```bash
$ v4l2-ctl --list-devices
ipu6 (PCI:0000:00:05.0):
	/dev/video0
	/dev/video1
	/dev/video2
... 省略很多杂乱的v4l2设备
```

面对这种情况，安装 `pipewire-libcamera` 包即可通过`pipewire`使用摄像头。

```bash
$ pw-cli ls Device | grep device.api -A2
 		device.api = "alsa"
 		device.description = "Alder Lake PCH-P High Definition Audio Controller"
 		device.name = "alsa_card.pci-0000_00_1f.3-platform-adl_rt5682_def"
--
 		device.api = "v4l2"
 		device.description = "ipu6"
 		device.name = "v4l2_device.pci-0000_00_05.0"
--
 		device.api = "v4l2"
 		device.description = "ipu6"
 		device.name = "v4l2_device.pci-0000_00_05.0.2"
--
 		device.api = "v4l2"
 		device.description = "ipu6"
 		device.name = "v4l2_device.pci-0000_00_05.0.3"
... 省略很多杂乱的v4l2设备
```

而`pipewire`是有`pw-v4l2`工具为传统的v4l2提供兼容的。

最终可以“曲线救国”：

```bash
$ pw-v4l2 v4l2-ctl --list-devices
ipu6 (PCI:0000:00:05.0):
	/dev/media0

hi556 (platform:PipeWire-111):
	/dev/video0
```

这里的`/dev/video0`就可以作为v4l2设备直接使用。

不想显式使用`pw-v4l2`，设置一下环境变量就好了：

```bash
$ LD_PRELOAD=/usr/lib/pipewire-0.3/v4l2/libpw-v4l2.so v4l2-ctl --list-devices
ipu6 (PCI:0000:00:05.0):
	/dev/media0

hi556 (platform:PipeWire-111):
	/dev/video0
```

### 小窍门

如果嫌弃 v4l2污染pipewire，可以通过如下配置文件隐藏杂乱的v4l2设备：

~/.config/wireplumber/wireplumber.conf.d/99-disable-v4l2.conf

```bash
wireplumber.profiles = {
  main = {
    monitor.v4l2 = disabled      # 完全停用 V4L2 监视器
  }
}
```

再重启pipewire：`systemctl --user restart pipewire.service wireplumber.service`

```bash
$ pw-cli ls Device
	id 43, type PipeWire:Interface:Device/3
 		object.serial = "43"
 		factory.id = "15"
 		client.id = "41"
 		device.api = "alsa"
 		device.description = "Alder Lake PCH-P High Definition Audio Controller"
 		device.name = "alsa_card.pci-0000_00_1f.3-platform-adl_rt5682_def"
 		device.nick = "sof-rt5682"
 		media.class = "Audio/Device"
	id 64, type PipeWire:Interface:Device/3
 		object.serial = "64"
 		factory.id = "15"
 		client.id = "41"
 		device.api = "libcamera"
 		device.description = "Unknown device"
 		device.name = "libcamera_device.0"
 		media.class = "Video/Device"
```

瞬间安静了

### 潜在的问题

通过`ffplay`看不明显：

![`LD_PRELOAD=/usr/lib/pipewire-0.3/v4l2/libpw-v4l2.so ffplay -f v4l2 -i /dev/video0`](https://img2024.cnblogs.com/blog/1987269/202603/1987269-20260304173746888-1051070230.png)

通过原始的`libcamera`看，明显有点偏色：

![qcam](https://img2024.cnblogs.com/blog/1987269/202603/1987269-20260304173816091-1618807236.png)

这就很奇怪了，`ffplay`拿到的是`libcamera -> pipewire -> v4l2` 的好几手中转数据，怎么色彩上会更好呢？

不过我觉得这不会太影响体验，算作瑕疵吧。

## 音频 ⚠️

参考[chromebook-linux-audio](https://github.com/WeirdTreeThing/chromebook-linux-audio)，但存在瑕疵。

### 潜在的问题

当音频暂停播放后，默认5秒钟后pipewire会suspend，进入低功耗状态，以节省能源。
在这个过程中由于**未明确的问题**会出现啪的一声。

使用如下配置可以让pipewire迅速进入suspend，以让啪和暂停的动作联系起来，避免在安静时被吓一跳。

~/.config/wireplumber/wireplumber.conf.d/99-alsa-suspend.conf

```lua
monitor.alsa.rules = [
    {
        matches = [
            {
                ## Matches all sinks.
                node.name = "~alsa_output.*"
            }
        ]
        actions = {
            update-props = {
                ## 0 disables suspend
                session.suspend-timeout-seconds = 0.1
            }
        }
    }
]
```

## HP 隐私屏 ❌

Linux内核中应该是提供了底层的支持的，可见于`drivers/platform/chrome/chromeos_privacy_screen.c`。

```bash
$ ls /sys/module/chromeos_privacy_screen/
coresize  drivers/  holders/  initsize  initstate  notes/  refcnt  sections/  srcversion  taint  uevent

$ ls /sys/class/drm/privacy_screen-GOOG0010:00/
device@  hw_state  power/  subsystem@  sw_state  uevent

$ journalctl -b -k | grep -i "GOOG0010"
3月 04 14:25:39 cachyos kernel: Found 'privacy_screen-GOOG0010:00' privacy-screen provider
3月 04 14:25:40 cachyos kernel: chromeos_privacy_screen_driver GOOG0010:00: registered privacy-screen 'privacy_screen-GOOG0010:00'
```

但现在还不知道怎么用。

另外，HP 隐私屏占用了一个专门的按键，这个按键当前也是无法使用、无法重映射。

[chrultrabook forum](https://forum.chrultrabook.com/t/hp-dragonfly-elite-nobara-linux-hp-privacy-screen-button/3160/14) 上有讨论，可以进一步跟踪

## ChromeOS 设备功能键 ❌

算上LID（屏幕）等等，无非是这几个：

```bash
$ sudo ectool mkbpget buttons
MKBP buttons state: 0x0000 (supported: 0x0007)
Power: OFF
Volume up: OFF
Volume down: OFF

$ sudo ectool mkbpget switchs
MKBP switches state: 0x0001 (supported: 0x0003)
Lid open: ON
Tablet mode: OFF
```

事实上，`drivers/input/keyboard/cros_ec_keyb.c`确实有这些特殊按键的支持。

甚至注册都完成了，但确实收不到消息：

```bash
$ evtest /dev/input/event5
Input driver version is 1.0.1
Input device ID: bus 0x6 vendor 0x0 product 0x0 version 0x1
Input device name: "cros_ec_buttons"
Supported events:
  Event type 0 (EV_SYN)
  Event type 1 (EV_KEY)
    Event code 114 (KEY_VOLUMEDOWN)
    Event code 115 (KEY_VOLUMEUP)
    Event code 116 (KEY_POWER)
  Event type 5 (EV_SW)
    Event code 0 (SW_LID) state 0
    Event code 1 (SW_TABLET_MODE) state 0
Key repeat handling:
  Repeat type 20 (EV_REP)
    Repeat code 0 (REP_DELAY)
      Value    250
    Repeat code 1 (REP_PERIOD)
      Value     33
Properties:
Testing ... (interrupt to exit)
```

这是按下按键时EC的日志：

```log
[85746.715188 Button 'Volume Up' was pressed]
[85746.715768 mkbp buttons: 2]
[85746.876173 Button 'Volume Up' was released]
[85746.876759 mkbp buttons: 0]
[85747.582414 Button 'Volume Down' was pressed]
[85747.583371 mkbp buttons: 4]
[85747.821545 Button 'Volume Down' was released]
[85747.822581 mkbp buttons: 0]
```

可以发现，EC是通过MKBP向AP发送消息的。

在`drivers/platform/chrome/cros_ec.c +247` `cros_ec_register`函数中可见：

```c
if (ec_dev->irq > 0) {
    err = devm_request_threaded_irq(dev, ec_dev->irq,
                    cros_ec_irq_handler,
                    cros_ec_irq_thread,
                    IRQF_TRIGGER_LOW | IRQF_ONESHOT,
                    "chromeos-ec", ec_dev);
    if (err) {
        dev_err(dev, "Failed to request IRQ %d: %d\n",
            ec_dev->irq, err);
        goto exit;
    }
}
```

这说明，AP是通过`chromeos-ec`中断来获取按键数据的。

然而，我发现按按键并没有触发中断（如下，一直是19个），这说明cros的中断系统依然存在问题。
然而，有趣的是，**Windows上是可以使用这些功能键的**。问题大概率还在Linux的内核层。

```bash
acd407@redrix 16:35:52 ~ 
$ cat /proc/interrupts | awk '{
      sum = 0;
      for (i = 2; i <= 13; i++) sum += $i;
      printf "%s", $1;
      printf " %d", sum;
      for (i = 14; i <= NF; i++) printf " %s", $i;
      printf "\n"
  }' | grep chromeos-ec
101: 19 IR-IO-APIC 101-fasteoi chromeos-ec
acd407@redrix 16:36:06 ~ 
$ cat /proc/interrupts | awk '{
      sum = 0;
      for (i = 2; i <= 13; i++) sum += $i;
      printf "%s", $1;
      printf " %d", sum;
      for (i = 14; i <= NF; i++) printf " %s", $i;
      printf "\n"
  }' | grep chromeos-ec
101: 19 IR-IO-APIC 101-fasteoi chromeos-ec
```

## 个别组合键无法触发 ❌

我发现的是`meta-ctrl-5`和`meta-ctrl-6`。

在tty上用showkey命令监控键盘，按下meta-ctrl后挨个按1到9，很容易发现问题，其他的像`meta-ctrl-4`或`meta-ctrl-7`都可以响应，唯独5和6不可以。

Windows上同样不可用，怀疑是硬件连线的限制。

## 休眠、睡眠（S3、s0ix） ❌

这是一个**大坑**，所有类型的、无论是否合盖的睡眠，都不可用。

而且众所周知，关于关机、睡眠的问题都极难调试，难以稳定复现。

存在一些解决方案，但都不稳定。

重新加载内核模块的方法，十分容易造成painc，完全不推荐。

而使用`ectool hostsleepstate freeze`，有概率成功，但同时有重启的风险，也不推荐。

[chrultrabook forum](https://forum.chrultrabook.com/t/chromebook-refuses-to-consistently-suspend-across-different-distros/7564)和[github](https://github.com/MrChromebox/firmware/issues/851)上有专门的讨论。

## 触控板失灵 ⚠️

这个机器的触控板还是挺好的，全域压力触控板。

我偶尔碰到几回触控板失灵，似乎是在测试睡眠时发生的。暂时还不清楚确定的原因。

### 缓解办法

用 Chromebook 的十有八九同时在用keyd处理按键映射吧。

要先停止keyd，否则会导致驱动程序崩溃。

然后再重载`hid_multitouch`驱动程序：

```bash
modprobe -r hid_multitouch
modprobe hid_multitouch
```

## 失去键盘背光 ⚠️

这个我还真的不清楚，遇到过几回，有的时候AP（OS）重启一次就好了。

有的时候重启也不行，不过重置ec肯定是可以的：`ectool reboot_ec cold at-shutdown`。

不太常见，而且难以稳定复现，因此具体产生原因还需要进一步探究。
