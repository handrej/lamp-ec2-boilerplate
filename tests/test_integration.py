import json
import subprocess
import pytest

@pytest.fixture(scope="module")
def setup_infrastructure():
    """
    Initializes and applies the Terraform configuration, then yields the output.
    After the test, it can optionally destroy the infrastructure.
    """
    terraform_dir = "terraform/aws"
    subprocess.run(["terraform", "init"], cwd=terraform_dir, check=True, timeout=300)
    subprocess.run(["terraform", "apply", "-auto-approve"], cwd=terraform_dir, check=True)
    try:
        output = subprocess.check_output(["terraform", "output", "-json"], cwd=terraform_dir)
        terraform_output = json.loads(output)
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to get Terraform output: {e}")
    try:
        yield terraform_output
    finally:
        #subprocess.run(["terraform", "destroy", "-auto-approve"], cwd=terraform_dir, check=True)
        pass

def test_ansible_playbook(setup_infrastructure):
    """
    Test the Ansible playbook to ensure the application is running on the EC2 instances.
    """
    ansible_dir = "ansible"
    playbook = "playbook.yml"
    subprocess.run(["ansible-playbook", playbook], cwd=ansible_dir, capture_output=True, text=True)
    try:
        public_ips = setup_infrastructure["ec2_public_ip"]["value"]
    except KeyError as e:
        raise Exception("Missing required Terraform output 'ec2_public_ip'")
    for public_ip in public_ips:
        response = subprocess.check_output(["ssh", "-o", "StrictHostKeyChecking=no", f"ubuntu@{public_ip}", "curl -s http://localhost/wordpress/wp-admin/install.php | grep 'English'"])
        # check only first if the WordPress installation page is found
        assert "English" in response.decode("utf-8"), f"WordPress installation page not found on {public_ip}. Response: {response.decode('utf-8')}"
