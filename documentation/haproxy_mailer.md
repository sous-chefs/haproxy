[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_mailer

Mailer describes a mailers resource for sending email alerts on server state changes.

Introduced: v8.0.0

## Actions

* `:create`
* `:delete`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)

| Name      | Type          | Default | Description                                                                             | Allowed Values |
| --------- | ------------- | ------- | --------------------------------------------------------------------------------------- | -------------- |
| `mailer`  | String, Array | None    | Defines a mailer inside a mailers section                                               |
| `timeout` | String        | None    | Defines the time available for a mail/connection to be made and send to the mail-server |

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
