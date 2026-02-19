#!/usr/bin/env bash

set -euo pipefail

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