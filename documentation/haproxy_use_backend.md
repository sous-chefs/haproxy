[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_use_backend

Switch to a specific backend if/unless an ACL-based condition is matched.

Introduced: v4.2.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `use_backend` | String, Array | none | Switch to a specific backend if/unless an ACL-based condition is matched |
| `section` |  String | none | The section where the acl(s) should be applied | `frontend`, `listen`, `backend`
| `section_name` |  String | none | The name of the specific frontend, listen or backend section |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

## Examples

```ruby
haproxy_use_backend 'gina if gina_host' do
  section 'frontend'
  section_name 'http'
end
```

```ruby
haproxy_use_backend 'use_backends for frontend:http' do
  section 'frontend'
  section_name 'http'
  use_backend [
    'rrhost if rrhost_host',
    'tiles_public if tile_host',
  ]
end
```
