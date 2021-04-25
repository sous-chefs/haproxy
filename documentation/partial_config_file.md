[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# Partial Resource - _config_file

Provides properties to control the generation of the HAProxy config file.

Introduced: v11.0.0

## Properties

| Name               | Type   | Default                    | Description                                                 | Allowed Values  |
| ------------------ | ------ | -------------------------- | ----------------------------------------------------------- | --------------- |
| `user`             | String | `haproxy`                  | Set to override haproxy user, defaults to haproxy           |
| `group`            | String | `haproxy`                  | Set to override haproxy group, defaults to haproxy          |
| `config_dir`       | String | `/etc/haproxy`             | The directory where the HAProxy configuration resides       | Valid directory |
| `config_dir_mode`  | String | `0750`                     | Set to override haproxy config dir mode, defaults to 0750   |
| `config_file`      | String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file                              | Valid file name |
| `config_file_mode` | String | `0640`                     | Set to override haproxy config file mode, defaults to 0640  |
| `cookbook`         | String | `haproxy`                  | Template source cookbook for the haproxy configuration file |
| `template`         | String | `haproxy.cfg.erb`          | Template source file for the haproxy configuration file     |
