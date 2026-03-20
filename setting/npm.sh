#!/usr/bin/env bash

#============================================================
# File: npm.sh
# Description: 配置 npm 使用国内镜像源
# URL: https://npmjs.org/
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

if ! command -v npm &> /dev/null; then
    echo "提示: 未安装 npm，请先安装 Node.js"
    exit 0
fi

npm config set registry https://registry.npmmirror.com