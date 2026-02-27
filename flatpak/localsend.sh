#!/usr/bin/env bash

FLATPAK_ID="org.localsend.localsend_app"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://localsend.org/download"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
