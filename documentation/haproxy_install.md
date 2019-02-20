[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_install

Install HAProxy from package or source.

Introduced: v4.0.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `install_type` | String | none | Set the installation type | `package`, `source`
| `bin_prefix` | String | `/usr` | Set the source compile prefix |
| `install_only` | true, false | `false` |  |
| `sensitive` | true, false | `true` | Ensure that sensitive resource data is not logged by the chef-client |
| `service_name` | String | `haproxy` |  |
| `use_systemd` | String | `node['init_package'] == 'systemd' ? '1' : '0'` | Evalues whether to use systemd based on the nodes init package | `0`, `1`
| `haproxy_user` | String | `haproxy` | Similar to "uid" but uses the UID of user name `<user name>` from /etc/passwd |
| `haproxy_group` | String | `haproxy` | Similar to "gid" but uses the GID of group name `<group name>` from /etc/group |
| `conf_template_source` | String | `haproxy.cfg.erb` | Source for the HAProxy config template |
| `conf_file_mode` | String | `0644` | Defines the file mode for the config file |
| `config_cookbook` | String | `haproxy` | Used to configure loading config from another cookbook |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name
| `package_name` | String | `haproxy` |  |
| `package_version` | String, nil | `nil` |  |
| `source_version` | String | `1.7.8` |  |
| `source_url` | String | `http://www.haproxy.org/download/1.7.8/src/haproxy-1.7.8.tar.gz` |  |
| `source_checksum` | String, nil | `nil` |  |
| `source_target_cpu` | String, nil | `node['kernel']['machine']` |  |
| `source_target_arch` | String, nil | `nil` |  |
| `source_target_os` | String | See resource |  |
| `use_libcrypt` | String | `1` |  | `0`, `1`
| `use_pcre` | String | `1` |  | `0`, `1`
| `use_openssl` | String | `1` |  | `0`, `1`
| `use_zlib` | String | `1` |  | `0`, `1`
| `use_linux_tproxy` | String | `1` |  | `0`, `1`
| `use_linux_splice` | String | `1` |  | `0`, `1`

## Examples

```ruby
haproxy_install 'package'
```

```ruby
haproxy_install 'source' do
  source_url node['haproxy']['source_url']
  source_checksum node['haproxy']['source_checksum']
  source_version node['haproxy']['source_version']
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  use_linux_tproxy '1'
  use_linux_splice '1'
end
```
