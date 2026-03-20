#!/usr/bin/env bash

#============================================================
# File: proxychains.sh
# Description: 安装 Proxychains 代理工具
# URL: https://github.com/rofl0r/proxychains-ng
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-03-03
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

curl -L fx4.cn/proxychains | bash