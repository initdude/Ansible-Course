# Ansible Course Teaching Notes

---


## DevOps Culture and Fundamentals

DevOps is a cultural and professional movement that focuses on collaboration and communication between software developers and IT operations. Its primary goal is to shorten the development lifecycle and deliver high-quality software continuously. DevOps encourages automation at all stages of software construction, from integration, testing, releasing to deployment and infrastructure management.


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

The CALMS framework is a model that helps organizations adopt DevOps practices successfully. It represents five pillars:

- **Culture**: Building a collaborative environment where all teams share responsibilities and success.
- **Automation**: Leveraging tools and scripts to automate manual processes, reducing human error and speeding up delivery.
- **Lean**: Applying lean principles such as reducing waste, optimizing processes, and improving efficiency.
- **Measurement**: Monitoring key metrics like deployment frequency, lead time, mean time to recovery, and change failure rate.
- **Sharing**: Promoting open communication and feedback loops between teams to foster knowledge sharing and transparency.


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

Ansible is an open-source automation tool used for configuration management, application deployment, orchestration, and provisioning. It uses simple YAML syntax (in the form of playbooks) and is agentless, meaning it uses SSH or WinRM to communicate with managed nodes. Ansible is known for its ease of use, strong community support, and flexibility to integrate into CI/CD pipelines.


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
# defaults/

    File: main.yml

    Purpose: Define default variables for the role.

    Note: Lowest variable precedence (can be easily overridden).

### roles/myrole/defaults/main.yml
some_variable: default_value

# files/

    Content: Static files (e.g. .conf, .tar.gz, scripts).

    Used with: copy or unarchive module.

### Copy file to remote
- name: Copy NGINX config
  copy:
    src: nginx.conf
    dest: /etc/nginx/nginx.conf

# handlers/

    File: main.yml

    Purpose: Define handlers that are triggered by tasks (e.g. restart services).

### roles/myrole/handlers/main.yml
- name: restart nginx
  service:
    name: nginx
    state: restarted

# tasks/

    File: main.yml (or include other task files)

    Purpose: The main list of actions the role performs.

### roles/myrole/tasks/main.yml
- name: Install NGINX
  apt:
    name: nginx
    state: present

# meta/

    File: main.yml

    Purpose: Role metadata like dependencies, author, license.

### roles/myrole/meta/main.yml
dependencies:
  - role: common

# templates/

    Content: Jinja2 template files (.j2)

    Used with: template module

    Purpose: Create dynamic config files using variables.

### roles/myrole/templates/nginx.conf.j2
server {
  listen 80;
  server_name {{ domain }};
}

### Apply the template
- name: Deploy NGINX config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf

# vars/

    File: main.yml

    Purpose: Define role-specific variables (higher priority than defaults).

### roles/myrole/vars/main.yml
package_name: nginx
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
> suggestion: It's better to use "Ansible Vault" for Sensitive data like password. we will talk about it in future.

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
ansible -m gather_facts ansible_course
```
> The output of this command is GREEN and shows all informations of Server (ansible Host)

---
# Define and Call and Use Place Variables:
  ### Where:
  + Variables Defined in a Playbook
  + Using Variable: About Jinja2
  + Variables Defined in vars
  + Variables Defined in a default
  + Variables defined in a task

  ### Create:
    vars:
      name: blue
  ### Call:
    {{name}}

### Invalid Variable Names:
  + mysql version (multiple words)
  + mysql.port (a dot)
  + mysql-port(a dash)

### Define ascading (hierarchy) variable and call it
  ```
  lotus:
     env:
        version:'1.3.3.0'
        name: 'test'
      deployment
        url: 'http://centdnc.lotus.ir/deployment'
        username: 'coreuser'
        password: '123123'
 ```
 ### How to call the above variables:
   ```
   {{ lotus.env.version }} ### this will call '1.3.3.0'
   {{ lotus.deployment.password }} ### this will call '123123'
   ```
> Note: Dont use TABS in .yml files, use SPACE instead.

---

### call a variables with extra-vars switch (will override all vars in other files, get the vars from commandline)
```
ansible -i inventory/inventory.yml --extra-vars playbook.yml
```

---

# Introduce Ansible Block:
   + **Task and Handlers and any main.yml files**
   + **Tags and name any Modules**

 ### an Example to write main.yml (in liner mode)

 ```yml
---
 - name: block description
   Module_Type: Module Command structure part1=value1 and part2=value2 and ...  **pay attention to = **
   tags: [TagName_Block_Description]
```
> **Each task line, contains 3 part that we call it a block, a block starts with name and end with tag, and the main task is between them**

  ### an Example to write main.yml (in waterfall)
```yml
---
  - name: Block Description
    Module_Type:
       Module Command structure part1: value1
       Module Command structure part2: value2
       ...
       tags: [TagName_Block_Description]
```

>**Note: according to experience, in liner method we deploy easier.**
---

# Create Main Structure:
  1. mkdir /home/ansible/provision -p
  2. vim /home/ansible/provision/ProjectName.yml
  3. mkdir /home/ansible/provision/inventory
  4. /home/ansible/provision/roles

  ---

  ### How to write groups and Hosts in inventory
    ```yml
    ---
    [hosts]
    192.168.1.10
    192.168.1.11
    ...
    [webservers]
    192.168.10.11

    [db]
    192.168.11.11
    ```
##  *  Note:   **in role we create a subdir by  name of our project that defined in playbook, inside it we create 7 ansible dir, inside them we create a main.yml for each**
###**here is the tree of ansible dir structure**
![ansible tree](https://github.com/user-attachments/assets/c196fcd2-b5b3-4366-ab3e-40ff6ae81d34)

## we define a playbook for each project, for example if we have a project1, we set like this:
```yml
---
- hosts: ansible_course
  roles:
    - proj(could be anything but be careful this name must be same as the project roles actual dir)
```

## then we can test it, simply run:
```
ansible-playbook -i /inventory/inventory.yml project1.yml

```
__and here is the output:__
---
PLAY [ansible_course] *********************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [192.168.100.11]

PLAY RECAP ***************************************************************************************************************************************************************
192.168.100.11             : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued

---

# Note: from Here i call each task we do, by lab.
### lets continue with creating some simple tasks in our /roles/proj/tasks/main.yml :) 
### lab1- Create Directory with permissions:
```yml
---
- name: Create directory with specifications
  file: path=/home/testdir1 state=directory owner=root group=root mode=0775
  tags: [create_dir]
  ```
  __RUN: ansible-playbook inventory/inventory.yml project1.yml__

  ## if you check your ansible host(s) you will see at /home you have a "testdir" directory.
  ---

  ### lab2- Remove Directory :
  ```yml
  ---
  - name: remove dir
      file: path=/home/testdir state=absent
      tags: [remove_dir]
  ```
  ---
  ### lab3- Create Recursive Directory:
  ```yml
  ---
  - name: Create Recursive dir with permissions
    file: path=/home/testdir1/subdir1/subdir2/subdir3 state=directory recurse=yes owner=root group=root mode=0775
    tags: [create_dirs]
  ```
---
### lab-4 Create File:
```yml
---
- name: Create File
  file: path=/home/testfile1 state=touch owner=root group=root mode=0644 mode: "u=rw,g=r,o=r"
  tags[create_file]
  ```
---
### lab-5 Delete File:
```yml
---
- name: Delete File
ansible.builtin.file:
  path: /home/testfile1
  state: absent
tags:
  - Delete File
```
---
# Introduction Ansible Modules for Windows Machines"
### lab-6 Create File
```yml
---
- name: Create a file on Windows
  tasks:
    - name: Create empty file
      community.windows.win_file:
        path: C:\temp\foo.conf
        state: touch
```
---

# Project:
## Create Directories and files and test it with tree
### in this project We want to get more hands-on with Ansible scripting
```yaml
---
- name: create directory and files for new project
  ansible.builtin.file:
    path: "/opt/maindir/{{ item | trim }}"
    state: directory
    mode: "0755"
  loop:
    - "dir1"
    - "dir2"
    - "dir3"
  tags:
    - create_dirs

- name: create files for dir1
  ansible.builtin.file:
    path: "/opt/maindir/dir1/{{ item }} "
    state: touch
    mode: "0644"
  loop:
    - file1
    - file2
  tags:
    - create files dir1


- name: create subdir for dir2
  ansible.builtin.file:
    path: /opt/maindir/dir2/sdir1
    state: directory
    mode: "0755"
  tags:
    - create subdir dir2

- name: create file for dir2_1
  ansible.builtin.file:
    path: /opt/maindir/dir2/sdir1/file3
    state: touch
    mode: "0644"
  tags:
    - create file
- name: create sdir in sdir1
  ansible.builtin.file:
    path: /opt/maindir/dir2/sdir1/sdir2
    state: directory
    mode: "0755"
  tags:
    - create sdir sdir2
- name: create hiddn file in sdir2
  ansible.builtin.file:
    path: "/opt/maindir/dir2/sdir1/sdir2/{{ item }}"
    state: touch
    mode: "0644"
  loop:
    - .file1
    - .file2
  tags:
    - create hidden files
- name: create sdir3 in dir2
  ansible.builtin.file:
    path: /opt/maindir/dir2/sdir1/sdir2/sdir3
    state: directory
    mode: "0755"
  tags:
    - create sdir3 for dir2
```
### we will see the following tree after running playbook:

![ansible treea](https://github.com/user-attachments/assets/98713a57-cc01-4f90-a108-72489228d74e)
