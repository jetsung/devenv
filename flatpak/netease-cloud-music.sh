#!/usr/bin/env bash

FLATPAK_ID="com.github.gmg137.netease-cloud-music-gtk"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://github.com/gmg137/netease-cloud-music-gtk"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
