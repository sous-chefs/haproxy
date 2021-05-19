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
| `package_version`    | String      |                                                                  |                                                                                |
| `enable_ius_repo`    | true, false | `false`                                                          | Enables the IUS package repo for Centos to install versions >1.5               |
| `enable_epel_repo`   | true, false | `true`                                                           | Enables the epel repo for RHEL based operating systems                         |
| `source_version`     | String      | `2.2.4`                                                          |                                                                                |
| `source_url`         | String      | `http://www.haproxy.org/download/2.2.4/src/haproxy-2.2.4.tar.gz` |                                                                                |
| `source_checksum`    | String      |                                                                  |                                                                                |
| `source_target_cpu`  | String      | `node['kernel']['machine']`                                      |                                                                                |
| `source_target_arch` | String      |                                                                  |                                                                                |
| `source_target_os`   | String      | See resource                                                     |                                                                                |
| `use_libcrypt`       | String      | `true`                                                           |                                                                                | `true`, `false`     |
| `use_pcre`           | String      | `true`                                                           |                                                                                | `true`, `false`     |
| `use_openssl`        | String      | `true`                                                           | Include openssl support (https://openssl.org)                                  | `true`, `false`     |
| `use_zlib`           | String      | `true`                                                           | Include ZLIB support                                                           | `true`, `false`     |
| `use_linux_tproxy`   | String      | `true`                                                           |                                                                                | `true`, `false`     |
| `use_linux_splice`   | String      | `true`                                                           |                                                                                | `true`, `false`     |
| `use_systemd`        | String      | `true`                                                           |                                                                                | `true`, `false`     |
| `use_lua`            | String      | `false`                                                          | Include Lua support                                                            | `true`, `false`     |
| `lua_lib`            | String      |                                                                  | Path for lua library files ex: `/opt/lib-5.3.5/lib`                            |
| `lua_inc`            | String      |                                                                  | Path for lua library files ex: `/opt/lib-5.3.5/include`                        |
| `ssl_lib`            | String      |                                                                  | Path for openssl library files ex: `/usr/local/openssl/lib`                    |
| `ssl_inc`            | String      |                                                                  | Path for openssl includes files ex: `/usr/local/openssl/inc`                   |

## Examples

```ruby
haproxy_install 'package'
```

```ruby
haproxy_install 'source' do
  source_url node['haproxy']['source_url']
  source_checksum node['haproxy']['source_checksum']
  source_version node['haproxy']['source_version']
  use_pcre true
  use_openssl true
  use_zlib true
  use_linux_tproxy true
  use_linux_splice true
end
```
