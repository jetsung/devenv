#!/usr/bin/env bash

FLATPAK_ID="io.dbeaver.DBeaverCommunity"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://dbeaver.io/download/"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
