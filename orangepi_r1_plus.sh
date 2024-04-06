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

# 添加 OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/custom/luci-app-openclash

# 下载 clash 内核
$GITHUB_WORKSPACE/preset-clash-core.sh arm64

# 添加 qBittorrent 增强版
git clone --depth=1 https://github.com/lxl6125/openwrt-qbittorrent-enhanced package/custom/qbittorrent-enhanced
# (临时)
sed -i 's/1.2.18/1.2.19/g' package/feeds/packages/rblibtorrent/Makefile
sed -i 's/855c44be6370dc90ec1f3dff4223770dd47a5208/aa9512a5ea1b723c7a57b77ad117da79608ea2fc/g' package/feeds/packages/rblibtorrent/Makefile
sed -i 's/da0626afc80287c8ee6825bfed2d52fe24e8fd9abff9952034292bdc00a2dac1/94de09d468ecc0b211ee261a1e8815f02057e97296e9e7d23951d3e291b062be/g' package/feeds/packages/rblibtorrent/Makefile

# 添加 alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/custom/alist

# 添加 ddns-go
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/custom/ddns-go

# 替换 argon 主题
rm -rf feeds/luci/themes/luci-theme-argon feeds/luci/applications/luci-app-argon-config
git clone --depth=1 -b 18.06 --single-branch https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argon
git clone --depth=1 -b 18.06 --single-branch https://github.com/jerrykuku/luci-app-argon-config feeds/luci/applications/luci-app-argon-config

