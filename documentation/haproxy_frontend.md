[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_frontend

Frontend describes a set of listening sockets accepting client connections.

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
| `bind`            | String, Hash  | `0.0.0.0:80` | String - sets as given. Hash joins with a space                          |
| `mode`            | String        | None         | Set the running mode or protocol of the instance                         | `http`, `tcp`              |
| `maxconn`         | Integer       | None         | Sets the maximum per-process number of concurrent connections            |
| `reqrep`          | String, Array | None         | Replace a regular expression with a string in an HTTP request line       |
| `reqirep`         | String, Array | None         | `reqrep` ignoring case                                                   |
| `default_backend` | String        | None         | Specify the backend to use when no "use_backend" rule has been matched   |
| `use_backend`     | Array         | None         | Switch to a specific backend if/unless an ACL-based condition is matched |
| `acl`             | Array         | None         | Access control list items                                                | Allowed HAProxy acl values |
| `option`          | Array         | None         | Array of HAProxy `option` directives                                     |
| `stats`           | Hash          | None         | Enable stats with various options                                        |

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
