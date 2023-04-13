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

# 替换 qBittorrent 增强版，可选从源码编译（Dynamic build）或直接下载二进制文件（Static build）
git clone --depth=1 https://github.com/lxl6125/openwrt-qbittorrent-enhanced package/custom/qbittorrent-enhanced
rm -rf feeds/luci/applications/luci-app-qbittorrent
rm -rf feeds/packages/net/qBittorrent-Enhanced-Edition

# 添加 samba3
git clone --depth=1 https://github.com/lxl6125/luci-app-samba package/custom/samba

# 为 openclash 下载 clash 内核
$GITHUB_WORKSPACE/preset-clash-core.sh amd64

# 为 v2rayA 下载 geoip.dat 、geosite.dat
mkdir -p files/usr/share/xray
wget -P files/usr/share/xray https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
wget -O files/usr/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
chmod 644 files/usr/share/xray/*
