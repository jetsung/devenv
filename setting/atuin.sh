#!/usr/bin/env bash

#============================================================
# File: atuin.sh
# Description: 配置 Atuin 历史记录同步工具
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
