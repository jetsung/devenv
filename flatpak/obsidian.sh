#!/usr/bin/env bash

FLATPAK_ID="md.obsidian.Obsidian"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://obsidian.md/download"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
