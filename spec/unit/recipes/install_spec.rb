require 'spec_helper'

describe 'haproxy_install' do
  step_into :haproxy_install
  platform 'ubuntu'

  context 'install haproxy using the package method' do
    recipe do
      haproxy_install 'package'
    end

    it { is_expected.to install_package('haproxy') }
  end

  context 'compile HAProxy on Ubuntu' do
    recipe do
      haproxy_install 'source' do
        use_libcrypt true
        use_pcre true
        use_openssl true
        use_zlib true
        use_linux_tproxy true
        use_linux_splice true
      end
    end
    before(:each) do
      stub_command('/usr/sbin/haproxy -v | grep 2.8.5').and_return('2.8.5')
    end

    it { is_expected.to install_package(%w(libpcre3-dev libssl-dev zlib1g-dev libsystemd-dev)) }
    it { is_expected.not_to install_package('pcre-devel') }
  end

  context 'compile HAProxy on CentOS Stream 9' do
    platform 'centos', '9'
    
    recipe do
      haproxy_install 'source'
    end
    before(:each) do
      stub_command('/usr/sbin/haproxy -v | grep 2.8.5').and_return('2.8.5')
    end

    it { is_expected.to install_package(%w(pcre-devel openssl-devel zlib-devel systemd-devel tar)) }
    it { is_expected.not_to install_package('pcre2-devel') }
  end

  context 'compile HAProxy on CentOS Stream 10' do
    platform 'centos', '10'
    
    recipe do
      haproxy_install 'source'
    end
    before(:each) do
      stub_command('/usr/sbin/haproxy -v | grep 2.8.5').and_return('2.8.5')
    end

    it { is_expected.to install_package(%w(pcre2-devel openssl-devel zlib-devel systemd-devel tar)) }
    it { is_expected.not_to install_package('pcre-devel') }
  end

  context 'compile HAProxy with explicit PCRE2 on older platform' do
    platform 'centos', '8'
    
    recipe do
      haproxy_install 'source' do
        use_pcre false
        use_pcre2 true
      end
    end
    before(:each) do
      stub_command('/usr/sbin/haproxy -v | grep 2.8.5').and_return('2.8.5')
    end

    it { is_expected.to install_package(%w(pcre-devel openssl-devel zlib-devel systemd-devel tar)) }
  end
end
