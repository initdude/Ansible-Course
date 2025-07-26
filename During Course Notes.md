# Ansible Course Teaching Notes

---

## DevOps Culture and Fundamentals

### DevOps Layers from Zero

From NOC Level 3 (just watching monitors) → NOC Level 2 → Admin → DevOps.

**R\&D** is part of DevOps responsibilities:

* Stress testing
* Penetration testing
* Business testing
* Syntax checking
* Checking pipelines

> A good TPS must be handed to the **operations** team, who provide feedback. Then DevOps re-checks it before passing it back. Operation admins should not install Kubernetes but just ensure services/containers are running.

> If an operator can fix a problem independently, they move closer to DevOps; otherwise, they escalate it.

---

### Distributed Cluster Storage

* Ceph, Rook-Ceph, Minio ≠ NFS or traditional methods

### Note:

Don't name the team "DevOps" first. Do the task first, then name it. DevOps spans:

* Operation
* Development
* Application Delivery

**DevSecOps** = DevOps + Security (SOC)

---

### Goal of DevOps: Deliver changes ASAP to customers

#### Problem:

Operations teams blame each other.

#### Solution:

1. Collaboration
2. Remove the wall between dev and ops
3. Use DevOps tools

#### Benefits:

* Faster troubleshooting (monitoring, TPS, uptime)
* Isolated environments (containers)
* Performance tuning
* Failover/HA
* Resource & cost efficiency
* Performance gains
* Job satisfaction

---

## CALMS Model

* **Culture**: Shared responsibility, embrace change
* **Automation**: CI/CD, Infrastructure as Code
* **Lean**: Small batch sizes, eliminate redundancy
* **Measurement**: Monitor infra, logs, performance
* **Sharing**: Open comms between Dev & Ops

---

### Knowledge Management

* **KM Tools**:

  * Alfresco (knowledge management)
  * Sentry (error tracking)

---

### Developer Notifications

After CI/CD jobs: notify developers via **Rocket.Chat** or similar tools

---

### OpenShift Overview

* OpenShift = Kubernetes-based (not Docker)
* Built by Red Hat
* Fancy dashboards, clusters multiple CRIs
* Runs only on CentOS/RHEL
* Uses `podman` instead of `kubectl`

---

## Repositories in DevOps

### 1. Source Code Repository

* Used during development

### 2. Artifact Repository

* Used during dev & ops
* Stores binaries, libraries, test data

### 3. Configuration Management Database (CMDB)

* Dev & Ops use it
* Tracks systems/services/app configurations
* Example: Use **Sentry** as code-based CMDB

---

## IaC & CaC

* **Infrastructure-as-Code** = Install
* **Configuration-as-Code** = Deployment/config changes

---

# Ansible Introduction

### Basic Concepts

* **Task** = Ansible job
* **Role** = Group of tasks
* **Inventory** = List of target hosts
* **Playbook** = YAML file that defines roles/tasks and where to apply them

### Inventory File Example

```yaml
all:
  children:
    webservers:
      hosts:
        web1:
          ansible_host: 192.168.100.10
        web2:
          ansible_host: 192.168.100.11
    kubernetes:
      hosts:
        master1:
          ansible_host: 192.168.80.10
        master2:
          ansible_host: 192.168.80.11
```

> Use `children` for nested groups

### Roles Directory Structure

```
roles/
    defaults/
    files/
    handlers/
    tasks/
    meta/
    templates/
    vars/
```

---

## Running Ansible Playbooks

```bash
ansible-playbook -i inventory/inventory.yml playbook.yml [options]
```

### Common Switches:

* `-v`, `-vv`, `-vvv`: Verbosity levels
* `--tags tag1,tag2`: Run specific tags
* `--skip-tags`: Exclude tasks
* `--step`: Manual step-by-step
* `--list-tasks`: Show tasks
* `--extra-vars`: Pass variables
* `--syntax-check`: Validate YAML
* `--check`: Dry-run mode

---

## SSH Passless Configuration

```bash
ssh-keygen -t rsa -b 2048
ssh-copy-id -p <port> user@host
```

> Suggestion: Use a dedicated `ansible` user with sudo privileges

---

## Directory Setup Example

```bash
mkdir -p ansible/inventory/group_vars
vim inventory/inventory.yml
```

Example:

```yaml
all:
  children:
    ansible_course:
      hosts:
        192.168.1.100:
```

Group vars:

```yaml
# inventory/group_vars/all.yml
ansible_user: initdude
ansible_become: true
ansible_password: <secure_password>
ansible_port: 7899
```

### Ping Test

```bash
ansible all -i inventory/inventory.yml -m ping
ansible ansible_course -i inventory/inventory.yml -m ping
```

Expected Output:

```json
192.168.1.100 | SUCCESS => {
  "changed": false,
  "ping": "pong"
}
```

### Ansible Output Colors

* **Green**: Success, no change
* **Yellow**: Success, changed
* **Red**: Failed
* **Blue**: Skipped
* **Cyan**: Debug/info
* **Magenta**: Rare warnings
* **White**: Neutral info

> Set `ANSIBLE_NOCOLOR=1` to disable color

---

## Ansible Methods

### 1. Ad-Hoc

* One-off commands
* Quick & unsaved

### 2. Playbooks

* Reusable, multi-task YAML automation

---

# Ad-Hoc Command Examples

> Optional: Add hosts to `/etc/ansible/hosts`

### 1. Shell Commands

```bash
ansible all -i inventory/inventory.yml -m shell -a '/sbin/reboot'
ansible all -i inventory/inventory.yml -m shell -a 'free -m'
```

### 2. File Transfer

```bash
ansible ansible_course -i inventory/inventory.yml \
  -m copy -a "src=/home/file dest=/opt/file"
```

### 3. Manage Packages

```bash
ansible ansible_course -i inventory/inventory.yml \
  -m apt -a "name=net-tools state=present" -b --become-user initdude
```

### 4. Manage Users

```bash
ansible ansible_course -i inventory/inventory.yml \
  -m user -a 'name=user1 state=present groups=sudo,developers \
  shell=/bin/bash comment="User One" password=<hashed_password>'
```

> Generate a hashed password:

```bash
python3 -c "import crypt; print(crypt.crypt('SecretPass', crypt.mksalt(crypt.METHOD_SHA512)))"
```
> suggestion: It's better to use "Ansible Vault" for Sensetive data like password. we will talk aout it in future.

### 5. Deploy from Source Control

```bash
ansible -m git -a "repo=github.com/repo.git dest=/srv/myapp" ansible_course
```
### 6. Managing Services

```bash
ansible -m service -a "name=httpd state=restart" ansible_course
```
### 7. Gathering Facts
  > Gather Facts Modules:
       _ This module takes care of executing the configured facts modules. The default is to use the **setup** module.
  
```bash
ansible -m setup ansible_course 
**OR**
ansible -m gather_facts ansible_cource
```
> The output of this command is GREEN and shows all informations of Server (ansible Host)