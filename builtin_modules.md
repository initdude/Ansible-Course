
#  Ansible Built-in Modules Cheat Sheet

A quick reference guide to the most essential and useful Ansible built-in modules, organized by category.

---

##  FILES AND DIRECTORIES

### `file`
Manage files, directories, and symlinks.

```yaml
- name: Ensure directory exists
  ansible.builtin.file:
    path: /home/mydir
    state: directory
    mode: '0755'
```

---

### `copy`
Copy files from local to remote.

```yaml
- name: Copy config file
  ansible.builtin.copy:
    src: files/myapp.conf
    dest: /etc/myapp.conf
    mode: '0644'
```

---

### `template`
Copy Jinja2 templates.

```yaml
- name: Deploy templated config
  ansible.builtin.template:
    src: templates/nginx.conf.j2
    dest: /etc/nginx/nginx.conf
```

---

### `fetch`
Pull files from remote to local.

```yaml
- name: Fetch logs from remote
  ansible.builtin.fetch:
    src: /var/log/app.log
    dest: ./logs/
    flat: yes
```

---

### `lineinfile`
Ensure a line exists or is modified in a file.

```yaml
- name: Ensure setting in config
  ansible.builtin.lineinfile:
    path: /etc/sysctl.conf
    line: 'net.ipv4.ip_forward=1'
```

---

### `blockinfile`
Insert or update a block of lines.

```yaml
- name: Add SSH config block
  ansible.builtin.blockinfile:
    path: /etc/ssh/sshd_config
    block: |
      Match User testuser
      X11Forwarding yes
```

---

##  SYSTEM MANAGEMENT

### `user`
Manage system users.

```yaml
- name: Create a user
  ansible.builtin.user:
    name: johndoe
    shell: /bin/bash
```

---

### `group`
Manage system groups.

```yaml
- name: Create a group
  ansible.builtin.group:
    name: developers
```

---

### `service`
Start/stop/restart services.

```yaml
- name: Restart nginx
  ansible.builtin.service:
    name: nginx
    state: restarted
```

---

### `systemd`
Advanced service control.

```yaml
- name: Enable and start docker
  ansible.builtin.systemd:
    name: docker
    enabled: true
    state: started
```

---

### `package`
Cross-platform package manager interface.

```yaml
- name: Install packages
  ansible.builtin.package:
    name: [git, curl, vim]
    state: present
```

---

### `apt`, `yum`, `dnf`
Platform-specific package managers.

```yaml
- name: Install nginx on Ubuntu
  ansible.builtin.apt:
    name: nginx
    update_cache: yes
```

---

##  NETWORKING

### `uri`
Call HTTP/HTTPS endpoints.

```yaml
- name: Check HTTP status
  ansible.builtin.uri:
    url: http://localhost
    method: GET
    return_content: yes
```

---

### `get_url`
Download files from web.

```yaml
- name: Download binary
  ansible.builtin.get_url:
    url: https://example.com/app.tar.gz
    dest: /tmp/app.tar.gz
```

---

##  ARCHIVES & PACKAGES

### `unarchive`
Extract archive files.

```yaml
- name: Extract tarball
  ansible.builtin.unarchive:
    src: /tmp/app.tar.gz
    dest: /opt/app
    remote_src: yes
```

---

##  COMMAND EXECUTION

### `shell`
Run shell commands (with pipes, redirects).

```yaml
- name: Run script
  ansible.builtin.shell: "bash /tmp/myscript.sh"
```

---

### `command`
Run basic system commands (no shell).

```yaml
- name: List users
  ansible.builtin.command: whoami
```

---

### `raw`
Run raw commands (used for bootstrapping).

```yaml
- name: Run raw command
  ansible.builtin.raw: "apt update"
```

---

##  FLOW CONTROL & DEBUGGING

### `debug`
Print debug messages.

```yaml
- name: Show variable
  ansible.builtin.debug:
    var: my_variable
```

---

### `pause`
Pause execution.

```yaml
- name: Wait for confirmation
  ansible.builtin.pause:
    prompt: "Press Enter to continue"
```

---

### `assert`
Assert conditions.

```yaml
- name: Ensure OS is Ubuntu
  ansible.builtin.assert:
    that: ansible_facts['os_family'] == "Debian"
```

---

### `include_tasks`
Include task files.

```yaml
- name: Include additional tasks
  ansible.builtin.include_tasks: tasks/setup.yml
```

---

##  FACTS & VARIABLES

### `setup`
Gather system facts.

```yaml
- name: Gather facts
  ansible.builtin.setup:
```

---

### `set_fact`
Set custom variables.

```yaml
- name: Set a fact
  ansible.builtin.set_fact:
    install_path: /opt/myapp
```

---

##  SUMMARY TABLE

| Module              | Purpose                           |
|---------------------|-----------------------------------|
| `file`              | Manage files/directories          |
| `copy`              | Copy static files                 |
| `template`          | Use Jinja2 templates              |
| `user`, `group`     | User/group management             |
| `service`, `systemd`| Manage services                   |
| `package`, `apt`    | Install packages                  |
| `shell`, `command`  | Run commands                      |
| `debug`, `assert`   | Debugging and checks              |
| `uri`, `get_url`    | HTTP requests and downloads       |
| `unarchive`         | Extract archives                  |
| `include_tasks`     | Modularize playbooks              |
