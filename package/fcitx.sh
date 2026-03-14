#!/usr/bin/env bash

if command -v dnf &>/dev/null; then
    sudo dnf install -y fcitx5 \
        fcitx5-autostart \
        fcitx5-chinese-addons \
        fcitx5-configtool \
        fcitx5-gtk \
        fcitx5-qt \
        fcitx5-rime \
        kcm-fcitx5
elif command -v apt &>/dev/null; then
    sudo apt install -y fcitx5 \
        fcitx5-autostart \
        fcitx5-chinese-addons \
        fcitx5-config-qt \
        fcitx5-gtk \
        fcitx5-qt \
        fcitx5-rime \
        kcm-fcitx5
fi
