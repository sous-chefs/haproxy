[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_service

Configures HAProxy as a systemd service.
To reload HAProxy service add a subscribes option to the resource block. See example below. To reload the HAProxy service add a subscribes option to the resource block. See example below.


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
| `service_name` | String | `haproxy` |  |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name
| `systemd_unit` |  String, Hash | See the service resource | A string or hash that contains a systemd unit file definition |

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
