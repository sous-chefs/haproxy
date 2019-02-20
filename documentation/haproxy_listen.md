[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_listen

Listen defines a complete proxy with its frontend and backend parts combined in one section.

It is generally useful for TCP-only traffic.

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
| `http_request` | Array | none | Switch to a specific backend if/unless an ACL-based condition is matched |
| `http_response` | Array | none | Switch to a specific backend if/unless an ACL-based condition is matched |
| `acl` | Array | none | Access control list items | Allowed HAProxy acl values
| `server` | Array | none | Servers the listen section routes to |
| `stats` | Hash | none | Enable stats with various options |
| `hash_type` |  String | none | Specify a method to use for mapping hashes to servers | `consistent`, `map-based`
| `extra_options` |  Hash | none | Used for setting any HAProxy directives |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

## Examples

```ruby
haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats uri: '/',
        realm: 'Haproxy-Statistics',
        auth: 'user:pwd'
  http_request 'add-header X-Proto http'
  http_response 'set-header Expires %[date(3600),http_date]'
  default_backend 'servers'
  extra_options('bind-process' => 'odd')
  server ['admin0 10.0.0.10:80 check weight 1 maxconn 100',
          'admin1 10.0.0.10:80 check weight 1 maxconn 100']
end
```
