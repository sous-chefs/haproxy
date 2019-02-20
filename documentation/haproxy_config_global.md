[back to resource list](https://github.com/sous-chefs/haproxy#resources)

---

# haproxy_config_global

Parameters in the "global" section are process-wide and often OS-specific.

They are generally set once for all and do not need being changed once correct.

Introduced: v4.0.0

## Actions

`:create`

## Properties

| Name | Type |  Default | Description | Allowed Values
| -- | -- | -- | -- | -- |
| `haproxy_user` | String | `haproxy` | Similar to "uid" but uses the UID of user name `<user name>` from /etc/passwd |
| `haproxy_group` | String | `haproxy` | Similar to "gid" but uses the GID of group name `<group name>` from /etc/group |
| `pidfile` | String | `/var/run/haproxy.pid` | Writes PIDs of all daemons into file `<pidfile>` |
| `log` | String, Array | `/dev/log syslog info` | Adds a global syslog server |
| `daemon` | TrueClass, FalseClass | `true` | Makes the process fork into background |
| `debug_option` | String | `quiet` | Sets the debugging mode | `quiet`, `debug`
| `stats` | Hash | `{socket: "/var/run/haproxy.sock user #{haproxy_user} group #{haproxy_group}",timeout: '2m'}` | Enable stats with various options |
| `maxconn` | Integer | `4096` | Sets the maximum per-process number of concurrent connections |
| `chroot` | String | none | Changes current directory to `<jail dir>` and performs a chroot() there before dropping privileges |
| `log_tag` | String | `haproxy` | Specifies the log tag to use for all outgoing logs |
| `tuning` | Hash | none | A hash of `tune.<options>` |
| `extra_options` |  Hash | none | Used for setting any HAProxy directives |
| `config_cookbook` | String | `haproxy` | Used to configure loading config from another cookbook |
| `config_dir` |  String | `/etc/haproxy` | The directory where the HAProxy configuration resides | Valid directory
| `config_file` |  String | `/etc/haproxy/haproxy.cfg` | The HAProxy configuration file | Valid file name

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
