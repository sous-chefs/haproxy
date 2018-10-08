# haproxy Cookbook

[![CircleCI](https://circleci.com/gh/sous-chefs/haproxy/tree/master.svg?style=svg)](https://circleci.com/gh/sous-chefs/haproxy/tree/master) [![Cookbook Version](https://img.shields.io/cookbook/v/haproxy.svg)](https://supermarket.chef.io/cookbooks/haproxy)

Installs and configures haproxy.

## Requirements

- Chef 13+

### Platforms

- Ubuntu Ubuntu 16.04+
- RedHat 6+ family
- Debian 8+

### Examples

Please check for working examples in [TEST](./test/fixtures/cookbooks/test/)

## Common Resource Features

HAProxy has many configurable options available, this cookbook makes the most popular options available as resource properties.

If you wish to use a HAProxy property that is not listed the `extra_options` hash is available to take in any number of additional values.

For example, the ability to disable listeners is not provided out of the box. Further examples can be found in either `test/fixtures/recipes` or `spec/test/recipes`. If you have questions on how this works or would like to add more examples so it is easier to understand, please come talk to us on the [Chef Community Slack](http://community-slack.chef.io/) on the #sous-chefs channel.

```ruby
haproxy_listen 'disabled' do
  bind '0.0.0.0:1337'
  mode 'http'
  extra_options('disabled': '')
end
```

## Resources

### haproxy_acl

Access Control Lists creates a new ACL <aclname> or completes an existing one with new tests.

The actions generally consist in blocking a request, selecting a backend, or adding a header.

Introduced: v4.2.0

#### Actions

- `:create`

#### Properties

- `acl` -  (is: [String, Array])
- `section` -  (is: String)
- `section_name` -  (is: String)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

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
### haproxy_backend

Backend describes a set of servers to which the proxy will connect to forward incoming connections.

Introduced: v4.0.0

#### Actions

- `:create`

#### Properties

- `mode` -  (is: String)
- `server` -  (is: Array)
- `tcp_request` -  (is: Array)
- `acl` -  (is: Array)
- `option` -  (is: Array)
- `extra_options` -  (is: Hash)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

```ruby
haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
end
```
```ruby
haproxy_backend 'tiles_public' do
  server ['tile0 10.0.0.10:80 check weight 1 maxconn 100',
          'tile1 10.0.0.10:80 check weight 1 maxconn 100']
  tcp_request ['content track-sc2 src',
               'content reject if conn_rate_abuse mark_as_abuser']
  option %w(httplog dontlognull forwardfor)
  acl ['conn_rate_abuse sc2_conn_rate gt 3000',
       'data_rate_abuse sc2_bytes_out_rate gt 20000000',
       'mark_as_abuser sc1_inc_gpc0 gt 0',
     ]
  extra_options(
    'stick-table' => 'type ip size 200k expire 2m store conn_rate(60s),bytes_out_rate(60s)',
    'http-request' => 'set-header X-Public-User yes'
  )
end
```
### haproxy_config_defaults

Defaults sets default parameters for all other sections following its declaration. Those default parameters are reset by the next "defaults" section.

Introduced: v4.0.0

#### Actions

- `:create`

#### Properties

- `timeout` -  (is: Hash)
- `log` -  (is: String)
- `mode` -  (is: String)
- `balance` -  (is: )
- `option` -  (is: Array)
- `stats` -  (is: Hash)
- `maxconn` -  (is: Integer)
- `extra_options` -  (is: Hash)
- `haproxy_retries` -  (is: Integer)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

```ruby
haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5000ms',
          client: '5000ms',
          server: '5000ms'
  haproxy_retries 5
end
```
```ruby
haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5s',
          client: '50s',
          server: '50s'
  log 'global'
  retries 3
end
```
### haproxy_config_global

Parameters in the "global" section are process-wide and often OS-specific.

They are generally set once for all and do not need being changed once correct.

Introduced: v4.0.0

#### Actions

- `:create`

#### Properties

- `haproxy_user` -  (is: String)
- `haproxy_group` -  (is: String)
- `pidfile` -  (is: String)
- `log` -  (is: [String, Array])
- `daemon` -  (is: [TrueClass, FalseClass])
- `debug_option` -  (is: String)
- `stats` -  (is: Hash)
- `maxconn` -  (is: Integer)
- `config_cookbook` -  (is: String)
- `chroot` -  (is: String)
- `log_tag` -  (is: String)
- `tuning` -  (is: Hash)
- `extra_options` -  (is: Hash)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

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
### haproxy_frontend

Frontend describes a set of listening sockets accepting client connections.

Introduced: v4.0.0

#### Actions

- `:create`

#### Properties

- `bind` -  (is: [String, Hash])
- `mode` -  (is: String)
- `maxconn` -  (is: Integer)
- `default_backend` -  (is: String)
- `use_backend` -  (is: Array)
- `acl` -  (is: Array)
- `option` -  (is: Array)
- `stats` -  (is: Hash)
- `extra_options` -  (is: Hash)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

```ruby
haproxy_frontend 'http-in' do
  bind '*:80'
  default_backend 'servers'
end

haproxy_frontend 'tcp-in' do
  mode 'tcp'
  bind '*:3307'
  default_backend 'tcp-servers'
end
```
### haproxy_install

Install HAProxy from package or source.

Introduced: v4.0.0

#### Actions

- `:create`

#### Properties

- `install_type` -  (is: String)
- `conf_template_source` -  (is: String)
- `conf_cookbook` -  (is: String)
- `conf_file_mode` -  (is: String)
- `bin_prefix` -  (is: String)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)
- `haproxy_user` -  (is: String)
- `haproxy_group` -  (is: String)
- `install_only` -  (is: [true, false])
- `service_name` -  (is: String)
- `use_systemd` -  (is: String)
- `package_name` -  (is: String)
- `package_version` -  (is: [String, nil])
- `source_version` -  (is: String)
- `source_url` -  (is: String)
- `source_checksum` -  (is: String)
- `source_target_cpu` -  (is: [String, nil])
- `source_target_arch` -  (is: [String, nil])
- `source_target_os` -  (is: String)
- `use_libcrypt` -  (is: String)
- `use_pcre` -  (is: String)
- `use_openssl` -  (is: String)
- `use_zlib` -  (is: String)
- `use_linux_tproxy` -  (is: String)
- `use_linux_splice` -  (is: String)

#### Examples

```ruby
haproxy_install 'package'
```
```ruby
haproxy_install 'source' do
  source_url node['haproxy']['source_url']
  source_checksum node['haproxy']['source_checksum']
  source_version node['haproxy']['source_version']
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  use_linux_tproxy '1'
  use_linux_splice '1'
end
```
### haproxy_listen

Listen defines a complete proxy with its frontend and backend parts combined in one section.

It is generally useful for TCP-only traffic.

Introduced: v4.0.0

#### Actions

- `:create`

#### Properties

- `mode` -  (is: String)
- `bind` -  (is: [String, Hash])
- `maxconn` -  (is: Integer)
- `stats` -  (is: Hash)
- `http_request` -  (is: String)
- `http_response` -  (is: String)
- `default_backend` -  (is: String)
- `use_backend` -  (is: Array)
- `acl` -  (is: Array)
- `extra_options` -  (is: Hash)
- `server` -  (is: Array)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

```ruby
haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats uri: '/',
        realm: 'Haproxy-Statistics',
        auth: 'user:pwd'
  http_request 'add-header X-Proto http'
  http_response 'set-header Expires %[date(3600),http_date]'
  default_backend 'servers'
  extra_options('bind-process' => 'odd')
  server ['admin0 10.0.0.10:80 check weight 1 maxconn 100',
          'admin1 10.0.0.10:80 check weight 1 maxconn 100']
end
```
### haproxy_resolver

Configuration related to name resolution in HAProxy. There can be as many as resolvers section as needed.

Each section can contain many name servers.

Introduced: v4.5.0

#### Actions

- `:create`

#### Properties

- `nameserver` -  (is: Array)
- `extra_options` -  (is: Hash)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

```ruby
haproxy_resolver 'dns' do
  nameserver ['google 8.8.8.8:53']
  extra_options('resolve_retries' => 30,
                'timeout' => 'retry 1s')
  notifies :restart, 'haproxy_service[haproxy]', :delayed
end
```
### haproxy_service

Installs HAProxy as a systemd or sysvinit service.
To reload HAProxy service add a subscribes option to the resource block. See example below.

Introduced: v4.0.0

#### Actions

- `:create`
- `:start`
- `:stop`
- `:restart`
- `:reload`
- `:enable`

#### Properties

- `bin_prefix` -  (is: String)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)
- `haproxy_user` -  (is: String)
- `haproxy_group` -  (is: String)
- `service_name` -  (is: String)

#### Examples

```ruby
haproxy_service 'haproxy'
```
```ruby
haproxy_service 'haproxy' do
  subscribes :reload, 'template[/etc/haproxy/haproxy.cfg]', :immediately
end
```
### haproxy_use_backend

Switch to a specific backend if/unless an ACL-based condition is matched.

Introduced: v4.2.0

#### Actions

- `:create`

#### Properties

- `use_backend` -  (is: [String, Array])
- `section` -  (is: String)
- `section_name` -  (is: String)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

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
### haproxy_userlist

Control access to frontend/backend/listen sections or to http stats by allowing only authenticated and authorized users.

Introduced: v4.1.0

#### Actions

- `:create`

#### Properties

- `group` -  (is: Hash)
- `user` -  (is: Hash)
- `config_dir` -  (is: String)
- `config_file` -  (is: String)

#### Examples

```ruby
haproxy_userlist 'mylist' do
  group 'G1' => 'users tiger,scott',
        'G2' => 'users xdb,scott'
  user  'tiger' => 'password $6$k6y3o.eP$JlKBx9za9667qe4(...)xHSwRv6J.C0/D7cV91',
        'scott' => 'insecure-password elgato',
        'xdb' => 'insecure-password hello'
end
```

## License & Authors

- Author:: Dan Webb (<https://github.com/damacus>)
- Author:: Will Fisher (<https://github.com/teknofire>)
- Author:: Richard Shade (<https://github.com/rshade>)
- Author:: Joshua Timberman ([joshua@chef.io](mailto:joshua@chef.io))
- Author:: Aaron Baer ([aaron@hw-ops.com](mailto:aaron@hw-ops.com))
- Author:: Justin Kolberg ([justin@hw-ops.com](mailto:justin@hw-ops.com))

```text
Copyright:: Heavy Water Operations, LLC.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
