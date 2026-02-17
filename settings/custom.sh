#!/usr/bin/env bash

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
