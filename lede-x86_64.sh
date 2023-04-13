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

# 替换 PassWall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/custom/passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/custom/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/chinadns-ng
rm -rf feeds/packages/net/sing-box
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/xray-core

# 替换 OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/custom/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-openclash

# 为 openclash 下载 clash 内核
$GITHUB_WORKSPACE/preset-clash-core.sh amd64

# 添加 luci-app-argon-config
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/custom/luci-app-argon-config

# 添加 qbittorrent 增强版，可选从源码编译（Dynamic build）或直接下载二进制文件（Static build）
git clone --depth=1 https://github.com/lxl6125/openwrt-qbittorrent-enhanced package/custom/qbittorrent-enhanced
rm -rf feeds/luci/applications/luci-app-qbittorrent
rm -rf feeds/packages/libs/libtorrent-rasterbar

# 替换 alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/custom/alist
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/alist

# 替换 v2rayA 并下载 geoip.dat 、geosite.dat
git clone --depth=1 https://github.com/v2rayA/v2raya-openwrt package/custom/tmp
mkdir package/custom/v2raya
mv package/custom/tmp/luci-app-v2raya package/custom/v2raya
mv package/custom/tmp/v2raya package/custom/v2raya
rm -rf package/custom/tmp
rm -rf feeds/luci/applications/luci-app-v2raya
rm -rf feeds/packages/net/v2raya
mkdir -p files/usr/share/xray
wget -O files/usr/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
wget -O files/usr/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
chmod 644 files/usr/share/xray/*
