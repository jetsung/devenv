#!/usr/bin/env bash

curl -L https://get.docker.com | bash -s -- --mirror Aliyun

dockerd-rootless-setuptool.sh install