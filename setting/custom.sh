#!/usr/bin/env bash

#============================================================
# File: custom.sh
# Description: 自定义环境配置脚本
# URL: https://fx4.cn/custom
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

_command() {
    sudo dnf install -y xsel
}

main() {
    if [[ -d "$$HOME/.envs" ]]; then
        git clone git@ssh.asfd.cn:jetsung/envs.git -b linux "$HOME/.envs"
    fi

    if [[ -d "$$HOME/.envs" ]]; then
        git clone git@ssh.asfd.cn:jetsung/envs.git -b bash "$HOME/.local/scripts"
    fi
}

main "$@"
