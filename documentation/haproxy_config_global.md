[Back To Resource List](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_config_global

Parameters in the "global" section are process-wide and often OS-specific.

They are generally set once for all and do not need being changed once correct.

Introduced: v4.0.0

## Actions

* `:create`

## Properties

This resource also uses the following partial resources:

* [_config_file](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_config_file.md)
* [_extra_options](https://github.com/sous-chefs/haproxy/tree/master/documentation/partial_extra_options.md)

| Name            | Type                  | Default                                                                                       | Description                                                                                        | Allowed Values   |
| --------------- | --------------------- | --------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | ---------------- |
| `pidfile`       | String                | `/var/run/haproxy.pid`                                                                        | Writes PIDs of all daemons into file `<pidfile>`                                                   |
| `log`           | String, Array         | `/dev/log syslog info`                                                                        | Adds a global syslog server                                                                        |
| `daemon`        | TrueClass, FalseClass | `true`                                                                                        | Makes the process fork into background                                                             |
| `debug_option`  | String                | `quiet`                                                                                       | Sets the debugging mode                                                                            | `quiet`, `debug` |
| `stats`         | Hash                  | `{socket: "/var/run/haproxy.sock user #{haproxy_user} group #{haproxy_group}",timeout: '2m'}` | Enable stats with various options                                                                  |
| `maxconn`       | Integer               | `4096`                                                                                        | Sets the maximum per-process number of concurrent connections                                      |
| `chroot`        | String                | None                                                                                          | Changes current directory to `<jail dir>` and performs a chroot() there before dropping privileges |
| `log_tag`       | String                | `haproxy`                                                                                     | Specifies the log tag to use for all outgoing logs                                                 |
| `tuning`        | Hash                  | None                                                                                          | A hash of `tune.<options>`                                                                         |
| `extra_options` | Hash                  | None                                                                                          | Used for setting any HAProxy directives                                                            |

## Examples

```ruby
haproxy_config_global '' do
  chroot '/var/lib/haproxy'
  daemon true
  maxconn 256
  log '/dev/log local0'
  log_tag 'WARDEN'
  pidfile '/var/run/haproxy.pid'
  stats socket: '/var/lib/haproxy/stats level admin'
  tuning 'bufsize' => '262144'
end
```

```ruby
haproxy_config_global 'global' do
  daemon false
  maxconn 4097
  chroot '/var/lib/haproxy'
  stats socket: '/var/lib/haproxy/haproxy.stat mode 600 level admin',
        timeout: '2m'
end
```
