# if source determine target
@target_os = 'generic'
if node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6
  @target_os = 'linux2628'
elsif (node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6) && (node['kernel']['release'].split('.')[2].split('-').first.to_i > 28)
  @target_os = 'linux2628'
elsif (node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6) && (node['kernel']['release'].split('.')[2].split('-').first.to_i < 28)
  @target_os = 'linux26'
end

default['haproxy']['source']['version'] = '1.7.2'
default['haproxy']['source']['url'] = 'http://www.haproxy.org/download/1.7/src/haproxy-1.7.2.tar.gz'
default['haproxy']['source']['checksum'] = 'f95b40f52a4d61feaae363c9b15bf411c16fe8f61fddb297c7afcca0072e4b2f'
default['haproxy']['source']['prefix'] = '/usr/local'
default['haproxy']['source']['target_os'] = @target_os
default['haproxy']['source']['target_cpu'] = node['kernel']['machine']
default['haproxy']['source']['target_arch'] = ''
