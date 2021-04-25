[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_listen

Listen defines a complete proxy with its frontend and backend parts combined in one section.

It is generally useful for TCP-only traffic.

Introduced: v4.0.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)
* [_extra_options](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_extra_options.md)

| Name              | Type          | Default      | Description                                                              | Allowed Values             |
| ----------------- | ------------- | ------------ | ------------------------------------------------------------------------ | -------------------------- |
| `bind`            | String, Hash  | `0.0.0.0:80` | String - sets as given. Hash - joins with a space                        |
| `mode`            | String        | None         | Set the running mode or protocol of the instance                         | `http`, `tcp`              |
| `maxconn`         | Integer       | None         | Sets the maximum per-process number of concurrent connections            |
| `reqrep`          | String, Array | None         | Replace a regular expression with a string in an HTTP request line       |
| `reqirep`         | String, Array | None         | `reqrep` ignoring case                                                   |
| `default_backend` | String        | None         | Specify the backend to use when no "use_backend" rule has been matched   |
| `use_backend`     | Array         | None         | Switch to a specific backend if/unless an ACL-based condition is matched |
| `http_request`    | Array         | None         | Switch to a specific backend if/unless an ACL-based condition is matched |
| `http_response`   | Array         | None         | Switch to a specific backend if/unless an ACL-based condition is matched |
| `acl`             | Array         | None         | Access control list items                                                | Allowed HAProxy acl values |
| `server`          | Array         | None         | Servers the listen section routes to                                     |
| `stats`           | Hash          | None         | Enable stats with various options                                        |
| `hash_type`       | String        | None         | Specify a method to use for mapping hashes to servers                    | `consistent`, `map-based`  |

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
