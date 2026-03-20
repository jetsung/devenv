#!/usr/bin/env bash

#============================================================
# File: just.sh
# Description: 安装 Just 命令运行器
# URL: https://github.com/casey/just
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

# shellcheck disable=SC1091
if [[ -f .env ]]; then
    source ./.env
fi

curl -L fx4.cn/just | bash
