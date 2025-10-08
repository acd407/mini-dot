# 使用原生工具管理 Linux 网桥：统一虚拟化网络环境

## 背景介绍

在 Linux 环境中，许多虚拟化和容器化工具（如 LXC、Waydroid、libvirt、GNS3 等）在连接网络时都支持使用网桥（Bridge）模式。这些应用通常会自动创建并管理自己的网桥，导致系统中出现多个独立且命名各异的虚拟网桥。使用 `ip link` 查看时，往往会看到杂乱无章的虚拟网络设备，这不仅影响可读性，也为统一管理带来困难。

更重要的是，每个应用独立管理网桥会带来以下问题：
- 难以统一分配和修改 IP 地址段、网关等网络参数；
- 不利于实现服务统一暴露和管理（例如部署一个本地 nginx 服务器）；
- DHCP 服务分散，难以做统一的地址分配与策略管理。

如果能够让这些应用统一使用一个由用户管理的网桥，将极大提升本地开发、测试和服务部署的效率。

---

## 常用软件接入自定义网桥的配置方法

如果你已经有一个自管理的网桥，可以如下配置常用软件来接入它。

### LXC 的配置

LXC 允许用户通过修改配置文件来指定容器所使用的网桥。具体可参考 https://zhuanlan.zhihu.com/p/1951768488260637015。

- 对于新创建的容器：可编辑 `~/.config/lxc/default.conf`，修改或添加如下行：
```
lxc.net.0.link = br0
```
- 对于已存在的容器：每个容器的配置独立存储。可通过以下命令查找容器路径：
```bash
lxc-config lxc.lxcpath
```
  例如路径若为 `/home/user/.local/share/lxc`，则容器的配置文件路径为：
```
/home/user/.local/share/lxc/容器名/config
```
  编辑该文件，修改 `lxc.net.0.link` 的值为你的网桥名称（如 `br0`）即可。

### Waydroid 的配置

早期版本的 Waydroid 修改网桥较为麻烦，需直接修改 `/usr/lib/waydroid/data/scripts/waydroid-net.sh`，并在每次更新后重新调整。但从 https://github.com/waydroid/waydroid/commit/5f808b2614592ba7f85acb1b7ff297840b26e674 开始，Waydroid 开始支持外部管理网桥。

现在只需编辑以下文件：
```
/var/lib/waydroid/lxc/waydroid/config
```
将其中的 `lxc.net.0.link` 值修改为你的自定义网桥（如 `br0`）即可。Waydroid 在启动时如果发现该配置不是默认的 `waydroid0`，就会认为该网桥由外部管理，不再自动创建或修改网桥设备。

### libvirt 的配置

如果你使用 virt-manager 管理虚拟机，配置使用自定义网桥非常简单：

1. 打开虚拟机设置，选择 “NIC” 设备；
2. 将“网络源”设置为“桥接设备”；
3. 在设备名称中填入你的网桥名（如 `br0`）。

如需通过 XML 手动配置，可在 `interface` 字段中指定：
```xml
<interface type='bridge'>
  <source bridge='br0'/>
</interface>
```

---

## 使用 systemd 原生工具配置 Linux 网桥

下面我们介绍如何使用 systemd-networkd、systemd-resolved 和 nftables 这一套 Linux 主流发行版原生支持的工具，配置一个功能完整的网桥 `br0`，并实现 DHCP、IPv6 路由通告和 NAT 等功能。

### 第一步：创建网桥设备

创建 `/etc/systemd/network/br0.netdev`，写入如下内容：

```ini
[NetDev]
Name=br0
Kind=bridge
```

该文件指示 systemd-networkd 创建一个名为 `br0` 的网桥设备。注意此时它仍是一个二层设备（类似“交换机”），还不具备 IP 分配或路由功能。

### 第二步：为网桥配置网络与 DHCP

创建 `/etc/systemd/network/br0.network`，配置如下：

```ini
[Match]
Name=br0

[Link]
ARP=yes

[Network]
Description=Custom Bridge Network
# 指定 IPv4 地址与子网
Address=192.168.16.1/24
# 启用内置 DHCPv4 服务器
DHCPServer=yes
# 指定 IPv6 ULA 地址
Address=fd00::1/64
# 启用 IPv6 路由通告（RA）与前缀分发
IPv6SendRA=yes
DHCPPrefixDelegation=yes
# 启用多播 DNS
MulticastDNS=yes
# 即使无物理接口接入也维持配置
ConfigureWithoutCarrier=yes

[DHCPServer]
# 指定 DNS 服务器（这里指向网桥自身）
DNS=192.168.16.1
# DHCP 地址池从 .10 开始，分配 90 个地址
PoolOffset=10
PoolSize=90

[IPv6SendRA]
# 指定 IPv6 环境使用的 DNS 服务器
DNS=fd00::1

[IPv6Prefix]
# 下发的前缀
Prefix=fd00::/64
PreferredLifetimeSec=86400
ValidLifetimeSec=172800
```

配置完成后，重启服务以生效：
```bash
sudo systemctl restart systemd-networkd systemd-resolved
```

至此，你已经获得一个具备 DHCPv4/v6 和路由通告功能的“虚拟路由器”，可为接入设备分配 IP 并提供本地 DNS。

### 第三步：配置 NAT 实现互联网共享

若要允许网桥中的设备访问外网，需配置 NAT（网络地址转换）规则。我们使用 nftables 实现。

编辑 `/etc/nftables.conf`，加入以下内容：

```nft
table inet nat {
    chain forward {
        type filter hook forward priority filter; policy drop;
        # 允许已建立连接或相关的数据包通过
        ct state vmap { established : accept, related : accept, invalid : drop }
        # 允许从 br0 发起的转发
        iifname "br0" accept
    }

    chain postrouting {
        type nat hook postrouting priority srcnat;
        # 对来自 br0 且出口不是 br0 的流量做 MASQUERADE
        iifname "br0" oifname != "br0" masquerade
    }
}
```

启用并启动 nftables 服务：
```bash
sudo systemctl enable --now nftables.service
```

该配置实现了以下功能：
- 允许从 `br0` 发起的转发流量；
- 在数据包离开本机前进行源地址伪装（MASQUERADE），实现 NAT 出站。

> 🔍 如需深入理解 nftables 和 Netfilter 的工作机制，推荐阅读：
> - https://wiki.nftables.org/wiki-nftables/index.php/Main_Page
> - https://thermalcircle.de/doku.php?id=blog:linux:nftables_packet_flow_netfilter_hooks_detail
> - https://thermalcircle.de/doku.php?id=blog:linux:connection_tracking_1

---

## 总结

通过 systemd-networkd 和 nftables 的组合，我们实现了一个完全由系统原生工具管理的网桥环境，具备 DHCP、IPv6 路由通告和 NAT 等路由器的基本功能。此后，LXC、Waydroid、libvirt 等应用均可统一接入该网桥，实现 IP 管理、服务暴露和网络策略的统一管理。

这种方案不仅干净、易于维护，也更利于理解 Linux 网络的基本原理和工作流程。

---
**注意**：执行任何网络配置更改前，请确保你有其他方式访问主机（如通过物理终端或 console），以免误配置导致失去网络连接。

如果你在使用其他虚拟化或容器工具，也欢迎在评论区分享接入自定义网桥的方法。

---
*本文使用 CC BY-SA 4.0 许可，欢迎转载与修改，请注明出处。*
