#!/usr/bin/env bash

#============================================================
# File: git.sh
# Description: 配置 Git 用户信息和 GPG 签名
# URL: https://git-scm.com/
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

read -r -p "Git Name: " name
read -r -p "Git Email: " email
read -r -p "GPG ID: " gpg_id

name=${name:-"Jetsung Chan"}
email=${email:-"jetsungchan@gmail.com"}

git config --global user.name "$name"
git config --global user.email "$email"

if [[ -n "$gpg_id" ]]; then
    # 检查 GPG ID 是否存在于 GPG 列表中
    if gpg --list-secret-keys --keyid-format=long | grep -q "$gpg_id"; then
        echo "GPG ID found. Setting signing key..."
        git config --global user.signingkey "$gpg_id"
        git config --global commit.gpgsign true
        echo "GPG signing enabled with key: $gpg_id"
    else
        echo "GPG ID '$gpg_id' not found in your GPG key list."
        echo "Available GPG secret keys:"
        gpg --list-secret-keys --keyid-format=long
        echo "Skipping GPG signing configuration."
    fi
fi

git config --global init.defaultBranch main

git config --global --add safe.directory '*'

# 检查 ~/workspaces/flydo/ 目录是否存在，如果存在则添加 includeIf 配置
if [[ -d ~/workspaces/flydo/ ]] && [[ -f ~/.gitconfig_flydo ]]; then
    echo "Directory ~/workspaces/flydo/ exists. Setting includeIf configuration..."
    git config --global includeIf."gitdir:~/workspaces/flydo/".path ~/.gitconfig_flydo
    echo "includeIf configuration added successfully."

    git config --file ~/.gitconfig_flydo core.sshCommand "ssh -i ~/.ssh/id_ed25519_flydo"
fi

