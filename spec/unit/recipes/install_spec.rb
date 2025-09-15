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

  context 'compile HAProxy' do
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

  context 'compile HAProxy with custom OpenSSL' do
    recipe do
      haproxy_install 'source' do
        use_openssl true
        ssl_lib '/usr/local/openssl/lib'
        ssl_inc '/usr/local/openssl/include'
      end
    end
    before(:each) do
      stub_command('/usr/sbin/haproxy -v | grep 2.8.5').and_return('2.8.5')
    end

    it 'includes RPATH in the compilation command' do
      expect(chef_run).to run_bash('compile_haproxy').with(
        code: %r{LDFLAGS=-Wl,-rpath,/usr/local/openssl/lib}
      )
    end

    it 'includes SSL_LIB and SSL_INC in the compilation command' do
      expect(chef_run).to run_bash('compile_haproxy').with(
        code: %r{SSL_LIB=/usr/local/openssl/lib SSL_INC=/usr/local/openssl/include}
      )
    end
  end
end
