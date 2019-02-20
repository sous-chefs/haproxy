[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_config_defaults

Defaults sets default parameters for all other sections following its declaration. Those default parameters are reset by the next "defaults" section.

Introduced: v4.0.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `timeout` | Hash | `{ client: '10s', server: '10s', connect: '10s' }` | Default HAProxy timeout values |
| `log` | String | `global` | Enable per-instance logging of events and traffic |
| `mode` |  String | `http` | Set the running mode or protocol of the instance | `http`, `tcp`
| `balance` | String | `roundrobin` | Define the load balancing algorithm to be used in a backend | `roundrobin static-rr`, `leastconn`, `first`, `source`, `uri`, `url_param`, `header`, `rdp-cookie`
| `stats` | Hash | `{ 'uri' => '/haproxy-status' }` | Enable HAProxy statistics |
| `maxconn` | Integer | none | Sets the maximum per-process number of concurrent connections |
| `haproxy_retries` | Integer | none | Set the number of retries to perform on a server after a connection failure |
| `option` |  Array | `['httplog', 'dontlognull', 'redispatch', 'tcplog']` | Array of HAProxy `option` directives |
| `extra_options` |  Hash | none | Used for setting any HAProxy directives |
| `hash_type` |  String, nil | none | Specify a method to use for mapping hashes to servers | `consistent`, `map-based`, `nil`
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

## Examples

```ruby
haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5000ms',
          client: '5000ms',
          server: '5000ms'
  haproxy_retries 5
end
```

```ruby
haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5s',
          client: '50s',
          server: '50s'
  log 'global'
  retries 3
end
```
