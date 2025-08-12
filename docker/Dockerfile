FROM debian:trixie-slim

# 避免交互提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础依赖
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    sudo \
    procps \
    curl \
    wget \
    xz-utils \
    unzip \
    gzip \
    bash \
    make \
    git \
    vim \
    tree \
    openssh-server \
    net-tools \
    jq \
    locales

# 配置中文环境
sed -i -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

# 安装 Docker CLI
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y --no-install-recommends \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
apt-get clean
rm -rf /var/lib/apt/lists/*

# 配置 SSH
mkdir -p /var/run/sshd
echo 'root:password' | chpasswd  # 设置密码（生产环境应使用更安全的方式）
# 暴露 SSH 端口 (32222)
sed -i 's/#Port 22/Port 32222/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 安装 Nix（多用户模式）
mkdir -m 0755 /nix
chown root:root /nix
curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
mkdir -p /etc/nix
echo 'sandbox = false' > /etc/nix/nix.conf
echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf

# 设置共享 Flake（Rust, Go, node 使用 nixpkgs-unstable）
mkdir -p /etc/nix/devflake
cat > /etc/nix/devflake/flake.nix <<'FLAKE'
{
  description = "Global dev shell with nixpkgs-unstable";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rustup
          go
          nodejs
          uv
        ];
        shellHook = ''
          # Rust
          export RUSTUP_HOME=$HOME/.rustup
          export CARGO_HOME=$HOME/.cargo
          [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

          # Go
          export GOPATH="$HOME/go"
          export GOBIN="$GOPATH/bin"
          export PATH="$PATH:$GOROOT/bin:$GOBIN"

          # Custom Start
        '';
      };
    };
}
FLAKE
EOF

# 全局开发环境入口
RUN <<EOF
cat > /etc/profile.d/dev-env.sh <<'SCRIPT'
# Unified dev shell entrypoint
if command -v nix >/dev/null 2>&1; then
  dev() {
    nix develop --extra-experimental-features 'nix-command flakes' /etc/nix/devflake#default
  }
fi
SCRIPT
chmod +x /etc/profile.d/dev-env.sh
EOF

# 加载 Nix 和 dev 环境
RUN <<EOF
echo 'if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; fi' >> /etc/bash.bashrc
echo 'if [ -f /etc/profile.d/dev-env.sh ]; then . /etc/profile.d/dev-env.sh; fi' >> /etc/bash.bashrc
EOF

# 配置 PATH
RUN <<EOF
echo 'export PATH="/root/.local/bin:$PATH"' >> /etc/bash.bashrc
EOF

# 修复 VSCode
RUN <<EOF
(
  echo ''
  echo '# VSCode fix: only load nix and bashrc if in VSCode remote shell'
  echo 'if [ -d /root/.vscode-server ]; then'
  echo '  if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then'
  echo '    . /nix/var/nix/profiles/default/etc/profile.d/nix.sh'
  echo '  fi'
  echo '  if [ -f /etc/bash.bashrc ]; then'
  echo '    . /etc/bash.bashrc'
  echo '  fi'
  echo 'fi'
) >> /root/.bashrc
EOF

# 确保非 root 用户可以访问 Nix
RUN <<EOF
groupadd -r nixbld || true
EOF

# 使用 bash 作为默认 shell
SHELL ["/bin/bash", "-lc"]

# 验证 Nix 配置
RUN <<EOF
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix --version
nix flake metadata /etc/nix/devflake --extra-experimental-features 'nix-command flakes'
EOF

# 设置默认语言环境为中文
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

# 暴露 SSH 端口 (32222)
EXPOSE 32222

# 默认命令进入交互式 shell
# CMD ["bash", "--login"]

CMD ["/usr/sbin/sshd", "-D"]