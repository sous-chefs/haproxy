[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_fastcgi

Fastcgi describes a FastCGI applications resource for haproxy to send HTTP requests to Responder FastCGI applications

Resource available when using HAProxy version >= 2.1.

Introduced: v8.2.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)
* [_extra_options](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_extra_options.md)

| Name            | Type   | Default                    | Description                                                                      | Allowed Values  |
| --------------- | ------ | -------------------------- | -------------------------------------------------------------------------------- | --------------- |
| `fastcgi`       | String | None                       | Name property - sets the fcgi-app name                                           |
| `docroot`       | String | None                       | Define the document root on the remote host                                      |
| `index`         | String | None                       | Define the script name that will be appended after an URI that ends with a slash |
| `log_stderr`    | String | None                       | Enable logging of STDERR messages reported by the FastCGI application            |
| `option`        | Array  | None                       | Array of HAProxy `option` directives                                             |

## Examples

```ruby
haproxy_fastcgi 'php-fpm' do
  log_stderr 'global'
  docroot '/var/www/my-app'
  index 'index.php'
  option ['keep-conn']
  extra_options('path-info' => '^(/.+\.php)(/.*)?$')
end
```

Generates

```
fcgi-app php-fpm
  docroot /var/www/my-app
  index index.php
  log-stderr global
  option keep-conn
  path-info ^(/.+\.php)(/.*)?$
```
