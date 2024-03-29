#!/usr/bin/env bash

##
# docker
##

# SH_START

## include.sh START
# shellcheck disable=SC2034

set -e
set -u
set -o pipefail

exec 3>&1

script_name=$(basename "$0")

if [ -t 1 ] && command -v tput >/dev/null; then
  ncolors=$(tput colors || echo 0)
  if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    bold="$(tput bold || echo)"
    normal="$(tput sgr0 || echo)"
    black="$(tput setaf 0 || echo)"
    red="$(tput setaf 1 || echo)"
    green="$(tput setaf 2 || echo)"
    yellow="$(tput setaf 3 || echo)"
    blue="$(tput setaf 4 || echo)"
    magenta="$(tput setaf 5 || echo)"
    cyan="$(tput setaf 6 || echo)"
    white="$(tput setaf 7 || echo)"
  fi
fi

say_warning() {
  printf "%b\n" "${yellow:-}${script_name}: Warning: $1${normal:-}" >&3
}

say_err() {
  printf "%b\n" "${red:-}${script_name}: Error: $1${normal:-}" >&2
  exit 1
}

say() {
  printf "%b\n" "${cyan:-}${script_name}:${normal:-} $1" >&3
}

# sh echo
sh_echo() {
  command printf %s\\n "$*" 2>/dev/null
}

# try profile
try_profile() {
  if [ -z "${1-}" ] || [ ! -f "${1}" ]; then
    return 1
  fi
  sh_echo "${1}"
}

# Get PROFILE
detect_profile() {
  if [[ "${PROFILE-}" = '/dev/null' ]]; then
    # the user has specifically requested NOT to have nvm touch their profile
    return
  fi

  if [ -n "${PROFILE}" ] && [ -f "${PROFILE}" ]; then
    sh_echo "${PROFILE}"
    return
  fi

  DETECTED_PROFILE=''
  if [ "${SHELL#*bash}" != "$SHELL" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    fi
  elif [ "${SHELL#*zsh}" != "$SHELL" ]; then
    if [ -f "$HOME/.zshrc" ]; then
      DETECTED_PROFILE="$HOME/.zshrc"
    fi
  fi

  if [ -z "$DETECTED_PROFILE" ]; then
    for EACH_PROFILE in ".profile" ".bashrc" ".bash_profile" ".zshrc"; do
      if DETECTED_PROFILE="$(try_profile "${HOME}/${EACH_PROFILE}")"; then
        break
      fi
    done
  fi

  if [ -n "$DETECTED_PROFILE" ]; then
    sh_echo "$DETECTED_PROFILE"
  fi
}

# fix macos
sedi() {
  if [[ "${OS_TYPE:-unknown}" = "darwin" ]]; then
    sed -i "" "$@"
  else
    sed -i "$@"
  fi
}

# get OS
get_os() {
  OS_TYPE=$(uname | tr '[:upper:]' '[:lower:]')
  case $OS_TYPE in
  darwin) OS_TYPE='darwin' ;;
  linux) OS_TYPE='linux' ;;
  freebsd) OS_TYPE='freebsd' ;;
    #        mingw*) OS_TYPE='windows';;
    #        msys*) OS_TYPE='windows';;
  *)
    printf "\e[1;31mOS %s is not supported by this installation script\e[0m\n" "${OS}"
    exit 1
    ;;
  esac
}

# get Arch
get_arch() {
  ARCH_TYPE=$(uname -m)
  ARCH_BIT="$ARCH_TYPE"

  case "$ARCH_TYPE" in
  i386) ARCH_TYPE="386" ;;
  amd64) ARCH_TYPE="x64" ;;
  x86_64) ARCH_TYPE="x64" ;;
  armv6l) ARCH_TYPE="armv6l" ;;
  armv7l) ARCH_TYPE="armv7l" ;;
  arm64) ARCH_TYPE="arm64" ;;
  aarch64) ARCH_TYPE="arm64" ;;
  *)
    printf "\e[1;31mArchitecture %s is not supported by this installation script\e[0m\n" "$ARCH_TYPE"
    exit 1
    ;;
  esac
}

# get github latest
get_latest_github() {
  __GHPROXY_URL=""
  if [ -n "${GH_PROXY_URL:-}" ]; then
    __GHPROXY_URL="$GH_PROXY_URL"
  fi
  curl -sL "${__GHPROXY_URL}https://api.github.com/repos/${1}/releases/latest" | grep '"tag_name":' | cut -d'"' -f4
}

# pkg manager tool
pkg_manager_tool() {
  PKG_TOOL_NAME=""
  if command_exists yum; then
    PKG_TOOL_NAME="yum"
  elif command_exists apt-get; then
    PKG_TOOL_NAME="apt"
  elif command_exists brew; then
    PKG_TOOL_NAME="brew"
  fi
}

# command_exists
command_exists() {
  # shell script can't found.
  # which "$@" > /dev/null 2>&1
  command -v "$@" >/dev/null 2>&1
  # command not found: xxx
}

# check in china
check_in_china() {
  IN_CHINA=""
  if ! curl -s -m 3 -IL https://google.com | grep -q "HTTP/2 200"; then
    IN_CHINA=1
  fi
}

# install curl,wget command
install_dl_command() {
  pkg_manager_tool

  if ! command_exists curl; then
    if [[ "$PKG_TOOL_NAME" = "yum" ]]; then
      sudo yum install -y curl wget
    elif [[ "$PKG_TOOL_NAME" = "apt" ]]; then
      sudo apt install -y curl wget
    else
      say_err "You must pre-install the curl,wget tool"
    fi
  fi
}

# download file
download_file() {
  url="${1}"
  destination="${2}"

  # printf "Fetching ${url} \n\n"

  if command_exists curl; then
    code=$(curl --connect-timeout 15 -w '%{http_code}' -L "${url}" -o "${destination}")
  elif command_exists wget; then
    code=$(wget -t2 -T15 -O "${destination}" --server-response "${url}" 2>&1 | awk '/^  HTTP/{print $2}' | tail -1)
  else
    printf "\e[1;31mNeither curl nor wget was available to perform http requests.\e[0m\n"
    exit 1
  fi

  if [[ "$code" != "200" ]]; then
    printf "\e[1;31mRequest failed with code %s\e[0m\n" "$code"
    exit 1
    # else
    #     printf "\n\e[1;33mDownload succeeded\e[0m\n"
  fi
}

# install curl command
install_curl_command() {
  if ! test -x "$(command -v curl)"; then
    if test -x "$(command -v yum)"; then
      yum install -y curl
    elif test -x "$(command -v apt)"; then
      apt install -y curl
    else
      say_err "You must pre-install the curl tool\n"
    fi
  fi
}

# create folder
create_folder() {
  if [ -n "${1}" ]; then
    local MYPATH="${1}"
    local REAL_PATH=${MYPATH/\$HOME/$HOME}
    [ -d "$REAL_PATH" ] || mkdir "$REAL_PATH"
    __TMP_PATH="$REAL_PATH"
  fi
}

# Download file and unpack
download_unpack() {
  local downurl="$1"
  local savepath="$2"

  printf "Fetching %s \n\n" "$downurl"

  curl -Lk --connect-timeout 30 --retry 5 --retry-max-time 360 --max-time 300 "$downurl" | gunzip | tar xf - --strip-components=1 -C "$savepath"
}

# compare version size
version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "${1}"; }

## include.sh END
# SH_END

set_environment() {
    if [[ $(id -u) -eq 0 ]]; then
        set_environment_root
    else
        set_environment_rootless
    fi
}

set_environment_root() {
    if [ -n "$IN_CHINA" ]; then
        [ -d /etc/docker ] || mkdir -p /etc/docker
        tee /etc/docker/daemon.json >/dev/null 2>&1 <<-EOF
{
  "registry-mirrors": [$MIRROR_DOCKER]
}
EOF
        systemctl daemon-reload
        systemctl restart docker
    fi
}

set_environment_rootless() {
    if [ -n "$IN_CHINA" ]; then
        [ -d "$HOME"/.config/docker ] || mkdir -p "$HOME"/.config/docker
        tee "$HOME"/.config/docker/daemon.json >/dev/null 2>&1 <<-EOF
{
  "registry-mirrors": [$MIRROR_DOCKER]
}
EOF
        systemctl --user restart docker
    fi
}

show_info() {
    docker info
}

install() {
    if [ -n "$IN_CHINA" ]; then
        export DOWNLOAD_URL="$DOWNLOAD_URL"
        curl -fsSL https://get.docker.com | sh
    else
        curl -s https://get.docker.com/ | sh
    fi

    # rootless
    if [[ $(id -u) -ne 0 ]]; then
        dockerd-rootless-setuptool.sh install
    fi
}

DOWNLOAD_URL="https://mirrors.bfsu.edu.cn/docker-ce"
MIRROR_DOCKER='"https://05f073ad3c0010ea0f4bc00b7105ec20.mirror.swr.myhuaweicloud.com","https://mirror.ccs.tencentyun.com","http://f1361db2.m.daocloud.io", "http://hub-mirror.c.163.com"'

IN_CHINA=""
check_in_china

OS_TYPE=""
get_os
if [[ "$OS_TYPE" != "linux" ]]; then
    say_err "Only support linux. \nYour OS: $OS_TYPE"
fi

if command_exists docker; then
    say "Docker has installed"
    if [ -z "$__UPGRADE" ]; then
        show_info
        exit
    fi
else
    install
fi

set_environment
