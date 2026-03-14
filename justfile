set shell := ["bash", "-c"]

# 备份数据到腾讯云存储（COS）
datasync:
    cd "$$HOME/myfiles" && rclone-datasync.sh

# 基础安装 install <包名>
install package:
    @if [[ "{{package}}" == "all" ]]; then \
        echo "Installing all packages..." ; \
        find . -mindepth 2 -maxdepth 2 -type f -name "*.sh" -not -path "./setting/*" -not -path "./utils/*" -not -path "./.*" -exec bash -c 'script="$1"; echo "Installing $(basename "$script" .sh)..."; bash "$script"' _ {} \; ;\
    else \
        find . -mindepth 2 -maxdepth 2 -type f -name "*{{package}}*" -not -path "./setting/*" -not -path "./utils/*" -not -path "./.*" -exec bash -c 'script="$1"; echo "Installing $(basename "$script" .sh)..."; bash "$script"' _ {} \; ;\
    fi

# 搜索可安装的软件
search package:
	@echo "=== Available Application ==="; \
	find . -mindepth 2 -maxdepth 2 -type f -name "*{{package}}*" -not -path "./.git/*" -not -path "./utils/*" -not -path "./setting/*" -print0; echo ""

# 显示所有可安装的软件
show:
	@echo "=== Available Application ==="; \
	find . -mindepth 2 -maxdepth 2 -type f -name "*.sh" -not -path "./.git/*" -not -path "./utils/*" -not -path "./setting/*" | xargs -n1 basename -s .sh | sed 's/^/    /' | sort -u


#################### Setting Directory ###################

# 设置环境
[group('setting')]
setting package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available setting:"; \
        ls -1 ./setting/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./setting/{{package}}.sh" ]]; then \
        echo "Setting ({{package}}) ..."; \
        bash "./setting/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Setting '{{package}}' not found in ./setting/"; \
        exit 1; \
    fi

#################### Packages Directory ###################

# 包管理方式安装软件
[group('package')]
package package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available package:"; \
        ls -1 ./package/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./package/{{package}}.sh" ]]; then \
        echo "Packages ({{package}}) ..."; \
        bash "./package/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Package '{{package}}' not found in ./package/"; \
        exit 1; \
    fi

#################### Scripts Directory ###################

# 脚本方式安装软件
[group('script')]
script package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available script:"; \
        ls -1 ./script/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./script/{{package}}.sh" ]]; then \
        echo "Scripts ({{package}}) ..."; \
        bash "./script/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Script '{{package}}' not found in ./script/"; \
        exit 1; \
    fi


#################### Softs Directory ###################

# 软件包方式安装软件
[group('soft')]
soft package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available soft:"; \
        ls -1 ./soft/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./soft/{{package}}.sh" ]]; then \
        echo "Soft ({{package}}) ..."; \
        bash "./soft/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Soft '{{package}}' not found in ./softs/"; \
        exit 1; \
    fi

#################### Softs Directory ###################

# 软件包方式安装软件
[group('flatpak')]
flatpak package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available flatpak:"; \
        ls -1 ./flatpak/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./flatpak/{{package}}.sh" ]]; then \
        echo "Flatpak ({{package}}) ..."; \
        bash "./flatpak/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Flatpak '{{package}}' not found in ./flatpak/"; \
        exit 1; \
    fi

#################### Web Directory ####################

# Web方式安装软件（仅提供链接，需手动下载安装）
[group('web')]
web package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available web:"; \
        ls -1 ./web/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./web/{{package}}.sh" ]]; then \
        echo "Web ({{package}}) ..."; \
        bash "./web/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Web '{{package}}' not found in ./web/"; \
        exit 1; \
    fi