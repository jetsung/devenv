#!/usr/bin/env bash

#============================================================
# File: keygen.sh
# Description: 生成 SSH Ed25519 密钥对
# URL: https://fx4.cn/keygen
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
ssh-keygen -t ed25519 -C "${_hostname:-linux}"
