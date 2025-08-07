# 开发环境

基于 [**Docker**](https://docs.docker.com/engine/install/debian/) + [**Debian:12-slim**](https://hub.docker.com/_/debian) + [**Nix**](https://github.com/NixOS) 的容器内开发环境

## 特征

- [Nix nixpkgs 25.05](https://github.com/NixOS/nixpkgs/releases/tag/25.05)
- 系统级主要组件：
    ```bash
    openssh-server
    xz-utils
    curl
    wget
    tree
    make
    git
    vim
    docker
    unzip
    gzip
    ```
- 编程语言：
    ```bash
    Rust
    Go
    NodeJS
    uv
    ```
- 环境级组件：
    ```
    zoxide
    hugo
    skopeo
    ```

## 运行

- `compose.yml`
```yaml
services:
  devenv:
    image: jetsung/devenv:latest
    container_name: devenv
    hostname: devenv
    restart: unless-stopped
    privileged: true
    env_file:
    - ./.env
    # - ./cn.env
    ports:
    - ${SSH_PORT:-32222}:32222
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - $HOME/workspaces:/workspaces
```

- `.env`
```bash
TZ=Asia/Shanghai
SSH_PORT=32222
```

- `cn.env`
```bash
## uv
UV_DEFAULT_INDEX=https://mirrors.aliyun.com/pypi/simple/

## rust
RUSTUP_DIST_SERVER=https://rsproxy.cn
RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup

## nodejs
NVM_NODEJS_ORG_MIRROR=https://mirrors.ustc.edu.cn/node/
NODE_MIRROR=https://mirrors.ustc.edu.cn/node/

## go
GOPROXY=https://goproxy.cn,https://goproxy.io,direct
```

## 其它设置

- 设置时区
    - 外部文件 `compose.yml`
        ```bash
        TZ=Asia/Shanghai
        ```
    
    - 容器内设置
        ```bash
        ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
        ```

## 构建

### 本地构建
```bash
# 预览构建信息
docker buildx bake --print

# 执行构建
docker buildx bake
```

**测试**
```bash
docker run --rm -it devenv:local bash

# 容器内执行
dev

# 依次执行
go version
python --version
uv --version
rustup default stable
```

## Nix 基础教程
- 添加软件
```bash
vi /etc/nix/devflake/flake.nix

# 向 “buildInputs = with pkgs; [ " 内添加软件
```

- 配置环境变量
```bash
vi /etc/nix/devflake/flake.nix

# 在 shellHook = '' 内添加环境变量
```
