#!/usr/bin/env bash

#============================================================
# File: go.sh
# Description: 安装 Go 语言环境 (通过 GVM)
# URL: https://go.dev/
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

if [[ ! -f "$HOME/.gvm/env" ]]; then
    curl -L https://fx4.cn/golang | bash

    # shellcheck disable=SC1091
    . "$HOME/.gvm/env"

    gvm use latest    
fi
