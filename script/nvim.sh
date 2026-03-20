#!/usr/bin/env bash

#============================================================
# File: nvim.sh
# Description: 安装 Neovim 编辑器
# URL: https://neovim.io/
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

curl -L https://fx4.cn/nvim | bash
