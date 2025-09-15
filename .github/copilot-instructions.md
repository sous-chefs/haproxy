# HAProxy Cookbook Development Instructions

**ALWAYS follow these instructions first and fallback to additional search and context gathering only if the information here is incomplete or found to be in error.**

This is a Chef cookbook for installing and configuring HAProxy load balancer. It provides custom Chef resources for managing HAProxy installations, configurations, and services across multiple platforms.

## Working Effectively

### Bootstrap Environment and Dependencies
```bash
# Install Chef development tools (choose one method):
# Method 1: Install Chef Workstation (recommended)
wget https://packages.chef.io/files/stable/chef-workstation/24.12.1031/ubuntu/24.04/chef-workstation_24.12.1031-1_amd64.deb
sudo dpkg -i chef-workstation_24.12.1031-1_amd64.deb

# Method 2: Install individual gems if Chef Workstation fails
sudo gem install cookstyle chefspec rspec berkshelf test-kitchen kitchen-dokken --no-document
```

### Core Development Commands
```bash
# Install cookbook dependencies (if berkshelf is available)
berks install
# NOTE: If berkshelf is not installed, cookbook will still work for basic linting/testing

# Lint Ruby code - takes 2-3 seconds - NEVER CANCEL
cookstyle .

# Fix auto-correctable linting issues
cookstyle -a .

# Run unit tests - takes 30 seconds to 2 minutes - NEVER CANCEL
# NOTE: Requires full Chef installation with chefspec gem
rspec spec/

# Run all unit tests with detailed output
rspec spec/ --format documentation
```

### Integration Testing (Advanced)
**CRITICAL**: Integration tests require Docker and take 15-45 minutes per suite. NEVER CANCEL.
**NOTE**: Requires test-kitchen and kitchen-dokken gems installed.

```bash
# List all available test suites (requires test-kitchen installation)
kitchen list

# Test a specific suite - NEVER CANCEL: Takes 15-45 minutes
# Set timeout to 60+ minutes for any kitchen commands
kitchen test package-ubuntu-2204

# Test source compilation (takes longest) - NEVER CANCEL: Takes 30-60 minutes  
kitchen test source-default-ubuntu-2204

# Destroy test instances after testing
kitchen destroy
```

### Build Validation Workflow
**Minimal validation** (works in any environment with cookstyle):
```bash
# 1. Lint code (~2-3 seconds) - ALWAYS WORKS
cookstyle .

# 2. Fix linting issues automatically - ALWAYS WORKS  
cookstyle -a .

# 3. Verify Ruby syntax - ALWAYS WORKS
ruby -c resources/install.rb
ruby -c resources/service.rb
```

**Full validation** (requires complete Chef environment):
```bash
# 1. Lint code (~2-3 seconds)
cookstyle .

# 2. Run unit tests (~30 seconds - 2 minutes) - NEVER CANCEL
rspec spec/

# 3. Test basic package installation (15-30 minutes) - NEVER CANCEL
kitchen test package-ubuntu-2204

# 4. Clean up test instances
kitchen destroy
```

## Timing Expectations and Timeouts
- **Linting (`cookstyle`)**: 2-3 seconds
- **Unit tests (`rspec`)**: 30 seconds to 2 minutes - NEVER CANCEL
- **Single integration test**: 15-45 minutes - NEVER CANCEL - Set timeout to 60+ minutes
- **Source compilation tests**: 30-60 minutes - NEVER CANCEL - Set timeout to 90+ minutes  
- **Full CI matrix**: 1-2 hours across all platforms and suites

**CRITICAL**: Always set timeouts of 60+ minutes for kitchen commands and 30+ minutes for unit tests.

## Manual Validation Scenarios

After making changes, ALWAYS test at least one complete scenario:

### Package Installation Validation
```bash
# Test the most common installation method
kitchen converge package-ubuntu-2204
kitchen verify package-ubuntu-2204
kitchen destroy package-ubuntu-2204
```

### Source Compilation Validation  
```bash
# Test source compilation (most complex scenario)
kitchen converge source-default-ubuntu-2204
kitchen verify source-default-ubuntu-2204
kitchen destroy source-default-ubuntu-2204
```

### Configuration Validation
```bash
# Test configuration management
kitchen converge config-2-ubuntu-2204
kitchen verify config-2-ubuntu-2204
kitchen destroy config-2-ubuntu-2204
```

## Repository Structure and Navigation

### Key Directories
- `resources/` - Custom Chef resources (install.rb, service.rb, config_global.rb, etc.)
- `libraries/` - Helper modules and shared code
- `test/cookbooks/test/recipes/` - Test recipes for integration testing
- `test/integration/` - InSpec integration test controls
- `spec/unit/` - ChefSpec unit tests
- `templates/` - ERB templates for configuration files
- `documentation/` - Resource documentation

### Important Files
- `metadata.rb` - Cookbook metadata and dependencies
- `Berksfile` - Cookbook dependency management
- `kitchen.yml` - Vagrant-based integration testing (local development)
- `kitchen.dokken.yml` - Docker-based integration testing (CI)
- `.rubocop.yml` - Ruby linting configuration
- `.github/workflows/ci.yml` - Continuous integration pipeline

### Common Test Suites
- `package` - Test package installation method
- `source-default` - Test default source compilation
- `source-24`, `source-26`, `source-28` - Test specific HAProxy versions
- `config-2`, `config-acl`, `config-ssl-redirect` - Test various configurations
- `source-lua` - Test Lua compilation support

## Cookbook Architecture

### Custom Resources Available
- `haproxy_install` - Install HAProxy via package or source
- `haproxy_service` - Manage HAProxy service
- `haproxy_config_global` - Global configuration section
- `haproxy_config_defaults` - Default configuration section  
- `haproxy_frontend` - Frontend configuration
- `haproxy_backend` - Backend configuration
- `haproxy_listen` - Listen section (combines frontend/backend)
- `haproxy_acl` - Access Control Lists
- `haproxy_userlist` - User authentication lists

### Installation Methods
1. **Package Installation**: Uses system packages (fastest, recommended for most users)
2. **Source Compilation**: Compiles HAProxy from source (slower, more flexible options)

## Development Workflow

### Making Changes
1. **Understand the resource**: Check `resources/` directory for the relevant resource file
2. **Check existing tests**: Look in `test/integration/` and `spec/unit/` for related tests
3. **Make minimal changes**: Modify only what's necessary
4. **Test locally**: Run linting and unit tests first
5. **Integration test**: Test with kitchen for the affected functionality
6. **Validate**: Ensure the resource works as expected in a real scenario

### Adding New Features
1. **Check existing resources**: See if functionality exists in another resource
2. **Follow patterns**: Use existing resources as templates for new ones
3. **Add tests**: Create both unit tests (ChefSpec) and integration tests (InSpec)
4. **Document**: Add or update documentation in `documentation/` directory

### Debugging Issues
- Use `kitchen diagnose` to check test kitchen configuration
- Use `kitchen login` to access test instances for debugging
- Check `/var/log/chef/` in test instances for Chef run logs
- Use `haproxy -c -f /etc/haproxy/haproxy.cfg` to validate HAProxy config syntax

## Platform Support
- **Debian**: 11, 12
- **Ubuntu**: 20.04, 22.04  
- **CentOS Stream**: 9
- **Amazon Linux**: 2023

Test changes across different platforms when modifying core installation or service logic.

## CI Pipeline Understanding
The GitHub Actions CI runs:
1. **Lint-unit**: Cookstyle linting + ChefSpec unit tests (~5 minutes)
2. **Integration**: Kitchen tests across platform matrix (~1-2 hours total)
3. **Platform-specific**: Additional testing for Amazon Linux

The pipeline tests all combinations of:
- Multiple operating systems
- Package vs source installation methods  
- Different HAProxy versions and configurations
- Various use cases (ACL, SSL, Lua support, etc.)

## Common Pitfalls to Avoid
- **DO NOT** run integration tests without Docker properly configured
- **DO NOT** cancel long-running builds or tests - they take time to compile HAProxy
- **DO NOT** modify resource partials in `resources/partial/` without understanding impacts
- **DO NOT** change service resource without testing service management functionality
- **ALWAYS** test both package and source installation methods if changing install logic
- **ALWAYS** validate HAProxy configuration syntax when changing config generation

## Quick Reference Commands

```bash
# Common file listing
ls -la                                    # Repository root contents
ls resources/                             # Available Chef resources  
ls test/integration/                      # Integration test suites
kitchen list                              # Available test instances

# Quick validation
cookstyle . | head -20                    # Show first linting issues
rspec spec/ --fail-fast                   # Stop on first test failure
kitchen diagnose | grep -A5 platforms     # Show test platforms
```

Use these instructions as your primary reference. Only search for additional information when encountering errors or missing details not covered here.