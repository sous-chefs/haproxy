[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_service

Configures HAProxy as a systemd service.
To reload HAProxy service add a subscribes option to the resource block. See example below. To reload the HAProxy service add a subscribes option to the resource block. See example below.

Introduced: v4.0.0

## Actions

* `:create`
* `:delete`
* `:start`
* `:stop`
* `:restart`
* `:reload`
* `:enable`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)

| Name                      | Type         | Default                  | Description                                                      | Allowed Values |
| ------------------------- | ------------ | ------------------------ | ---------------------------------------------------------------- | -------------- |
| `bin_prefix`              | String       | `/usr`                   | Bin location of the haproxy binary, defaults to /usr             |
| `service_name`            | String       | `haproxy`                |                                                                  |
| `systemd_unit_content`    | String, Hash | See the service resource | A string or hash that contains a systemd unit file definition    |
| `config_test`             | true, false  | `true`                   | Perform configuration file test before performing service action |
| `config_test_fail_action` | Symbol       | `:raise`                 | Action to perform upon configuration test failure                |

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
