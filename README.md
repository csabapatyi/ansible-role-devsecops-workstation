# Ansible Role: DevSecOps Workstation

[![Lint](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml)
[![Ubuntu 24.04](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml/badge.svg?branch=main&name=Ubuntu%2024.04)](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml)
[![Ubuntu 25.10](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml/badge.svg?branch=main&name=Ubuntu%2025.10)](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml)
[![Fedora 42](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml/badge.svg?branch=main&name=Fedora%2042)](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml)
[![Fedora 43](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml/badge.svg?branch=main&name=Fedora%2043)](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml)
[![Arch Linux](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml/badge.svg?branch=main&name=Arch%20Linux)](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml)
[![openSUSE Tumbleweed](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml/badge.svg?branch=main&name=openSUSE%20Tumbleweed)](https://github.com/csabapatyi/ansible-role-devsecops-workstation/actions/workflows/ci.yml)
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

- **Multi-Distro Support**: Works across APT, DNF, Pacman, and Zypper.
- **Flexible Repositories**: Add any third-party GPG keys and repositories via variables.
- **Universal Apps**: Support for Flatpak, Snap, and AppImages.
- **Container Choice**: Toggle between official Docker CE or native Podman (with rootless config).
- **VS Code Mastery**: Install via Repo or Flatpak and manage extensions automatically.
- **Dev Tooling**: Integrated support for Cargo (Rust) packages and direct binary URL downloads.
- **Hardware Ready**: Optional Nvidia proprietary or open-source driver installation.
- **Btrfs Integration**: Manage subvolumes, enable automatic apt snapshots, and configure snapper for timeline-based backups (similar to openSUSE).

## Role Variables

The following variables are defined in `defaults/main.yml`. You can override these in your playbook's `extra_vars` or `host_vars`.

### User & Shell Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `workstation_user` | `{{ ansible_user_id }}` | The system user to configure. |
| `workstation_user_shell` | `/bin/bash` | Target shell (e.g., `/bin/zsh`, `/usr/bin/fish`). |
| `install_starship` | `false` | Installs the Starship shell prompt binary. |
| `load_custom_starship_config` | `false` | If true, deploys the included `starship.toml.j2` template. |
| `starship_config_dir` | `~/.config` | Directory where `starship.toml` will be placed. |
| `custom_shell_content` | `""` | Multi-line string with aliases, exports, etc. to append to shell RC file. |
| `custom_shell_aliases` | `[]` | List of alias definitions (alternative to `custom_shell_content`). |

### Drivers

| Variable | Default | Description |
|----------|---------|-------------|
| `install_nvidia_drivers` | `false` | Whether to install Nvidia GPU drivers. |
| `nvidia_driver_type` | `proprietary` | `proprietary`, `open`, or `nouveau`. |
| `nvidia_packages` | `[]` | Override default Nvidia packages for your distro. |

### Virtualization & Containers

| Variable | Default | Description |
|----------|---------|-------------|
| `virtualization_provider` | `none` | `libvirt` (KVM/QEMU), `virtualbox`, or `none`. |
| `install_vagrant` | `false` | Install Vagrant from HashiCorp repo. |
| `install_terraform` | `false` | Install Terraform from HashiCorp repo. |
| `install_vbox_extpack` | `false` | Install Oracle VBox Extension Pack (requires `virtualbox`). |
| `container_engine` | `none` | `docker` (official repo), `podman`, or `none`. |
| `hashicorp_fallback_release` | `""` | Fallback release codename for HashiCorp repos. |
| `vbox_fallback_release` | `""` | Fallback release codename for VirtualBox repos. |

### Package Installation

| Variable | Default | Description |
|----------|---------|-------------|
| `system_packages` | `[]` | Packages to install via OS package manager (apt, dnf, pacman, zypper). |
| `direct_deb_urls` | `[]` | URLs of .deb packages to install (Debian/Ubuntu). |
| `direct_rpm_urls` | `[]` | URLs of .rpm packages to install (Fedora/RHEL). |
| `direct_zypper_urls` | `[]` | URLs of .rpm packages to install (openSUSE). |
| `direct_pacman_urls` | `[]` | URLs of .pkg.tar.zst packages to install (Arch). |

### Repository Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `custom_repositories` | `[]` | Custom repos with GPG keys (supports apt, yum, zypper). |
| `custom_ppas` | `[]` | Ubuntu/Pop!_OS PPAs to add (ignored on non-Debian). |

### Flatpak & Snap

| Variable | Default | Description |
|----------|---------|-------------|
| `flatpak_remotes` | `[]` | Additional Flatpak remotes (Flathub added by default). |
| `flatpak_packages` | `[]` | List of Flatpak application IDs from Flathub. |
| `install_snapd` | `false` | Whether to install snapd. |
| `snap_packages` | `[]` | List of Snaps to install. |

### VS Code Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `vscode_install_method` | `none` | `repo` (native), `flatpak`, `snap`, or `none`. |
| `vscode_extensions` | `[]` | List of extension IDs (e.g., `redhat.ansible`). |

### Development Tools

| Variable | Default | Description |
|----------|---------|-------------|
| `rust_cargo_packages` | `[]` | List of crates to install via `cargo install`. |
| `npm_packages` | `[]` | List of global NPM packages to install. |
| `install_neovim` | `false` | Whether to install Neovim. |

### Binary Downloads

| Variable | Default | Description |
|----------|---------|-------------|
| `url_packages` | `[]` | Binaries to download from URLs (supports archives). |
| `appimage_packages` | `[]` | AppImages (Name/URL) to download to `~/Applications`. |

### GitHub Repositories

| Variable | Default | Description |
|----------|---------|-------------|
| `github_repos` | `[]` | Git repositories to clone (repo, dest, version). |

### Cloud & DevSecOps CLIs

| Variable | Default | Description |
|----------|---------|-------------|
| `install_aws_cli` | `false` | Installs AWS CLI v2 and SSM Session Manager plugin. |
| `install_azure_cli` | `false` | Installs the Azure CLI. |
| `install_gcp_cli` | `false` | Installs the Google Cloud SDK. |
| `install_gitlab_cli` | `false` | Installs `glab`. |
| `install_github_cli` | `false` | Installs `gh`. |

### Dotfiles & Fonts

| Variable | Default | Description |
|----------|---------|-------------|
| `dotfiles_repo` | `""` | Git URL of your dotfiles repository. |
| `dotfiles_dest` | `~/.dotfiles` | Path where dotfiles will be cloned. |
| `dotfiles_version` | `main` | Branch, tag, or commit to checkout. |
| `nerd_font_urls` | `[]` | List of ZIP URLs for Nerd Fonts to install. |

### Btrfs Configuration

Manage btrfs subvolumes and enable automatic snapshots before/after apt operations (similar to openSUSE's snapper integration with zypper).

#### Subvolume Management

| Variable | Default | Description |
|----------|---------|-------------|
| `btrfs_manage_subvolumes` | `false` | Enable btrfs subvolume management. |
| `btrfs_device` | `/dev/sda2` | Btrfs device/partition for subvolume operations. |
| `btrfs_mount_point` | `/mnt/btrfs-root` | Temporary mount point for subvolume creation. |
| `btrfs_subvolumes` | `[]` | List of subvolumes to create/manage. |
| `btrfs_default_mount_options` | `defaults,noatime,compress=zstd:1,space_cache=v2` | Default mount options for subvolumes. |
| `btrfs_is_ssd` | `false` | Enable SSD-specific mount options. |
| `btrfs_ssd_options` | `discard=async,ssd` | SSD mount options (appended when `btrfs_is_ssd` is true). |

#### APT Btrfs Snapshots (Debian-based only)

| Variable | Default | Description |
|----------|---------|-------------|
| `btrfs_apt_snapshots_enable` | `false` | Enable automatic snapshots before/after apt operations. |
| `btrfs_apt_snapshots_subvolume` | `@` | Subvolume to snapshot. |
| `btrfs_apt_snapshots_dir` | `/.snapshots` | Directory to store apt snapshots. |
| `btrfs_apt_snapshots_prefix` | `apt-snapshot` | Snapshot naming prefix. |
| `btrfs_apt_snapshots_keep` | `10` | Maximum snapshots to retain (0 = unlimited). |
| `btrfs_apt_snapshots_post` | `true` | Create post-transaction snapshot for comparison. |
| `btrfs_apt_snapshots_description` | `APT {action} on {date} at {time}` | Snapshot description format. |

#### Snapper Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `btrfs_install_snapper` | `false` | Install and configure snapper for timeline-based snapshots. |
| `btrfs_snapper_configs` | `[]` | List of snapper configurations to create. |

## Example Configuration (`extra-vars.yml`)

Save your configuration in a separate file to keep your workstation setup portable.

```yaml
workstation_user: "your_username"
workstation_user_shell: "/bin/bash"

# Container & Virtualization
container_engine: "docker"
virtualization_provider: "libvirt"
install_vagrant: true
install_terraform: true

# Drivers
install_nvidia_drivers: true
nvidia_driver_type: "proprietary"

# Ubuntu/Pop!_OS specific PPAs
custom_ppas:
  - "ppa:agornostal/ulauncher"

# Custom repositories with GPG keys (cross-distro)
custom_repositories:
  - name: "google-chrome"
    apt_repo: "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main"
    yum_repo: "https://dl.google.com/linux/chrome/rpm/stable/x86_64"
    gpg_key: "https://dl.google.com/linux/linux_signing_key.pub"

# Direct package URLs (installed before repositories)
direct_deb_urls:
  - "https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb"

# System packages via OS package manager
system_packages:
  - git
  - tmux
  - htop
  - glances
  - make
  - ca-certificates
  - golang
  - terraform
  - nmap
  - stow
  - alacritty
  - python3-pip
  - ulauncher               # Requires PPA above
  - displaylink-driver      # Requires direct_deb_url above
  - virt-manager
  - qemu-utils

# Flatpak applications
flatpak_packages:
  # Browsers
  - app.zen_browser.zen
  - com.brave.Browser
  - com.microsoft.Edge

  # Communications
  - com.slack.Slack

  # DevOps Tools
  - dev.zed.Zed
  - app.devsuite.Ptyxis
  - dev.skynomads.Seabird

  # Media
  - com.spotify.Client
  - org.videolan.VLC

  # Utilities
  - com.github.tchx84.Flatseal
  - com.bitwarden.desktop

# VS Code
vscode_install_method: "repo"
vscode_extensions:
  - redhat.ansible
  - ms-azuretools.vscode-docker
  - rust-lang.rust-analyzer

# Development tools
install_neovim: true

rust_cargo_packages:
  - bat
  - zoxide
  - eza
  - topgrade

npm_packages:
  - typescript
  - prettier

# Binary downloads
url_packages:
  - name: "kubectl"
    url: "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl"
    dest: "/usr/local/bin/kubectl"
  - name: "helm"
    url: "https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz"
    dest: "/usr/local/bin/helm"
    extract: true
    extract_path: "linux-amd64/helm"

# Clone repositories
github_repos:
  - repo: "https://github.com/youruser/scripts.git"
    dest: "~/Projects/scripts"
    version: "main"

# Cloud CLIs
install_aws_cli: true
install_azure_cli: true
install_gcp_cli: true
install_gitlab_cli: true
install_github_cli: true

# Dotfiles & Fonts
dotfiles_repo: "https://github.com/youruser/dotfiles.git"
dotfiles_dest: "~/.dotfiles"
dotfiles_version: "main"

nerd_font_urls:
  - "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
  - "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"

# Shell configuration
install_starship: true
load_custom_starship_config: false

# Btrfs Configuration (for btrfs root filesystems)
btrfs_manage_subvolumes: false
btrfs_device: "/dev/vda2"
btrfs_is_ssd: true

# Best practice subvolume layout
btrfs_subvolumes:
  - name: "@"
    path: "/"
  - name: "@home"
    path: "/home"
  - name: "@snapshots"
    path: "/.snapshots"
  - name: "@var_log"
    path: "/var/log"
    snapshot: false
  - name: "@var_cache"
    path: "/var/cache"
    snapshot: false

# APT automatic snapshots (like openSUSE's zypper integration)
btrfs_apt_snapshots_enable: true
btrfs_apt_snapshots_keep: 10
btrfs_apt_snapshots_post: true

# Snapper for timeline-based snapshots
btrfs_install_snapper: true
btrfs_snapper_configs:
  - name: "root"
    subvolume: "/"
    timeline_create: true
    timeline_cleanup: true
    timeline_limit_hourly: 5
    timeline_limit_daily: 7
    timeline_limit_weekly: 4
    timeline_limit_monthly: 6
    timeline_limit_yearly: 2

custom_shell_content: |
    # Aliases
    alias vim="nvim"
    alias vi="nvim"
    alias ll="eza -hla --group-directories-first"
    alias lls="eza -hla --group-directories-first --total-size"

    # Git aliases
    alias gp="git pull"
    alias gcm="git commit -m"
    alias gca="git commit --amend"

    # Environment
    export PATH="${HOME}/.cargo/bin:${HOME}/.local/bin:${PATH}"
    export EDITOR='nvim'

# Alternative: use structured aliases
custom_shell_aliases:
  - { alias: "k", command: "kubectl" }
  - { alias: "g", command: "git" }
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
