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
rm -rf feeds/packages/net/{chinadns-ng,dns2socks,geoview,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadow-tls,simple-obfs,sing-box,tcping,trojan-plus,tuic-client,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin}

# 替换 OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/custom/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-openclash

# 为 OpenClash 下载 clash 内核
$GITHUB_WORKSPACE/preset-clash-core.sh amd64-v1

# 替换 OpenList
git clone --depth=1 https://github.com/OpenListTeam/OpenList-OpenWRT package/custom/openlist
rm -rf feeds/luci/applications/luci-app-openlist
rm -rf feeds/packages/net/openlist

# 替换 qBittorrent 增强版，可选从源码编译（Dynamic build）或直接下载二进制文件（Static build）
git clone --depth=1 https://github.com/lxl6125/openwrt-qbittorrent-enhanced package/custom/qbittorrent-enhanced
rm -rf feeds/luci/applications/luci-app-qbittorrent
rm -rf feeds/packages/net/qBittorrent-Enhanced-Edition
