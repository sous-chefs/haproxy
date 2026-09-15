# haproxy_use_backend

[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

Switch to a specific backend if/unless an ACL-based condition is matched.

Introduced: v4.2.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](partial_config_file.md)

| Name           | Type          | Default | Description                                                              | Allowed Values       |
| -------------- | ------------- | ------- | ------------------------------------------------------------------------ | -------------------- |
| `use_backend`  | String, Array | None    | Switch to a specific backend if/unless an ACL-based condition is matched |                      |
| `section`      | String        | None    | The section where the routing rule should be applied                     | `frontend`, `listen` |
| `section_name` | String        | None    | The name of the specific frontend or listen section                      |                      |

HAProxy permits `use_backend` in frontend and listen sections only. A backend
section is rejected during resource validation. See the
[HAProxy directive reference](https://docs.haproxy.org/3.2/configuration.html#4.2-use_backend).

Deleting an absent routing rule does nothing and does not create a section or
configuration file. Deleting an existing rule preserves the section's other rules.

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
