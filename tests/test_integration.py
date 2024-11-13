import json
import subprocess
import pytest

@pytest.fixture(scope="module")
def setup_infrastructure():
    """
    Initializes on an existing Terraform configuration, then yields the output.
    """
    terraform_dir = "terraform/aws"
    try:
        output = subprocess.check_output(["terraform", "output", "-json"], cwd=terraform_dir)
        terraform_output = json.loads(output)
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to get Terraform output: {e}")
    yield terraform_output

def test_ansible_playbook(setup_infrastructure):
    """
    Test the Ansible playbook by ensure the application is running on the EC2 instances.
    """
    try:
        public_ips = setup_infrastructure["ec2_public_ip"]["value"]
    except KeyError as e:
        raise Exception("Missing required Terraform output 'ec2_public_ip'")
    for public_ip in public_ips:
        response = subprocess.check_output(["ssh","-i", "~/.ssh/ansible", "-o", "StrictHostKeyChecking=no", f"ubuntu@{public_ip}", "curl -s http://localhost/wordpress/wp-admin/install.php | grep 'English'"])
        # check only first if the WordPress installation page is found
        assert "English" in response.decode("utf-8"), f"WordPress installation page not found on {public_ip}. Response: {response.decode('utf-8')}"
