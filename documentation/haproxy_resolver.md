[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_resolver

Configuration related to name resolution in HAProxy. There can be as many as resolver sections as needed.

Each section can contain many name servers.

Introduced: v4.5.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `nameserver` | Array | none | DNS server description |
| `extra_options` | Hash | none | Used for setting any HAProxy directives |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

## Examples

```ruby
haproxy_resolver 'dns' do
  nameserver ['google 8.8.8.8:53']
  extra_options('resolve_retries' => 30,
                'timeout' => 'retry 1s')
  notifies :restart, 'haproxy_service[haproxy]', :delayed
end
```
