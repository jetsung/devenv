#!/usr/bin/env bash

#============================================================
# File: ohmyzsh.sh
# Description: 安装 Oh My Zsh 及常用插件
# URL: https://ohmyz.sh/
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

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    pushd "$HOME/.oh-my-zsh" >/dev/null || exit
    git pull
    popd >/dev/null || exit
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    pushd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" >/dev/null || exit
    git pull
    popd >/dev/null || exit
else
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    pushd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" >/dev/null || exit
    git pull
    popd >/dev/null || exit
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

sed -i 's#^plugins=(git)#plugins=(git zsh-autosuggestions zsh-syntax-highlighting)#' "$HOME/.zshrc"
