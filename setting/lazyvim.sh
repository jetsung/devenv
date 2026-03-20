#!/usr/bin/env bash

#============================================================
# File: lazyvim.sh
# Description: 安装 LazyVim Neovim 配置框架
# URL: https://www.lazyvim.org/
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

if [[ -d "$HOME/.config/nvim" ]]; then
    if [[ -f "$HOME/.config/nvim/lazyvim.json" ]]; then
        pushd "$HOME/.config/nvim" >/dev/null || exit
        git pull
        popd >/dev/null || exit
    else
        mv "$HOME"/.config/nvim{,.bak}
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"

        mv "$HOME"/.local/share/nvim{,.bak}
        mv "$HOME"/.local/state/nvim{,.bak}
        mv "$HOME"/.cache/nvim{,.bak}        
    fi
else
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
fi