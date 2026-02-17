init:

help:

base:

# 备份数据到腾讯云存储（COS）
datasync:
    cd "$$HOME/myfiles" && rclone-datasync.sh

# 基础安装 install <包名>
install package:
    @if [[ "{{package}}" == "all" ]]; then \
        echo "Installing all packages..." ; \
        find . -mindepth 2 -maxdepth 2 -type f -name "*.sh" -not -path "./settings/*" -not -path "./utils/*" -not -path "./.*" -exec bash -c 'script="$1"; echo "Installing $(basename "$script" .sh)..."; bash "$script"' _ {} \; ;\
    else \
        echo "Installing ({{package}}) ..." ;\
        echo ;\
        find . -mindepth 2 -maxdepth 2 -type f -name "*{{package}}*" -not -path "./settings/*" -not -path "./utils/*" -not -path "./.*" -exec bash -c 'script="$1"; echo "Installing $(basename "$script" .sh)..."; bash "$script"' _ {} \; ;\
    fi

# 显示所有可安装的软件
show:
	@echo "=== Available Softs ==="; \
	find . -mindepth 2 -maxdepth 2 -type f -name "*.sh" -not -path "./.git/*" -not -path "./utils/*" -not -path "./settings/*" | xargs -n1 basename -s .sh | sed 's/^/    /' | sort -u


#################### Setting Directory ###################

# 设置环境
[group('settings')]
settings package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available settings:"; \
        ls -1 ./settings/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./settings/{{package}}.sh" ]]; then \
        echo "Setting ({{package}}) ..."; \
        bash "./settings/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Settings '{{package}}' not found in ./settings/"; \
        exit 1; \
    fi

#################### Packages Directory ###################

# 包管理方式安装软件
[group('packages')]
packages package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available packages:"; \
        ls -1 ./packages/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./packages/{{package}}.sh" ]]; then \
        echo "Packages ({{package}}) ..."; \
        bash "./packages/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Package '{{package}}' not found in ./packages/"; \
        exit 1; \
    fi

#################### Scripts Directory ###################

# 脚本方式安装软件
[group('scripts')]
scripts package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available scripts:"; \
        ls -1 ./scripts/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./scripts/{{package}}.sh" ]]; then \
        echo "Scripts ({{package}}) ..."; \
        bash "./scripts/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Script '{{package}}' not found in ./scripts/"; \
        exit 1; \
    fi


#################### Softs Directory ###################

# 软件包方式安装软件
[group('softs')]
softs package *args:
    @if [[ "{{package}}" == "list" ]]; then \
        echo "Available softs:"; \
        ls -1 ./softs/*.sh 2>/dev/null | xargs -n1 basename -s .sh | sed 's/^/  - /'; \
    elif [[ -f "./softs/{{package}}.sh" ]]; then \
        echo "Softs ({{package}}) ..."; \
        bash "./softs/{{package}}.sh" {{args}}; \
    else \
        echo "Error: Soft '{{package}}' not found in ./softs/"; \
        exit 1; \
    fi

#################### Web Directory ####################

lark:
    @bash ./web/lark.sh