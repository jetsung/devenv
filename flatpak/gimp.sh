#!/usr/bin/env bash

FLATPAK_ID="org.gimp.GIMP"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://www.gimp.org/downloads/"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
