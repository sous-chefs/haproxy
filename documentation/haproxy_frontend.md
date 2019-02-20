[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_frontend

Frontend describes a set of listening sockets accepting client connections.

Introduced: v4.0.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `bind` | String, Hash | `0.0.0.0:80` | |
| `mode` | String | none | Set the running mode or protocol of the instance | `http`, `tcp`
| `maxconn` | Integer | none | Sets the maximum per-process number of concurrent connections |
| `reqrep` | String, Array | none | Replace a regular expression with a string in an HTTP request line |
| `reqirep` | String, Array | none | `reqrep` ignoring case |
| `default_backend` | String | none | Specify the backend to use when no "use_backend" rule has been matched |
| `use_backend` | Array | none | Switch to a specific backend if/unless an ACL-based condition is matched |
| `acl` | Array | none | Access control list items | Allowed HAProxy acl values
| `option` |  Array | none | Array of HAProxy `option` directives |
| `stats` | Hash | none | Enable stats with various options |
| `extra_options` |  Hash | none | Used for setting any HAProxy directives |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

## Examples

```ruby
haproxy_frontend 'http-in' do
  bind '*:80'
  default_backend 'servers'
end

haproxy_frontend 'tcp-in' do
  mode 'tcp'
  bind '*:3307'
  default_backend 'tcp-servers'
end
```
