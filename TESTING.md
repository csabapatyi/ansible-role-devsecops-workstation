# Testing the DevSecOps Workstation Role

This role uses [Molecule](https://molecule.readthedocs.io/) for testing, the standard testing framework for Ansible roles.

## Prerequisites

- Python 3.10+
- Docker
- Make (optional, but recommended)

## Quick Start

```bash
# Create virtual environment and install dependencies
make venv
source .venv/bin/activate

# Run lint checks
make lint

# Run all tests
make test
```

## Test Scenarios

### Default Scenario
Tests basic role functionality across multiple distributions:
- Ubuntu 24.04 (Noble)
- Fedora 43
- Arch Linux

```bash
# Run all platforms
make test

# Run specific platform
make test-ubuntu
make test-fedora
make test-arch
```

### Full Scenario
Extended testing with more features enabled:
- Flatpak installation
- Rust/Cargo packages
- Starship prompt
- Shell configuration

```bash
make test-full
```

## Available Commands

| Command | Description |
|---------|-------------|
| `make venv` | Create Python virtual environment |
| `make lint` | Run ansible-lint and yamllint |
| `make test` | Run default tests on all platforms |
| `make test-ubuntu` | Test on Ubuntu only |
| `make test-fedora` | Test on Fedora only |
| `make test-arch` | Test on Arch Linux only |
| `make test-full` | Run extended test scenario |
| `make test-all` | Run all scenarios |
| `make converge` | Apply role without cleanup |
| `make verify` | Run verification tests |
| `make destroy` | Destroy test containers |
| `make clean` | Clean up artifacts |

## Development Workflow

1. **Make changes** to the role
2. **Converge** to apply changes: `make converge`
3. **Verify** the changes: `make verify`
4. **Login** to container for debugging: `make login-ubuntu`
5. **Destroy** when done: `make destroy`

### Interactive Testing

```bash
# Apply the role (create + converge)
molecule converge

# Login to a container
molecule login --host ubuntu-noble

# Run verification
molecule verify

# Full test cycle
molecule test
```

## Test Structure

```
molecule/
├── default/                    # Default test scenario
│   ├── molecule.yml           # Scenario configuration
│   ├── converge.yml           # Playbook to apply the role
│   ├── prepare.yml            # Pre-test preparation
│   ├── verify.yml             # Post-test verification
│   ├── Dockerfile.ubuntu.j2   # Ubuntu container template
│   ├── Dockerfile.fedora.j2   # Fedora container template
│   ├── Dockerfile.arch.j2     # Arch container template
│   └── requirements.yml       # Ansible Galaxy requirements
├── full/                       # Extended test scenario
│   ├── molecule.yml
│   ├── converge.yml
│   └── verify.yml
└── requirements.txt           # Python dependencies
```

## CI/CD Integration

This role includes GitHub Actions workflows that automatically:

1. **Lint** - Check YAML and Ansible syntax
2. **Test** - Run Molecule tests on all platforms
3. **Release** - Publish to Ansible Galaxy (on main branch)

The CI pipeline runs on:
- Every push to `main` or `develop`
- Every pull request to `main`
- Weekly schedule (Sundays at midnight)

## Writing New Tests

### Adding a Test Case

Add assertions to `molecule/default/verify.yml`:

```yaml
- name: Verify my new feature
  ansible.builtin.command: which my-command
  register: my_check
  changed_when: false
  failed_when: my_check.rc != 0
```

### Adding a New Platform

1. Create a Dockerfile template in `molecule/default/`:
   ```
   molecule/default/Dockerfile.newplatform.j2
   ```

2. Add the platform to `molecule/default/molecule.yml`:
   ```yaml
   platforms:
     - name: newplatform
       image: newplatform:latest
       dockerfile: Dockerfile.newplatform.j2
       # ... other options
   ```

### Creating a New Scenario

```bash
mkdir -p molecule/my-scenario
```

Create the required files:
- `molecule.yml` - Scenario configuration
- `converge.yml` - Role application playbook
- `verify.yml` - Verification playbook

## Troubleshooting

### Container won't start
```bash
# Check Docker logs
docker logs molecule-ubuntu-noble

# Ensure systemd support
docker run --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:rw ubuntu:24.04 /lib/systemd/systemd
```

### Tests timeout
Increase the timeout in `molecule.yml`:
```yaml
provisioner:
  config_options:
    defaults:
      timeout: 120
```

### Idempotence fails
Check which tasks are not idempotent:
```bash
molecule converge
molecule converge  # Run twice to see changes
```

## Local Testing Without Docker

For testing on your local machine (use with caution):

```bash
ansible-playbook -i localhost, -c local \
  -e "workstation_user=$USER" \
  molecule/default/converge.yml --check
```
