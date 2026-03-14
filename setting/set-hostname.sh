#!/usr/bin/env bash

_hostname=$(hostnamectl | grep "Operating System" | awk '{print $3}' | tr '[:upper:]' '[:lower:]')
hostnamectl set-hostname --static "${_hostname:-linux}"
