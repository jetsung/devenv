#!/usr/bin/env bash

#============================================================
# File: wezterm.sh
# Description: 下载 WezTerm 配置文件
# URL: https://wezfurlong.org/wezterm/
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

curl -fsSL --create-dirs -o "$HOME/.config/wezterm/wezterm.lua" --location https://gist.asfd.cn/jetsung/wezterm/raw/HEAD/wezterm.lua
