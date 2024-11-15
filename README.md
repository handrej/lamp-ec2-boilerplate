# Infrastructure as Code Boilerplate

This project is using Infrastructure as Code principles to setup a WordPress website on AWS using Ansible and Terraform.

## Features

- Terraform managing the AWS infrastructure (EC2, Load Balancer, RDS, Security Groups, VPC)
- Modular design with separate concerns for networking, security, and application components
- Ansible handling the software configuration (Apache, PHP, MySQL, WordPress)
- Dynamic inventory for AWS resource discovery

## Requirements

- A Linux system
- Free Tier AWS Account
- AWS CLI v2 
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

```bash
chmod +x setup.sh
# This will take care of installing any dependencies and setup the run environment
./setup.sh
```

#### Environment Configuration

```bash
# Activate Python environment
source .lamp-ec2/bin/activate
```

### Using Terraform:

```bash
cd terraform/aws
terraform init      # Initialize files
terraform plan      # Review changes
terraform apply     # Apply changes
```

### Run Ansible Playbook to install AMP

```bash
cd ../../ansible
ansible-playbook playbook.yml
```

### Run Tests

```bash
cd ..   # Switch back to project directory
pytest  # Run test_integration.py to ensure the infrastructure and application are running
```

## Encountered Issues

- **Python Interpreter Mismatch**: When using Ansible on Amazon EC2 instances, especially with Amazon Linux AMI or Amazon Linux 2, the following issue can arise:
  - Amazon Linux does not have the appropriate package manager (e.g., dnf for Python v3).
  - Related topics:
    - [Issue #74948](https://github.com/ansible/ansible/issues/74948)
    - [Issue #62722](https://github.com/ansible/ansible/issues/62722)
  - Downgrading the Python interpreter to v2 will affect the ansible-core module, requiring a downgrade, which is not sustainable for a version that is EOL.
  - Solutions:
    - To allow seamless integration with Ansible, this project uses the latest Ubuntu Server AMI from Canonical, which comes with Python v3 and compatible package manager.
