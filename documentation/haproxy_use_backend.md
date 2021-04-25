[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_use_backend

Switch to a specific backend if/unless an ACL-based condition is matched.

Introduced: v4.2.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)

| Name           | Type          | Default                    | Description                                                              | Allowed Values                  |
| -------------- | ------------- | -------------------------- | ------------------------------------------------------------------------ | ------------------------------- |
| `use_backend`  | String, Array | None                       | Switch to a specific backend if/unless an ACL-based condition is matched |
| `section`      | String        | None                       | The section where the acl(s) should be applied                           | `frontend`, `listen`, `backend` |
| `section_name` | String        | None                       | The name of the specific frontend, listen or backend section             |

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
