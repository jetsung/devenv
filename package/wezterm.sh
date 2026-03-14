#!/usr/bin/env bash

if command -v dnf &>/dev/null; then
    sudo dnf copr enable -y wezfurlong/wezterm-nightly
    sudo dnf install -y wezterm
elif command -v apt &>/dev/null; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
    sudo apt update
    sudo apt install -y wezterm
fi
