#!/usr/bin/env bash

if command -v dnf &>/dev/null; then
    sudo dnf install -y aria2c
elif command -v apt &>/dev/null; then
    sudo apt install -y aria2
fi
