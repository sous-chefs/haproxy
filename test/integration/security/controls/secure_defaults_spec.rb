title 'HAProxy Secure Configuration Checks'

# Include common HAProxy tests
include_controls 'common'

# Security Baseline for HAProxy Configuration
describe 'HAProxy Security Defaults' do
  # Global Security Checks
  describe file('/etc/haproxy/haproxy.cfg') do
    # Basic configuration
    its('content') { should match(/^\s*user\s+haproxy/) }
    its('content') { should match(/^\s*group\s+haproxy/) }
    its('content') { should match(/^\s*daemon/) }

    # Logging configuration
    its('content') { should match(%r{^\s*log\s+/dev/log\s+syslog\s+info}) }
    its('content') { should match(/^\s*log-tag\s+haproxy/) }
    its('content') { should_not match(/^\s*log-send-hostname/) }

    # Stats socket configuration
    its('content') { should match(%r{^\s*stats\s+socket\s+/var/run/haproxy\.sock\s+user\s+haproxy\s+group\s+haproxy}) }
    its('content') { should match(/^\s*stats\s+timeout\s+2m/) }

    # Connection settings
    its('content') { should match(/^\s*maxconn\s+1000/) }

    # Default timeouts
    its('content') { should match(/^\s*timeout\s+client\s+10s/) }
    its('content') { should match(/^\s*timeout\s+server\s+10s/) }
    its('content') { should match(/^\s*timeout\s+connect\s+10s/) }

    # Default options
    its('content') { should match(/^\s*option\s+httplog/) }
    its('content') { should match(/^\s*option\s+dontlognull/) }
    its('content') { should match(/^\s*option\s+redispatch/) }
    its('content') { should match(/^\s*option\s+tcplog/) }

    # Mode and balance
    its('content') { should match(/^\s*mode\s+http/) }
    its('content') { should match(/^\s*balance\s+roundrobin/) }

    # File permissions
    it { should be_owned_by 'haproxy' }
    it { should be_grouped_into 'haproxy' }
    its('mode') { should cmp '0640' }
  end

  # Service Configuration
  describe service('haproxy') do
    it { should be_enabled }
    it { should be_running }
  end
end

# Additional Security Recommendations
describe 'Security Recommendations' do
  # Validate service configuration
  describe service('haproxy') do
    it { should be_enabled }
    it { should be_running }
  end
end
