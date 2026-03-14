#!/usr/bin/env bash

if command -v dnf &>/dev/null; then
    sudo dnf install -y zsh
elif command -v apt &>/dev/null; then
    sudo apt install -y zsh
fi
