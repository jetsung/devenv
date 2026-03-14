#!/usr/bin/env bash

_hostname=$(hostnamectl | grep "Operating System" | awk '{print $3}' | tr '[:upper:]' '[:lower:]')
ssh-keygen -t ed25519 -C "${_hostname:-linux}"
