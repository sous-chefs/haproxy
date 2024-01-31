include_controls 'haproxy-common'

describe command('haproxy -vv') do
  its('stdout') { should match(/Built with the Prometheus exporter as a service/) }
end
