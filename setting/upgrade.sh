#!/usr/bin/env bash

#============================================================
# File: upgrade.sh
# Description: 系统升级脚本 (支持 DNF/APT)
# URL: https://fx4.cn/upgrade
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

# 检测包管理器并执行系统升级
if command -v dnf &>/dev/null; then
    echo "检测到 DNF 包管理器，正在更新系统..."
    sudo dnf upgrade --refresh -y
elif command -v apt &>/dev/null; then
    echo "检测到 APT 包管理器，正在更新系统..."
    sudo apt update -y
    sudo apt dist-upgrade -y
else
    echo "错误：未检测到支持的包管理器 (dnf 或 apt)" >&2
    exit 1
fi

echo "系统更新完成！"