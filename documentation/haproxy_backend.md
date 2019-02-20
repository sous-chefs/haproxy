[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_backend

Backend describes a set of servers to which the proxy will connect to forward incoming connections.

Introduced: v4.0.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `mode` | String | none | Set the running mode or protocol of the instance | `http`, `tcp`
| `server` | Array | none | Servers the backend routes to |
| `tcp_request` |  Array | none | HAProxy `tcp-request` settings |
| `reqrep` | String, Array | none | Replace a regular expression with a string in an HTTP request line |
| `reqirep` | String, Array | none | `reqrep` ignoring case |
| `acl` | Array | none | Access control list items | Allowed HAProxy acl values
| `option` |  Array | none | Array of HAProxy `option` directives |
| `extra_options` |  Hash | none | Used for setting any HAProxy directives |
| `hash_type` |  String | none | Specify a method to use for mapping hashes to servers | `consistent`, `map-based`
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

## Examples

```ruby
haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
end
```

```ruby
haproxy_backend 'tiles_public' do
  server ['tile0 10.0.0.10:80 check weight 1 maxconn 100',
          'tile1 10.0.0.10:80 check weight 1 maxconn 100']
  tcp_request ['content track-sc2 src',
               'content reject if conn_rate_abuse mark_as_abuser']
  option %w(httplog dontlognull forwardfor)
  acl ['conn_rate_abuse sc2_conn_rate gt 3000',
       'data_rate_abuse sc2_bytes_out_rate gt 20000000',
       'mark_as_abuser sc1_inc_gpc0 gt 0',
     ]
  extra_options(
    'stick-table' => 'type ip size 200k expire 2m store conn_rate(60s),bytes_out_rate(60s)',
    'http-request' => 'set-header X-Public-User yes'
  )
end
```
