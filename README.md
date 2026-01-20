# Ansible Role: DevSecOps Workstation

[![Lint](https://github.com/csabapatyi/devsecops-workstation/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/csabapatyi/devsecops-workstation/actions/workflows/ci.yml)
[![Ubuntu 24.04](https://img.shields.io/github/actions/workflow/status/csabapatyi/devsecops-workstation/ci.yml?branch=main&label=Ubuntu%2024.04&logo=ubuntu)](https://github.com/csabapatyi/devsecops-workstation/actions/workflows/ci.yml)
[![Ubuntu 25.10](https://img.shields.io/github/actions/workflow/status/csabapatyi/devsecops-workstation/ci.yml?branch=main&label=Ubuntu%2025.10&logo=ubuntu)](https://github.com/csabapatyi/devsecops-workstation/actions/workflows/ci.yml)
[![Fedora 42](https://img.shields.io/github/actions/workflow/status/csabapatyi/devsecops-workstation/ci.yml?branch=main&label=Fedora%2042&logo=fedora)](https://github.com/csabapatyi/devsecops-workstation/actions/workflows/ci.yml)
[![Fedora 43](https://img.shields.io/github/actions/workflow/status/csabapatyi/devsecops-workstation/ci.yml?branch=main&label=Fedora%2043&logo=fedora)](https://github.com/csabapatyi/devsecops-workstation/actions/workflows/ci.yml)
[![Arch Linux](https://img.shields.io/github/actions/workflow/status/csabapatyi/devsecops-workstation/ci.yml?branch=main&label=Arch%20Linux&logo=archlinux)](https://github.com/csabapatyi/devsecops-workstation/actions/workflows/ci.yml)
[![openSUSE](https://img.shields.io/github/actions/workflow/status/csabapatyi/devsecops-workstation/ci.yml?branch=main&label=openSUSE%20Tumbleweed&logo=opensuse)](https://github.com/csabapatyi/devsecops-workstation/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive and highly opinionated, all-in-one, distribution-agnostic Ansible role designed for DevSecOps consultants to bootstrap a Linux workstation.

## Tested Platforms

| Platform | Version | Status |
|----------|---------|--------|
| Ubuntu | 24.04 LTS (Noble Numbat) | ✅ Supported |
| Ubuntu | 25.10 (Questing Quokka) | ✅ Supported |
| Fedora | 42 | ✅ Supported |
| Fedora | 43 | ✅ Supported |
| Arch Linux | Latest (Rolling) | ✅ Supported |
| openSUSE | Tumbleweed (Rolling) | ✅ Supported |

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
| `direct_deb_urls` | `[]` | URLs of .deb packages to install (Debian/Ubuntu/Pop!_OS). |
| `direct_rpm_urls` | `[]` | URLs of .rpm packages to install (Fedora). |
| `direct_zypper_urls` | `[]` | URLs of .rpm packages to install (openSUSE). |

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
| `custom_shell_content` | `""` | A multi-line string containing aliases, exports, and evals to be appended to your shell RC file. |

## Example Configuration (`extra-vars.yml`)

Save your configuration in a separate file to keep your workstation setup portable.

```yaml
workstation_user: "your_username"
workstation_user_shell: "/bin/bash"

container_engine: "docker"
install_nvidia_drivers: true

virtualization_provider: "libvirt"
install_vagrant: true
install_terraform: true

custom_ppas:
  - "ppa:agornostal/ulauncher"

# This will be used on your Pop!_OS machine
direct_deb_urls:
  - "https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb"

system_packages:
  - git
  - tmux
  - htop
  - glances
  - make
  - ca-certificates
  - golang
  - terraform
  - dnsutils
  - nmap
  - stow
  - alacritty
  - python3-pip
  - ulauncher               # This needs the PPAs: "ppa:agornostal/ulauncher"
  - displaylink-driver      # This needs the direct_deb_url above from Synaptics
  - vscode
  - virt-manager
  - qemu-utils
  - qemu-system-x86
  - qemu-system-common
  - libvirt-daemon
  - libvirt0
  - vagrant

flatpak_packages:
  # Browsers
  - app.zen_browser.zen                 # Zen Browser
  - com.brave.Browser                   # Brave Browser
  - com.microsoft.Edge                  # Microsoft Edge

  # Office and similar tools
  - com.calibre_ebook.calibre           # eBook reader

  # Communications
  - com.slack.Slack                     # https://flathub.org/apps/details/com.slack.Slack

  # DevOps, Cloud and System Management
  - io.github.mfat.sshpilot             # SSH session manager
  - me.iepure.devtoolbox                # Various Dev Tools for example json to yaml converter
  - io.github.tobagin.keysmith          # SSH key management GUI
  - org.kde.krdc                        # RDP & VNC session manager
  - dev.zed.Zed                         # Zed IDE
  - app.devsuite.Ptyxis                 # Container focused terminal emulator
  - com.raggesilver.BlackBox            # GTK4 Terminal
  - dev.skynomads.Seabird               # Kubernetes Desktop GUI

  # Videos & Music player related
  - com.spotify.Client                  # Spotify
  - info.smplayer.SMPlayer              # SMPlayer
  - org.videolan.VLC                    # VLC

  # Backup & Sync Solutions
  - me.kozec.syncthingtk                # GUI to configure sync jobs
  - org.freefilesync.FreeFileSync       # GUI to configure sync jobs

  # Utilities
  - com.github.tchx84.Flatseal          # Flatpak permission manager
  - com.bitwarden.desktop               # Bitwarden Desktop App (password manager)
  - de.z_ray.OptimusUI                  # Nvidia card switcher
  - io.github.cosmic_utils.Examine      # System Information Checker
  - best.ellie.StartupConfiguration     # Autostart configuration
  - org.gnome.baobab                    # Disk usage analyzer
  - page.codeberg.JakobDev.jdSystemMonitor  # System Monitor
  - io.github.vikdevelop.SaveDesktop    # Save Desktop settings

vscode_install_method: repo

vscode_extensions:
  - redhat.ansible
  - ms-azuretools.vscode-docker
  - rust-lang.rust-analyzer

rust_cargo_packages:
  - bat
  - zoxide
  - eza             # better ls
  - topgrade        # all in one upgrade everything (apt, docker images, vscode extensions, pip packages, cargo packages, neovim plugins etc)

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
custom_shell_content: |
    # Custom Settings

    ## Aliases
    alias vim="nvim"
    alias vi="nvim"
    alias ll="eza -hla --group-directories-first"
    alias lls="eza -hla --group-directories-first --total-size"
    alias untar="tar zxfv"

    ### git aliases
    alias gp="git pull"
    alias gcm="git commit -m"
    alias gca="git commit --amend"
    alias gb="git rebase"

    # export PATH and other global variables
    export PATH="${HOME}/.cargo/bin:/opt/nvim-linux-x86_64/bin:${HOME}/.local/bin:${PATH}"
    export EDITOR='nvim'
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
