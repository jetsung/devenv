#!/usr/bin/env bash

curl -L "https://bitwarden.com/download/?app=desktop&platform=linux&variant=rpm" -o /tmp/bitwarden.rpm

sudo dnf install -y "/tmp/bitwarden.rpm"