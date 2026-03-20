#!/usr/bin/env bash

#============================================================
# File: zed.sh
# Description: 安装 Zed 编辑器
# URL: https://zed.dev/
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

curl -L fx4.cn/zed | bash -s -- -p