#!/bin/bash

# 检查并安装 Snap
echo "检查 Snap 是否已安装..."
if ! command -v snap &> /dev/null; then
    echo "Snap 未安装，正在安装 Snap..."
    if [ -f /etc/lsb-release ]; then
        # Ubuntu/Debian 用户
        sudo apt update
        sudo apt install -y snapd
    elif [ -f /etc/fedora-release ]; then
        # Fedora 用户
        sudo dnf install -y snapd
    elif [ -f /etc/redhat-release ]; then
        # CentOS/RHEL 用户
        sudo yum install -y snapd
    else
        echo "不支持的 Linux 发行版"
        exit 1
    fi
    sudo systemctl enable --now snapd.socket
fi

# 安装 Multipass
echo "正在安装 Multipass..."
sudo snap install multipass

# 验证 Multipass 是否安装成功
echo "验证 Multipass 安装..."
multipass --version

# 安装 Titan Agent
echo "下载并解压 Titan Agent 安装包..."
wget https://pcdn.titannet.io/test4/bin/agent-linux.zip -O /tmp/agent-linux.zip

# 创建安装目录
sudo mkdir -p /opt/titanagent

# 解压安装包
sudo unzip /tmp/agent-linux.zip -d /opt/titanagent

# 获取密钥（此步骤需要你手动获取密钥）
echo "请手动访问 Titan Network 并复制密钥，然后继续执行以下命令"

# 提示用户设置密钥
read -p "请输入您的 Titan Agent 密钥: " AGENT_KEY

# 确保安装了 screen
echo "检查并安装 screen..."
if ! command -v screen &> /dev/null; then
    echo "screen 未安装，正在安装 screen..."
    sudo apt install -y screen  # 对于 Ubuntu/Debian 系统
fi

# 启动一个新的 screen 会话并在其中运行 Titan Agent
echo "启动新的 screen 会话并运行 Titan Agent..."
screen -S titan_agent -dm bash -c "cd /opt/titanagent && chmod +x agent && ./agent --working-dir=/opt/titanagent --server-url=https://test4-api.titannet.io --key=$AGENT_KEY"

echo "Titan Agent 已在 screen 会话中启动！"
