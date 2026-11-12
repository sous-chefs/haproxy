# haproxy_userlist

[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

Control access to frontend/backend/listen sections or to http stats by allowing only authenticated and authorized users.

Introduced: v4.1.0

## Actions

* `:create`
* `:delete` removes the entire named userlist from the generated configuration.
  Deleting an absent userlist does nothing. Other userlists remain unchanged.

## Properties

This resource also uses the following partial resources:

* [_config_file](partial_config_file.md)

| Name    | Type | Default | Description                                      | Allowed Values |
| ------- | ---- | ------- | ------------------------------------------------ | -------------- |
| `group` | Hash | None    | Adds group `<groupname>` to the current userlist |                |
| `user`  | Hash | None    | Adds user `<username>` to the current userlist   |                |

Use `config_owner` and `config_group` to set filesystem ownership. Both default
to `haproxy`; the `user` and `group` hashes only define authentication entries.

## Examples

```ruby
haproxy_userlist 'mylist' do
  group 'G1' => 'users tiger,scott',
        'G2' => 'users xdb,scott'
  user  'tiger' => 'password $6$k6y3o.eP$JlKBx9za9667qe4(...)xHSwRv6J.C0/D7cV91',
        'scott' => 'insecure-password elgato',
        'xdb' => 'insecure-password hello'
end
```

```ruby
haproxy_userlist 'mylist' do
  action :delete
end
```
