# Migrating to the Resource-Only API

The haproxy cookbook exposes custom resources as its production API. Wrapper
cookbooks should declare those resources directly instead of including a
production recipe or configuring HAProxy through node attributes.

## Replace Recipe and Attribute Usage

Replace attribute-driven recipe usage such as:

```ruby
node.default['haproxy']['install_method'] = 'package'
include_recipe 'haproxy'
```

with explicit resource declarations:

```ruby
haproxy_install 'package'

haproxy_config_global 'global'

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout(
    'connect' => '5s',
    'client' => '50s',
    'server' => '50s'
  )
end

haproxy_service 'haproxy' do
  action %i(create enable start)
end
```

Declare frontends, backends, listeners, ACLs, resolvers, and other configuration
sections with the corresponding resources listed in the
[README](README.md#resources). Properties on those resources replace cookbook
attributes and make each wrapper cookbook's HAProxy contract explicit.

## Package and Source Installation

Package installation uses the platform package manager:

```ruby
haproxy_install 'package'
```

Source installation requires a version, URL, and matching SHA-256 checksum when
overriding the cookbook defaults:

```ruby
haproxy_install 'source' do
  source_version '3.2.14'
  source_url 'https://www.haproxy.org/download/3.2/src/haproxy-3.2.14.tar.gz'
  source_checksum 'b21f50a790aa8cb0cf8dc505f1f8d849799eafe4d31c14b86a34409ccf4ae5e4'
end
```

## Removal

Use the resources' removal actions to reverse managed state:

```ruby
haproxy_service 'haproxy' do
  action :delete
end

haproxy_install 'package' do
  action :remove
end
```

The service delete action stops and disables the unit before removing it. The
source install remove action deletes the compiled HAProxy binary, legacy
wrapper when applicable, man page, installed documentation, downloaded archive, and extracted source
directory.

## Platform Constraints

Review [AGENTS.md](AGENTS.md) before changing HAProxy release tracks
or relying on distribution packages. The test cookbook under
`test/cookbooks/test` is development-only and is not a production entrypoint.

## Configuration ownership and deletion

Use `config_owner` and `config_group` to set ownership of the configuration
file and directory. For `haproxy_userlist`, `user` and `group` remain hashes
of HAProxy authentication entries; configuration ownership defaults to `haproxy`.
Deleting a userlist removes its entire named section. Deleting an absent ACL,
backend rule or userlist leaves the configuration untouched.

Service units use the binary under `bin_prefix` in master-worker mode (`-Ws`).
HAProxy versions older than 1.8 require an explicit custom unit and are outside
the supported platform matrix.
