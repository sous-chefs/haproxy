include_controls 'haproxy-common'

cfg_content = [
  'global',
  '  user haproxy',
  '  group haproxy',
  '  log /dev/log syslog info',
  '  log-tag haproxy',
  '  chroot /var/lib/haproxy',
  '  daemon',
  '  quiet',
  '  stats socket /var/run/haproxy\.sock user haproxy group haproxy',
  '  stats timeout 2m',
  '  maxconn 4096',
  '  pidfile /run/haproxy\.pid',
]

describe file('/etc/haproxy/haproxy.cfg') do
  its('content') { should match(/#{cfg_content.join('\n')}/) }
end
