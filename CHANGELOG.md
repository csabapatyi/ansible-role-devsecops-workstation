# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- **Btrfs Integration**: Manage btrfs subvolumes, enable automatic APT snapshots before/after package operations (similar to openSUSE's snapper/zypper integration), and configure snapper for timeline-based backups.
  - New variables: `btrfs_manage_subvolumes`, `btrfs_device`, `btrfs_mount_point`, `btrfs_subvolumes`, `btrfs_default_mount_options`, `btrfs_is_ssd`, `btrfs_ssd_options`.
  - New variables: `btrfs_apt_snapshots_enable`, `btrfs_apt_snapshots_subvolume`, `btrfs_apt_snapshots_dir`, `btrfs_apt_snapshots_prefix`, `btrfs_apt_snapshots_keep`, `btrfs_apt_snapshots_post`, `btrfs_apt_snapshots_description`.
  - New variables: `btrfs_install_snapper`, `btrfs_snapper_configs`.
  - New task file: `tasks/btrfs.yml`.
- **Arch Linux (Pacman)** added to multi-distro support list in documentation.

### Fixed

- **apt package installation idempotency**: The `Install system packages (Debian/Ubuntu)` task no longer falsely reports `changed` when all packages are already installed. Replaced `update_cache: true` with stdout-based change detection using `changed_when`.
- **VS Code repository idempotency**: The `Add VS Code Repository` task no longer always reports `changed` on Debian systems. Replaced `apt_repository` module with `copy` module for writing the sources list file, which is reliably idempotent.
- **Docker repository idempotency**: Applied the same `apt_repository` to `copy` fix for the Docker repository task.
- **apt cache update idempotency**: The `Update apt cache (Debian)` task now uses `changed_when: false` since it is a cache refresh gated by actual repository changes, not a state change itself.
- **Nerd Fonts idempotency**: Split font installation into separate download and extract steps so fonts are only extracted when newly downloaded, and the font cache is only rebuilt when fonts actually change.
- **README OS badges**: Switched per-OS status badges from shields.io (which only reports overall workflow status) to GitHub's native per-job badge API using the `?name=` parameter, so each badge correctly reflects its individual job result.