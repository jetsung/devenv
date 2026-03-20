#!/usr/bin/env bash

#============================================================
# File: rclone.sh
# Description: 安装 Rclone 云存储同步工具
# URL: https://rclone.org/
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

curl -L fx4.cn/x | bash -s -- https://rclone.org/install.sh | sudo bash
