[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_cache

Cache describes a shared cache for small objects such as CSS, JS and icon files. Useful for web application acceleration. Available in HAProxy version 1.8 and later, and `max_object_size` in 1.9 and later.

Introduced: v6.3.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)

| Name              | Type    | Default       | Description                                         | Allowed Values |
| ----------------- | ------- | ------------- | --------------------------------------------------- | -------------- |
| `cache_name`      | String  | name_property | Name of the cache                                   |
| `total_max_size`  | Integer | None          | Define the size in RAM of the cache in megabytes    |
| `max_object_size` | Integer | None          | Define the maximum size of the objects to be cached |
| `max_age`         | Integer | None          | Define the maximum expiration duration in seconds   |

## Examples

```ruby
haproxy_cache 'test' do
  total_max_size 4
  max_age 60
  max_object_size 1000000
end
```
