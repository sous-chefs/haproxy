[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_backend

Backend describes a set of servers to which the proxy will connect to forward incoming connections.

Introduced: v4.0.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)
* [_extra_options](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_extra_options.md)

| Name            | Type          | Default | Description                                                        | Allowed Values             |
| --------------- | ------------- | ------- | ------------------------------------------------------------------ | -------------------------- |
| `mode`          | String        | None    | Set the running mode or protocol of the instance                   | `http`, `tcp`              |
| `server`        | String, Array | None    | Servers the backend routes to                                      |
| `tcp_request`   | String, Array | None    | HAProxy `tcp-request` settings                                     |
| `reqrep`        | String, Array | None    | Replace a regular expression with a string in an HTTP request line |
| `reqirep`       | String, Array | None    | `reqrep` ignoring case                                             |
| `acl`           | Array         | None    | Access control list items                                          | Allowed HAProxy acl values |
| `option`        | Array         | None    | Array of HAProxy `option` directives                               |
| `extra_options` | Hash          | None    | Used for setting any HAProxy directives                            |
| `hash_type`     | String        | None    | Specify a method to use for mapping hashes to servers              | `consistent`, `map-based`  |

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
