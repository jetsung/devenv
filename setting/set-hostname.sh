#!/usr/bin/env bash

#============================================================
# File: set-hostname.sh
# Description: 根据操作系统设置主机名
# URL: https://fx4.cn/set-hostname
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-03-14
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

_hostname=$(hostnamectl | grep "Operating System" | awk '{print $3}' | tr '[:upper:]' '[:lower:]')
hostnamectl set-hostname --static "${_hostname:-linux}"
