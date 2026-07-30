# haproxy_install

[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

Install HAProxy from a package or source archive.

Introduced: v4.0.0

## Actions

* `:install`
* `:remove`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)

<!-- markdownlint-disable MD060 -->

| Name                 | Type    | Default                             | Description                                                                    | Allowed Values      |
| -------------------- | ------- | ----------------------------------- | ------------------------------------------------------------------------------ | ------------------- |
| `install_type`       | String  | Resource name                       | Set the installation type                                                      | `package`, `source` |
| `bin_prefix`         | String  | `/usr`                              | Set the source compile prefix                                                  |                     |
| `sensitive`          | Boolean | `true`                              | Ensure that sensitive resource data is not logged by Chef Infra Client         |                     |
| `user`               | String  | `haproxy`                           | User that owns HAProxy-managed files                                            |                     |
| `group`              | String  | `haproxy`                           | Group that owns HAProxy-managed files                                           |                     |
| `package_name`       | String  | `haproxy`                           | Package to install or remove                                                    |                     |
| `package_version`    | String  | None                                | Optional package version                                                        |                     |
| `enable_ius_repo`    | Boolean | `false`                             | Enable the IUS repository on supported RHEL-family systems                      |                     |
| `enable_epel_repo`   | Boolean | `true`                              | Enable the EPEL repository on RHEL-family and Amazon systems                    |                     |
| `source_version`     | String  | `3.2.14`                            | HAProxy version to compile                                                      |                     |
| `source_url`         | String  | Derived from `source_version`       | HTTPS URL for the HAProxy source archive                                        |                     |
| `source_checksum`    | String  | Checksum for the default archive    | SHA-256 checksum used to verify the source archive                              |                     |
| `source_target_cpu`  | String  | Node kernel machine                 | CPU target passed to `make`                                                     |                     |
| `source_target_arch` | String  | None                                | Optional architecture passed to `make`                                          |                     |
| `source_target_os`   | String  | Derived from platform and version   | HAProxy build target passed to `make`                                            |                     |
| `use_libcrypt`       | Boolean | `true`                              | Include libcrypt support                                                        | `true`, `false`     |
| `use_pcre`           | Boolean | `true`                              | Enable PCRE support, selecting PCRE or PCRE2 for the platform                   | `true`, `false`     |
| `use_openssl`        | Boolean | `true`                              | Include OpenSSL support                                                         | `true`, `false`     |
| `use_zlib`           | Boolean | `true`                              | Include zlib support                                                            | `true`, `false`     |
| `use_linux_tproxy`   | Boolean | `true`                              | Include Linux transparent proxy support                                         | `true`, `false`     |
| `use_linux_splice`   | Boolean | `true`                              | Include Linux splice support                                                    | `true`, `false`     |
| `use_promex`         | Boolean | `false`                             | Enable the built-in Prometheus exporter                                         | `true`, `false`     |
| `use_systemd`        | Boolean | HAProxy 1.8 and newer               | Include systemd support when compiling from source                              | `true`, `false`     |
| `use_lua`            | Boolean | `false`                             | Include Lua support                                                             | `true`, `false`     |
| `lua_lib`            | String  | None                                | Path to Lua library files                                                       |                     |
| `lua_inc`            | String  | None                                | Path to Lua include files                                                       |                     |
| `ssl_lib`            | String  | None                                | Path to OpenSSL library files                                                   |                     |
| `ssl_inc`            | String  | None                                | Path to OpenSSL include files                                                   |                     |

<!-- markdownlint-enable MD060 -->

## Examples

Install the platform package:

```ruby
haproxy_install 'package'
```

Compile a pinned source release:

```ruby
haproxy_install 'source' do
  source_version '3.2.14'
  source_url 'https://www.haproxy.org/download/3.2/src/haproxy-3.2.14.tar.gz'
  source_checksum 'b21f50a790aa8cb0cf8dc505f1f8d849799eafe4d31c14b86a34409ccf4ae5e4'
  use_pcre true
  use_openssl true
  use_zlib true
  use_linux_tproxy true
  use_linux_splice true
end
```

Remove a package installation:

```ruby
haproxy_install 'package' do
  action :remove
end
```
