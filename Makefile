#------------------------------------------------------------------------------
# Makefile for DevSecOps Workstation Ansible Role
#------------------------------------------------------------------------------

.PHONY: help lint test test-all test-ubuntu-2404 test-ubuntu-2510 test-fedora-42 test-fedora-43 test-archlinux test-opensuse test-full clean venv

# Default target
help:
	@echo "╔════════════════════════════════════════════════════════════════╗"
	@echo "║  DevSecOps Workstation Role - Development Commands             ║"
	@echo "╠════════════════════════════════════════════════════════════════╣"
	@echo "║  make venv            - Create Python virtual environment      ║"
	@echo "║  make lint            - Run ansible-lint and yamllint          ║"
	@echo "║  make test            - Run default Molecule tests (all)       ║"
	@echo "║  make test-ubuntu-2404 - Run tests on Ubuntu 24.04             ║"
	@echo "║  make test-ubuntu-2510 - Run tests on Ubuntu 25.10             ║"
	@echo "║  make test-fedora-42  - Run tests on Fedora 42                 ║"
	@echo "║  make test-fedora-43  - Run tests on Fedora 43                 ║"
	@echo "║  make test-archlinux  - Run tests on Arch Linux                ║"
	@echo "║  make test-opensuse   - Run tests on openSUSE Tumbleweed       ║"
	@echo "║  make test-full       - Run full test scenario                 ║"
	@echo "║  make test-all        - Run all test scenarios                 ║"
	@echo "║  make converge        - Run molecule converge (no destroy)     ║"
	@echo "║  make verify          - Run molecule verify                    ║"
	@echo "║  make destroy         - Destroy test containers                ║"
	@echo "║  make clean           - Clean up test artifacts                ║"
	@echo "╚════════════════════════════════════════════════════════════════╝"

# Create virtual environment
venv:
	@echo "Creating Python virtual environment..."
	python3 -m venv .venv
	.venv/bin/pip install --upgrade pip
	.venv/bin/pip install -r molecule/requirements.txt
	.venv/bin/ansible-galaxy collection install community.general ansible.posix community.docker
	@echo ""
	@echo "Virtual environment created. Activate with:"
	@echo "  source .venv/bin/activate"

# Lint the role
lint:
	@echo "Running yamllint..."
	yamllint -c .yamllint.yml . || true
	@echo ""
	@echo "Running ansible-lint..."
	ansible-lint --force-color

# Run default molecule tests on all platforms
test:
	molecule test --scenario-name default

# Run tests on specific platforms
test-ubuntu-2404:
	molecule test --scenario-name default --platform-name ubuntu-2404

test-ubuntu-2510:
	molecule test --scenario-name default --platform-name ubuntu-2510

test-fedora-42:
	molecule test --scenario-name default --platform-name fedora-42

test-fedora-43:
	molecule test --scenario-name default --platform-name fedora-43

test-archlinux:
	molecule test --scenario-name default --platform-name archlinux

test-opensuse:
	molecule test --scenario-name default --platform-name opensuse-tumbleweed

# Run full test scenario
test-full:
	molecule test --scenario-name full

# Run all test scenarios
test-all: test test-full

# Development helpers
converge:
	molecule converge --scenario-name default

verify:
	molecule verify --scenario-name default

destroy:
	molecule destroy --scenario-name default
	molecule destroy --scenario-name full || true

login-ubuntu-2404:
	molecule login --scenario-name default --host ubuntu-2404

login-ubuntu-2510:
	molecule login --scenario-name default --host ubuntu-2510

login-fedora-42:
	molecule login --scenario-name default --host fedora-42

login-fedora-43:
	molecule login --scenario-name default --host fedora-43

login-archlinux:
	molecule login --scenario-name default --host archlinux

login-opensuse:
	molecule login --scenario-name default --host opensuse-tumbleweed

# Syntax check only
syntax:
	molecule syntax --scenario-name default

# Idempotence check
idempotence:
	molecule idempotence --scenario-name default

# Clean up
clean:
	molecule destroy --scenario-name default || true
	molecule destroy --scenario-name full || true
	rm -rf .molecule/
	rm -rf __pycache__/
	find . -name "*.pyc" -delete
	find . -name ".pytest_cache" -type d -exec rm -rf {} + || true
