#!/usr/bin/env bash

#============================================================
# File: volta.sh
# Description: 安装 Volta JavaScript 工具链管理器
# URL: https://volta.sh/
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

curl https://get.volta.sh | bash
