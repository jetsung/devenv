#!/usr/bin/env bash

#============================================================
# File: just.sh
# Description: 安装 Just LSP 语言服务器
# URL: https://github.com/Soares/just-lsp
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

cargo install just-lsp