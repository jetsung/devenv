#!/usr/bin/env bash

mkdir -p ~/.config/autostart && cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart

# /etc/profile.d/fcitx5.sh
{
    echo 'export INPUT_METHOD=fcitx'
    echo 'export GTK_IM_MODULE=fcitx'
    echo 'export QT_IM_MODULE=fcitx'
    echo 'export XMODIFIERS=@im=fcitx'
    echo 'export QT_QPA_PLATFORM=xcb'
} > /etc/profile.d/fcitx5.sh

fcitx5-diagnose

