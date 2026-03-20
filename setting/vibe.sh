#!/usr/bin/env bash

#============================================================
# File: vibe.sh
# Description: 安装 Vibe 工具
# URL: https://fx4.cn/vibe
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

curl -L fx4.cn/vibe | bash