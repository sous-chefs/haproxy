[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_peer

Peer describes a peers resource for haproxy to propagate entries of any data-types in stick-tables between several haproxy instances over TCP connections in a multi-master fashion.

Most of the properties are available only when using HAProxy version >= 2.0. To set properties for versions < 2.0, use the `extra_options` hash. See examples below.

Introduced: v8.0.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)
* [_extra_options](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_extra_options.md)

| Name             | Type         | Default | Description                                                             | Allowed Values             |
| ---------------- | ------------ | ------- | ----------------------------------------------------------------------- | -------------------------- |
| `bind`           | String, Hash | None    | String - sets as given. Hash joins with a space. HAProxy version >= 2.0 |
| `state`          | String, nil  | nil     | Set the state of the peers                                              | `enabled`, `disabled`, nil |
| `server`         | Array        | None    | Servers in the peer                                                     |
| `default_bind`   | String       | None    | Defines the binding parameters for the local peer, excepted its address |
| `default_server` | String       | None    | Change default options for a server                                     |
| `table`          | Array        | None    | Configure a stickiness table                                            |

## Examples

HAProxy version >= 2.0

```ruby
haproxy_peer 'mypeers' do
  bind '0.0.0.0:1336'
  default_server 'ssl verify None'
  server ['hostA 127.0.0.10:10000']
end
```

```ruby
haproxy_peer 'mypeers' do
  bind('0.0.0.0:1336' => 'ssl crt mycerts/pem')
  default_server 'ssl verify None'
  server ['hostA 127.0.0.10:10000', 'hostB']
end
```

HAProxy version < 2.0

```ruby
haproxy_peer 'mypeers' do
  extra_options(
    'peer' => ['haproxy1 192.168.0.1:1024','haproxy2 192.168.0.2:1024']
    )
end
```
