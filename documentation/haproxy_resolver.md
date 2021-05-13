[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_resolver

Configuration related to name resolution in HAProxy. There can be as many as resolver sections as needed.

Each section can contain many name servers.

Introduced: v4.5.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)
* [_extra_options](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_extra_options.md)

| Name            | Type   | Default                    | Description                                           | Allowed Values  |
| --------------- | ------ | -------------------------- | ----------------------------------------------------- | --------------- |
| `nameserver`    | Array  | None                       | DNS server description                                |

## Examples

```ruby
haproxy_resolver 'dns' do
  nameserver ['google 8.8.8.8:53']
  extra_options('resolve_retries' => 30,
                'timeout' => 'retry 1s')
  notifies :restart, 'haproxy_service[haproxy]', :delayed
end
```
