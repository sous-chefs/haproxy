# Partial Resource - _config_file

[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

Provides properties to control the generation of the HAProxy config file.

Introduced: v11.0.0

## Properties

| Name               | Type   | Default                    | Description                                                 | Allowed Values  |
| ------------------ | ------ | -------------------------- | ----------------------------------------------------------- | --------------- |
| `user`             | String | `haproxy`                  | Set to override haproxy user, defaults to haproxy           | --------------- |
| `group`            | String | `haproxy`                  | Set to override haproxy group, defaults to haproxy          | --------------- |
| `config_owner`     | String | Value of `user`            | Owner of the configuration directory and file               | --------------- |
| `config_group`     | String | Value of `group`           | Group of the configuration directory and file               | --------------- |
| `config_dir`       | String | `/etc/haproxy`             | The directory where the HAProxy configuration resides       | Valid directory |
| `config_dir_mode`  | String | `0750`                     | Set to override haproxy config dir mode, defaults to 0750   | --------------- |
| `config_file`      | String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file                              | Valid file name |
| `config_file_mode` | String | `0640`                     | Set to override haproxy config file mode, defaults to 0640  | --------------- |
| `cookbook`         | String | `haproxy`                  | Template source cookbook for the haproxy configuration file | --------------- |
| `template`         | String | `haproxy.cfg.erb`          | Template source file for the haproxy configuration file     | --------------- |

The first configuration resource for a `config_file` sets its filesystem
ownership. Declare matching ownership properties on resources sharing that
file. For `haproxy_userlist`, `user` and `group` describe authentication entries;
its `config_owner` and `config_group` both default to `haproxy` independently.
