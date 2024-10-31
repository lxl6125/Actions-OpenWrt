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

# 添加 PassWall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/custom/passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/custom/luci-app-passwall
rm -rf feeds/packages/net/v2ray-geodata

# 添加 OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/custom/luci-app-openclash

# 下载 clash 内核
$GITHUB_WORKSPACE/preset-clash-core.sh amd64

# 添加 qBittorrent 增强版
git clone --depth=1 https://github.com/lxl6125/openwrt-qbittorrent-enhanced package/custom/qbittorrent-enhanced
rm -rf feeds/packages/libs/libtorrent-rasterbar

# 添加 alist
git clone --depth=1 -b lua --single-branch https://github.com/sbwml/luci-app-alist package/custom/alist
rm -rf feeds/packages/net/alist

# 添加 ddns-go
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/custom/ddns-go
rm -rf feeds/packages/net/ddns-go

# 替换 argon 主题
rm -rf feeds/luci/themes/luci-theme-argon feeds/luci/applications/luci-app-argon-config
git clone --depth=1 -b 18.06 --single-branch https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argon
git clone --depth=1 -b 18.06 --single-branch https://github.com/jerrykuku/luci-app-argon-config feeds/luci/applications/luci-app-argon-config
