 Prerequisites: Setting Up Your Ansible Lab

Before starting with Ansible automation, make sure you have the following infrastructure and tools ready.
1. Environment Overview

You will need at least two Linux-based machines (virtual or physical):

    Ansible Control Node: The machine where Ansible is installed and commands are run.

    Managed Node(s): One or more target machines (Ansible hosts) that Ansible will control via SSH.

     You can use VMs (VirtualBox, VMware, or cloud VMs like EC2), containers, or bare-metal hosts.

2.  System Requirements
For All Nodes

    OS: Ubuntu 20.04+ / CentOS 7+ / Debian 10+ / Rocky Linux 8+

    Python 3.x installed (python3, pip3)

    OpenSSH server installed and running (sudo systemctl status ssh)

For the Ansible Control Node

    Ansible installed (ansible --version)

    SSH key pair generated and public key copied to all managed nodes

3.  SSH Configuration

From the Ansible control node:

# Generate SSH key if not done yet
ssh-keygen -t rsa -b 4096

# Copy public key to managed nodes
ssh-copy-id user@managed_node_ip

Verify passwordless login:

ssh user@managed_node_ip

4.  Install Ansible (Control Node Only)
On Ubuntu/Debian:

sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

On CentOS/RHEL:

sudo yum install -y epel-release
sudo yum install -y ansible

5.  Create Basic Inventory File

# /etc/ansible/hosts or custom inventory file
[webservers]
192.168.56.101
192.168.56.102

[dbservers]
192.168.56.103

6. ⚙ Test Connection to Managed Nodes

ansible all -m ping

Expected output:

192.168.56.101 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

7.  Optional Tools for Development

    VS Code + Ansible extension

    Git for version control

    Molecule for testing roles (advanced)

    VirtualBox + Vagrant for local labs

    Docker (optional) for container-based testing
