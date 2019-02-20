[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_cache

Cache describes a shared cache for small objects such as CSS, JS and icon files. Useful for web application acceleration. Available in HAProxy version 1.8 and later, and `max_object_size` in 1.9 and later.

Introduced: v6.3.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `name` | String | name_property | Name of the cache |
| `total_max_size` | Integer | none | Define the size in RAM of the cache in megabytes |
| `max_object_size` |  Integer | none | Define the maximum size of the objects to be cached |
| `max_age` | Integer | none | Define the maximum expiration duration in seconds |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

## Examples

```ruby
haproxy_cache 'test' do
  total_max_size 4
  max_age 60
  max_object_size 1000000
end
```
