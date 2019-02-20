[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_userlist

Control access to frontend/backend/listen sections or to http stats by allowing only authenticated and authorized users.

Introduced: v4.1.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `group` | Hash | none | Adds group `<groupname>` to the current userlist |
| `user` |  Hash | none | Adds user `<username>` to the current userlist |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

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
