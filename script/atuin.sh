#!/usr/bin/env bash

#============================================================
# File: atuin.sh
# Description: 安装 Atuin 历史记录同步工具
# URL: https://atuin.sh/
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

curl -L https://fx4.cn/atuin | bash
