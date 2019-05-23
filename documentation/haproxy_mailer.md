[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_mailer

Mailer describes a mailers resource for sending email alerts on server state changes.

Introduced: v8.0.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `mailer` | String, Array | none | Defines a mailer inside a mailers section |
| `timeout` | String | none | Defines the time available for a mail/connection to be made and send to the mail-server |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name
| `config_cookbook` |  String | `haproxy` | Used to configure loading config from another cookbook

## Examples

```ruby
haproxy_mailer 'mymailer' do
  mailer ['smtp1 192.168.0.1:587', 'smtp2 192.168.0.2:587']
  timeout '20s'
end

haproxy_backend 'admin' do
  server ['admin0 10.0.0.10:80 check weight 1 maxconn 100']
  extra_options('email-alert' => [ 'mailers mymailers',
                                    'from test1@horms.org',
                                    'to test2@horms.org' ])
end
```
