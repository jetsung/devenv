#!/usr/bin/env bash

if command -v dnf &>/dev/null; then
    sudo dnf install -y obs-studio
elif command -v apt &>/dev/null; then
    sudo apt install -y obs-studio
fi
