[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_fastcgi

Fastcgi describes a FastCGI applications resource for haproxy to send HTTP requests to Responder FastCGI applications

Resource available when using HAProxy version >= 2.1.

Introduced: v8.2.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `fastcgi` | String | none | Name property - sets the fcgi-app name |
| `docroot` | String | none | Define the document root on the remote host |
| `index` | String | none | Define the script name that will be appended after an URI that ends with a slash |
| `log_stderr` | String | none | Enable logging of STDERR messages reported by the FastCGI application |
| `option` |  Array | none | Array of HAProxy `option` directives |
| `extra_options` | Hash | none | Used for setting any HAProxy directives |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

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
