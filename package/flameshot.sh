#!/usr/bin/env bash

if command -v dnf &>/dev/null; then
    sudo dnf install -y flameshot
elif command -v apt &>/dev/null; then
    sudo apt install -y flameshot
fi
