# vim: ft=bash

lxc-create --name debian --template download -- --dist debian --release trixie --arch amd64
lxc-start debian
lxc-attach -n debian --clear-env --set-var TERM=linux

sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
apt update
apt install wget curl git vis fastfetch vivid fish foot-terminfo gpg openssh-server lsof

useradd -m -u 1000 -s /usr/bin/fish acd407
passwd acd407
sudo usermod -aG sudo acd407

cp .ssh/ .local/share/lxc/debian/rootfs/home/acd407/ -r

lxc-attach -n debian --clear-env --set-var TERM=foot -u 1000
git clone git@github.com:acd407/mini-dot.git
rm -r .config/ && mv mini-dot/ .config/
