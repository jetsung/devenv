# Linux 平台软件开发环境配置

`Linux` 平台软件开发环境配置 For `Jetsung Chan`

## 全局安装
```bash
URL=<http://xxx.com/xxx.sh>
curl -L https://s.asfd.cn/514b875c | CDN=https://fastfile.asfd.cn/ bash -s -- $URL | bash
```

## 编程语言
### 1. Go 语言
https://go.dev/

**1. 安装**
```bash
curl -fsSL https://framagit.org/jetsung/golang-install/-/raw/main/gvm.sh | bash

# 短址
curl -L https://s.asfd.cn/golang | bash
```

**2. 配置**   
环境变量
```bash
## GOLANG
export GOROOT="$HOME/.gvm/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOPROXY="https://goproxy.cn,https://goproxy.io,direct"
export PATH="$PATH:$GOROOT/bin:$GOBIN" 
```

## 开发工具
### Bun
https://bun.sh/

**1. 安装**
```bash
# 默认
curl -fsSL https://bun.sh/install | bash

# 指定 GitHub
curl -fsSL https://bun.sh/install | GITHUB=https://filetas.asfd.cn/https://github.com bash

# 指定 CDN
curl -L https://s.asfd.cn/514b875c | CDN=https://filetas.asfd.cn/ bash -s -- https://bun.sh/install | bash
```

**2. 配置**   
环境变量
```bash
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
```
镜像加速
```bash
# cat ~/.bunfig.toml   
# ~/.bunfig.toml
[install]
registry = "https://registry.npmmirror.com/"
```

