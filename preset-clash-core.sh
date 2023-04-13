#!/bin/bash
mkdir -p files/etc/openclash/core

CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-${1}.tar.gz"

wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta

chmod +x files/etc/openclash/core/clash*
