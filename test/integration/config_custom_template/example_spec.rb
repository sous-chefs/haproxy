
describe directory '/etc/haproxy' do
  it { should exist }
end

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
  it { should exist }
  it { should be_owned_by 'haproxy' }
  it { should be_grouped_into 'haproxy' }

  its('content') { should match(/#{cfg_content.join('\n')}/) }
end

describe service('haproxy') do
  it { should be_running }
end
