#!/usr/bin/env bash

#============================================================
# File: uv.sh
# Description: 安装 UV Python 包管理工具
# URL: https://docs.astral.sh/uv/
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

curl -L https://astral.sh/uv/install.sh | bash
