#!/usr/bin/env bash

#============================================================
# File: websocat.sh
# Description: 安装 Websocat WebSocket 客户端工具
# URL: https://github.com/vi/websocat
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-13
# UpdatedAt: 2026-03-13
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

curl -L https://fx4.cn/websocat | bash
