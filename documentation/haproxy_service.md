[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_service

Installs HAProxy as a systemd or sysvinit service.
To reload HAProxy service add a subscribes option to the resource block. See example below.

Introduced: v4.0.0

## Actions

- `:create`
- `:start`
- `:stop`
- `:restart`
- `:reload`
- `:enable`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `bin_prefix` | String | `/usr` | Set the source compile prefix |
| `haproxy_user` | String | `haproxy` | Owner of the service |
| `haproxy_group` | String | `haproxy` | Owner group of the service |
| `service_name` | String | `haproxy` |  |
| `use_systemd` | true, false | `node['init_package'] == 'systemd'` | Evalues whether to use systemd based on the nodes init package |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

## Examples

```ruby
haproxy_service 'haproxy'
```

```ruby
haproxy_service 'haproxy' do
  subscribes :reload, 'template[/etc/haproxy/haproxy.cfg]', :delayed
end
```

```ruby
haproxy_service 'haproxy' do
  subscribes :reload, ['template[/etc/haproxy/haproxy.cfg]', 'file[/etc/haproxy/ssl/haproxy.pem]'], :delayed
end
```
