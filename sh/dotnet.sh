#!/usr/bin/env bash

load_vars() {
	# Set environmental
	PROFILE="${HOME}/.bashrc"

	# DOTNET_PATH
	DOTNET_ROOT="\$HOME/.dotnet"
	SAVE_PATH="${HOME}/.dotnet"

	INSTALL_URL="https://dot.net/v1"
}

show_info() {
    source "${PROFILE}"

	dotnet --version
}

install() {
	bash <(curl -fsSL ${INSTALL_URL}/dotnet-install.sh) -c 7.0
}

set_environment() {
	if [[ -z "`grep '## DOTNET' ${PROFILE}`" ]];then
		echo -e "\n## DOTNET" >> "${PROFILE}"
	fi

	if [[ -z "`grep 'export\sDOTNET_ROOT' ${PROFILE}`" ]];then
		echo "export DOTNET_ROOT=\"${DOTNET_ROOT}\"" >> "${PROFILE}"
	else
		sed -i "s@^export DOTNET_ROOT.*@export DOTNET_ROOT=\"${DOTNET_ROOT}\"@" "${PROFILE}"
	fi

	if [[ -z "`grep 'export\sPATH=\"\$PATH:\$DOTNET_ROOT\"' ${PROFILE}`" ]];then
		echo "export PATH=\"\$PATH:\$DOTNET_ROOT\"" >> "${PROFILE}"
	fi

    [[ -n "${1}" ]] || show_info
}

load_include() {
    realpath=$(dirname "`readlink -f $0`")

	include_tmp_path="/tmp/include_devenv.sh"
	include_file_url="https://jihulab.com/jetsung/devenv/raw/main/sh/include.sh"
	if [[ -f "${realpath}/include.sh" ]]; then
    	. ${realpath}/include.sh
	elif [[ -f "${include_tmp_path}" ]]; then
		. "${include_tmp_path}"
	else
		curl -sL -o "${include_tmp_path}" "${include_file_url}"
		[[ -f "${include_tmp_path}" ]] && . "${include_tmp_path}"
	fi
}

main() {
	load_include

	load_vars

    [[ "${1}" = "upgrade" ]] && rm -rf "${SAVE_PATH}"

	if command_exists dotnet; then
		pass_message "dotnet has installed"

        if [[ -z "${1}" ]]; then
    		show_info
		    return
        fi
	else
        install
    fi	

    set_environment "${1}"
}

main "$@" || exit 1
