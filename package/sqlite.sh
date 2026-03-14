#!/usr/bin/env bash

if command -v dnf &>/dev/null; then
    sudo dnf install -y sqlite3
elif command -v apt &>/dev/null; then
    sudo apt install -y sqlite3
fi
