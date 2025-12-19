# Ansible Role: DevSecOps Workstation

A comprehensive, (wished to be) distribution-agnostic Ansible role designed for DevSecOps consultants to bootstrap a Linux workstation. Currently tested on **Pop!_OS (Ubuntu)**. Future plans are **Fedora**, and **openSUSE Tumbleweed**.

This role automates the installation of system packages, container engines (Docker/Podman), VS Code with extensions, Rust toolchains, Starship prompt, and Nvidia drivers.

## Features

- **Multi-Distro Support**: Works across APT, DNF, and Zypper.
- **Flexible Repositories**: Add any third-party GPG keys and repositories via variables.
- **Universal Apps**: Support for Flatpak, Snap, and AppImages.
- **Container Choice**: Toggle between official Docker CE or native Podman (with rootless config).
- **VS Code Mastery**: Install via Repo or Flatpak and manage extensions automatically.
- **Dev Tooling**: Integrated support for Cargo (Rust) packages and direct binary URL downloads.
- **Hardware Ready**: Optional Nvidia proprietary or open-source driver installation.

## Role Variables

The following variables are defined in `defaults/main.yml`. You can override these in your playbook's `extra_vars` or `host_vars`.

### User & Shell Configuration
| Variable | Default | Description |
|----------|---------|-------------|
| `workstation_user` | `{{ ansible_user_id }}` | The system user to configure. |
| `workstation_user_shell` | `/bin/bash` | Target shell (e.g., `/usr/bin/zsh`, `/usr/bin/fish`). |
| `install_starship` | `true` | Installs the Starship shell prompt binary. |
| `load_custom_starship_config` | `false` | If true, deploys the included `starship.toml.j2` template. |
| `starship_config_dir` | `~/.config` | Directory where `starship.toml` will be placed. |

### Drivers
| Variable | Default | Description |
|----------|---------|-------------|
| `install_nvidia_drivers` | `false` | Whether to install Nvidia GPU drivers. |
| `nvidia_driver_type` | `proprietary` | `proprietary` or `open`. |


### Virtualization & Containers

| Variable | Default | Description |
|----------|---------|-------------|
| `virtualization_provider` | `libvirt` | Choose libvirt (KVM/QEMU) or virtualbox. |
| `install_vagrant` | `false` | Install Vagrant from HashiCorp repo. |
| `install_terraform` | `false` | Install Terraform from HashiCorp repo. |
| `install_vbox_extpack` | `false` | Whether to install Oracle VBox Extension Pack. |
| `container_engine` | `docker` | `docker` (official repo) or `podman`. |

### Software & VS Code
| Variable | Default | Description |
|----------|---------|-------------|
| `vscode_install_method` | `repo` | `repo` (native), `flatpak`, or `snap`. |
| `vscode_extensions` | `[]` | List of extension IDs (e.g., `redhat.ansible`). |
| `system_packages` | `[]` | List of packages to install via system package manager. |
| `flatpak_packages` | `[]` | List of Flatpak IDs from Flathub. |
| `snap_packages` | `[]` | List of Snaps to install. |
| `appimage_packages` | `[]` | List of AppImages (Name/URL) to download to `~/Applications`. |
| `rust_cargo_packages` | `[]` | List of crates to install via `cargo install`. |
| `url_packages` | `[]` | List of binaries to download directly from a URL. |

### Cloud & DevSecOps CLIs
| Variable | Default | Description |
|----------|---------|-------------|
| `install_aws_cli` | `false` | Installs AWS CLI v2 and SSM Session Manager plugin. |
| `install_azure_cli` | `false` | Installs the Azure CLI. |
| `install_gcp_cli` | `false` | Installs the Google Cloud SDK. |
| `install_gitlab_cli` | `false` | Installs `glab`. |
| `install_github_cli` | `false` | Installs `gh`. |

### Ricing & Personalization
| Variable | Default | Description |
|----------|---------|-------------|
| `nerd_font_urls` | `[...]` | List of ZIP URLs for Nerd Fonts to install to `~/.local/share/fonts`. |
| `dotfiles_repo` | `""` | Git URL of your dotfiles repository. |
| `dotfiles_dest` | `~/.dotfiles` | Path where dotfiles will be cloned. |
| `custom_shell_aliases` | `[]` | List of objects `{ alias: "name", command: "cmd" }`. |

## Example Configuration (`extra-vars.yml`)

Save your configuration in a separate file to keep your workstation setup portable.

```yaml
workstation_user: "your_username"
workstation_user_shell: "/usr/bin/zsh"

container_engine: "docker"
install_nvidia_drivers: true

system_packages:
  - git
  - tmux
  - htop
  - glances
  - terraform
  - python3-pip


vscode_extensions:
  - redhat.ansible
  - ms-azuretools.vscode-docker
  - rust-lang.rust-analyzer

rust_cargo_packages:
  - exa
  - ripgrep
  - topgrade

url_packages:
  - name: "kubectl"
    url: "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl"
    dest: "/usr/local/bin/kubectl"

# Cloud & CLI Tools
install_aws_cli: true
install_azure_cli: true
install_gcp_cli: true
install_gitlab_cli: true
install_github_cli: true

# Ricing
install_nerd_fonts: true
dotfiles_repo: "https://github.com/youruser/dotfiles.git"
custom_shell_aliases:
  - { alias: "ll", command: "ls -lah" }
  - { alias: "tf", command: "terraform" }
```

## Usage

### 1. Install the role
If you have uploaded this to Galaxy:
```bash
ansible-galaxy install csabapatyi.devsecops-workstation
```

### 2. Create a Playbook
Create a `setup.yml` file:
```yaml
---
- hosts: localhost
  connection: local
  become: true
  roles:
    - role: csabapatyi.devsecops-workstation
```

### 3. Run the Playbook
```bash
ansible-playbook setup.yml -e "@extra-vars.yml" --ask-become-pass
```

## Project Structure

```text
.
├── defaults/          # Default variables
├── vars/              # OS-specific variables (Debian, RedHat, Suse)
├── tasks/             # Modular task files
├── templates/         # Optional Starship configuration templates
├── meta/              # Role metadata for Galaxy
└── README.md          # This file
```

## License

MIT

## Author Information

Created by **Csaba Patyi**, DevSecOps Consultant and Cloud Solution Architect.