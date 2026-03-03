#!/usr/bin/env bash

sudo sed -i 's#NoDisplay=.*#NoDisplay=false#' /usr/share/applications/bytedance-lark.desktop

sudo update-desktop-database
sudo update-desktop-database /usr/share/applications

if [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$DESKTOP_SESSION" = "plasma" ]; then
    kbuildsycoca6 --noincremental
fi

sudo update-mime-database /usr/share/mime

desktop-file-validate /usr/share/applications/bytedance-lark.desktop