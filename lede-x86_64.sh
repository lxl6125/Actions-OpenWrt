#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Add kernel build user
sed -i '/CONFIG_KERNEL_BUILD_USER/d' .config &&
    echo 'CONFIG_KERNEL_BUILD_USER="lxl6125"' >>.config

# Add kernel build domain
sed -i '/CONFIG_KERNEL_BUILD_DOMAIN/d' .config &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config

# 修复因 Docker 导致的 UDP 代理失效，但此步骤会导致 Docker 内部无法代理 UDP 请求，因此需要手动下发默认 DNS 服务器。
cat >> package/base-files/files/etc/sysctl.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
EOF

# 替换 PassWall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/custom/passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/custom/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/xray-core

# 替换 OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/custom/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-openclash

# 下载 clash 内核
$GITHUB_WORKSPACE/preset-clash-core.sh amd64

# 添加 qBittorrent 增强版
git clone --depth=1 https://github.com/lxl6125/openwrt-qbittorrent-enhanced package/custom/qbittorrent-enhanced
rm -rf feeds/packages/libs/libtorrent-rasterbar

# 替换 alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/custom/alist
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/alist

# 替换 v2raya
git clone --depth=1 https://github.com/v2rayA/v2raya-openwrt package/custom/tmp
mkdir package/custom/v2raya
mv package/custom/tmp/luci-app-v2raya package/custom/v2raya
mv package/custom/tmp/v2raya package/custom/v2raya
rm -rf package/custom/tmp
rm -rf feeds/luci/applications/luci-app-v2raya
rm -rf feeds/packages/net/v2raya
mkdir -p files/usr/share/xray
wget -P files/usr/share/xray https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
wget -O files/usr/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
chmod 644 files/usr/share/xray/*

# 添加 luci-app-argon-config
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/custom/luci-app-argon-config
