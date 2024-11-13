# Infrastructure as Code Boilerplate

This project is using Infrastructure as Code principles to setup a WordPress website on AWS using Ansible and Terraform.

## Features

- Terraform managing the AWS infrastructure (EC2, Load Balancer, RDS, Security Groups, VPC)
- Modular design with separate concerns for networking, security, and application components
- Ansible handling the software configuration (Apache, PHP, MySQL, WordPress)
- Dynamic inventory for AWS resource discovery

## Requirements

- Python 3.8+
- Terraform 1.9+
- Ansible 2.9+

## Project Structure

```
├── ansible/
│   ├── ansible.cfg         # Ansible main configuration
│   ├── inventory/              # Dynamic inventory configurations
│   │   └── inventory_aws_ec2.yml   # AWS EC2 dynamic inventory
│   ├── playbook.yml            # Main Ansible playbook
│   └── roles/                  # Ansible roles
├── terraform/
│   └── aws/                # AWS-specific Terraform configs
│       ├── main.tf             # Main Terraform configuration
│       ├── modules/            # Terraform modules
│       ├── outputs.tf          # Terraform output definitions
│       ├── terraform.tfvars    # Variable values
│       └── variables.tf        # Variable declarations
└── tests/                  # Integration tests
```

## Configuration

- Infrastructure variables: `terraform/aws/terraform.tfvars`
- Dynamic Inventory: `ansible/inventory/inventory_*.yml`

## Setup

### Clone project:

```bash
git clone https://github.com/handrej/lamp-ec2-boilerplate.git
cd lamp-ec2-boilerplate
```

### Install Prerequisites

#### Python & Pip

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip

# RHEL/CentOS
sudo dnf install python3 python3-pip
```

#### Terraform

```bash
# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
sudo apt update
sudo apt install terraform
```

#### AWS CLI v2

```bash
# Download and install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

#### AWS Configuration

```bash
# Setup AWS credentials
aws configure
```

### Generate SSH Keys

```bash
# Warning: Any changes to the file location need also to be adjusted in the Infrastructure variables and ansible.cfg
ssh-keygen -t rsa -b 2048 -f ~/.ssh/ansible -N ""
```

### Setup Python environment:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Temporary

#### Run Tests

```bash
pytest tests/test_integration.py  # Apply Terraform, Ansible, and tear it down
```

### Permanent

#### Using Terraform:

```bash
cd terraform/aws
terraform init      # Initialize files
terraform plan      # Review changes
terraform apply     # Apply changes
```

#### Using Ansible

```bash
cd ../ansible
ansible-playbook playbook.yml   # Run playbook
```

## Open Features

- S3, SSL
- Improved IAM and Secret Management
- Various Architectural Topics e.g. Auto-Scaling, Backups, HA, Staging Concept, CI/CD Integration

## Encountered Issues

- **Python Interpreter Mismatch**: When using Ansible on Amazon EC2 instances, especially with Amazon Linux AMI or Amazon Linux 2, the following issue can arise:
  - Amazon Linux does not have the appropriate package manager (e.g., dnf for Python 3).
  - Related topics:
    - [Issue #74948](https://github.com/ansible/ansible/issues/74948)
    - [Issue #62722](https://github.com/ansible/ansible/issues/62722)
  - Downgrading the Python interpreter to Python 2 will affect the ansible-core module, requiring a downgrade, which is not sustainable for a version that is EOL.
  - Solutions:
    - To allow seamless integration with Ansible, this project uses the latest Ubuntu Image from Canonical, which comes with Python 3 and compatible package manager.

### License

Apache License - see LICENSE file
