[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_install

Install HAProxy from package or source.

Introduced: v4.0.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)

| Name                 | Type        | Default                                                          | Description                                                                    | Allowed Values      |
| -------------------- | ----------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------ | ------------------- |
| `install_type`       | String      | None                                                             | Set the installation type                                                      | `package`, `source` |
| `bin_prefix`         | String      | `/usr`                                                           | Set the source compile prefix                                                  |
| `sensitive`          | true, false | `true`                                                           | Ensure that sensitive resource data is not logged by the chef-client           |
| `use_systemd`        | true, false | `true`                                                           | Evalues whether to use systemd based on the nodes init package                 |
| `user`               | String      | `haproxy`                                                        | Similar to "uid" but uses the UID of user name `<user name>` from /etc/passwd  |
| `group`              | String      | `haproxy`                                                        | Similar to "gid" but uses the GID of group name `<group name>` from /etc/group |
| `package_name`       | String      | `haproxy`                                                        |                                                                                |
| `package_version`    | String, nil | `nil`                                                            |                                                                                |
| `enable_ius_repo`    | true, false | `false`                                                          | Enables the IUS package repo for Centos to install versions >1.5               |
| `enable_epel_repo`   | true, false | `true`                                                           | Enables the epel repo for RHEL based operating systems                         |
| `source_version`     | String      | `2.2.4`                                                          |                                                                                |
| `source_url`         | String      | `http://www.haproxy.org/download/2.2.4/src/haproxy-2.2.4.tar.gz` |                                                                                |
| `source_checksum`    | String, nil | `nil`                                                            |                                                                                |
| `source_target_cpu`  | String, nil | `node['kernel']['machine']`                                      |                                                                                |
| `source_target_arch` | String, nil | `nil`                                                            |                                                                                |
| `source_target_os`   | String      | See resource                                                     |                                                                                |
| `use_libcrypt`       | String      | `1`                                                              |                                                                                | `0`, `1`            |
| `use_pcre`           | String      | `1`                                                              |                                                                                | `0`, `1`            |
| `use_openssl`        | String      | `1`                                                              |                                                                                | `0`, `1`            |
| `use_zlib`           | String      | `1`                                                              |                                                                                | `0`, `1`            |
| `use_linux_tproxy`   | String      | `1`                                                              |                                                                                | `0`, `1`            |
| `use_linux_splice`   | String      | `1`                                                              |                                                                                | `0`, `1`            |
| `use_systemd`        | String      | `1`                                                              |                                                                                | `0`, `1`            |
| `use_lua`            | String      | `0`                                                              | `0`, `1`                                                                       |
| `lua_lib`            | String, nil | `nil`                                                            |                                                                                |
| `lua_inc`            | String, nil | `nil`                                                            |                                                                                |

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
