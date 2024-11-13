#!/bin/bash

set -e

# Detect package manager
if command -v apt-get &>/dev/null; then
    PKG_MANAGER="apt-get"
    PKG_UPDATE="$PKG_MANAGER update"
    PKG_INSTALL="$PKG_MANAGER install -y"
    PYTHON_PKG="python3.8 python3-pip python3-venv"
elif command -v yum &>/dev/null; then
    PKG_MANAGER="yum"
    PKG_UPDATE="$PKG_MANAGER update -y"
    PKG_INSTALL="$PKG_MANAGER install -y"
    PYTHON_PKG="python38 python38-pip python3-virtualenv"
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    PKG_UPDATE="$PKG_MANAGER update -y"
    PKG_INSTALL="$PKG_MANAGER install -y"
    PYTHON_PKG="python38 python38-pip python3-virtualenv"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    PKG_UPDATE="$PKG_MANAGER -Syu --noconfirm"
    PKG_INSTALL="$PKG_MANAGER -S --noconfirm"
    PYTHON_PKG="python python-pip python-virtualenv"
else
    echo "No supported package manager found"
    exit 1
fi

check_version() {
    if command -v $1 &>/dev/null; then
        echo "$1 is already installed: $($1 --version)"
        return 0
    fi
    return 1
}

echo "Detected package manager: $PKG_MANAGER"
echo "Checking and installing Infrastructure as Code prerequisites..."

# System updates
#sudo $PKG_UPDATE

# Python check and install
if ! check_version "ansible"; then
    echo "Installing Python 3..."
    sudo apt-get install -y python3 python3-pip python3-venv
else
    echo "Python 3+ is already installed: $(python3 --version)"
fi

# AWS CLI check and install
if ! check_version "aws"; then
    echo "Installing AWS CLI..."
    if [ "$PKG_MANAGER" = "pacman" ]; then
        sudo $PKG_INSTALL aws-cli-v2
    else
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        rm -rf aws awscliv2.zip
    fi
fi

# Terraform check and install
if ! check_version "terraform"; then
    echo "Installing Terraform..."
    case $PKG_MANAGER in
        "apt-get")
            sudo $PKG_INSTALL software-properties-common
            wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            sudo $PKG_UPDATE
            sudo $PKG_INSTALL terraform
            ;;
        "yum"|"dnf")
            sudo $PKG_INSTALL yum-utils
            sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            sudo $PKG_INSTALL terraform
            ;;
        "pacman")
            sudo $PKG_INSTALL terraform
            ;;
    esac
fi

# Ansible check and install
if ! check_version "ansible"; then
    echo "Installing Ansible..."
     case $PKG_MANAGER in
        "apt-get")
            sudo $PKG_INSTALL ansible
            ;;
        "yum"|"dnf")
            sudo $PKG_INSTALL epel-release
            sudo $PKG_INSTALL ansible
            ;;
        "pacman")
            sudo $PKG_INSTALL ansible
            ;;
    esac
fi

# Python venv setup
if [ ! -d ".venv" ]; then
    echo "Setting up Python virtual environment..."
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
else
    echo "Virtual environment already exists"
fi

# SSH key check and generate
if [ ! -f ~/.ssh/ansible ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/ansible -N ""
    echo "SSH key generated at ~/.ssh/ansible"
else
    echo "SSH key already exists at ~/.ssh/ansible"
fi

# AWS Configuration check
if [ ! -f ~/.aws/credentials ]; then
    echo "Please configure AWS credentials:"
    aws configure
else
    echo "AWS credentials already configured"
fi

echo "Setup complete! To activate virtual environment:"
echo "source .venv/bin/activate"