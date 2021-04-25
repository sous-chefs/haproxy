[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_acl

Access Control Lists creates a new ACL `<aclname>` or completes an existing one with new tests.

The actions generally consist in blocking a request, selecting a backend, or adding a header.

Introduced: v4.2.0

## Actions

* `:create`
* `:delete`

## Properties

| Name           | Type          | Default                    | Description                                                  | Allowed Values                  |
| -------------- | ------------- | -------------------------- | ------------------------------------------------------------ | ------------------------------- |
| `acl`          | String, Array | None                       | The access control list items                                | Allowed HAProxy acl values      |
| `section`      | String        | None                       | The section where the acl(s) should be applied               | `frontend`, `listen`, `backend` |
| `section_name` | String        | None                       | The name of the specific frontend, listen or backend section |

## Examples

```ruby
haproxy_acl 'gina_host hdr(host) -i foo.bar.com' do
  section 'frontend'
  section_name 'http'
end
```

```ruby
haproxy_acl 'acls for frontend:http' do
  section 'frontend'
  section_name 'http'
  acl [
    'rrhost_host hdr(host) -i dave.foo.bar.com foo.foo.com',
    'tile_host hdr(host) -i dough.foo.bar.com',
  ]
end
```

```ruby
haproxy_acl 'acls for listen' do
  section 'listen'
  section_name 'admin'
  acl ['network_allowed src 127.0.0.1']
end
```
