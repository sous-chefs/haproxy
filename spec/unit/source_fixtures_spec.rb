# frozen_string_literal: true

require 'spec_helper'

describe 'source integration fixtures' do
  def fixture(name, platform, version)
    ChefSpec::SoloRunner.new(platform: platform, version: version).converge("test::#{name}")
  end

  it 'installs Lua build dependencies on Amazon Linux' do
    run = fixture('source_lua', 'amazon', '2023')
    expect(run).to install_package(%w(readline-devel ncurses-devel))
    expect(run).to extract_archive_file('lua source')
  end

  it 'does not require removed PCRE1 packages on Debian 13' do
    run = fixture('source_lua', 'debian', '13')
    expect(run).to install_package(%w(libreadline-dev libncurses-dev))
  end

  it 'installs complete Perl modules even when minimal Perl exists on EL8' do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/usr/bin/perl').and_return(true)
    stub_command('perl -MFindBin -Mlib -MFile::Compare -MFile::Copy -MIPC::Cmd -MPod::Html -MTime::Piece -e 1').and_return(false)
    run = fixture('source_openssl', 'almalinux', '8')
    expect(run).to install_package('perl-core')
    expect(run).to extract_archive_file('openssl source')
  end

  it 'does not reinstall Perl when the OpenSSL modules are already available' do
    stub_command('perl -MFindBin -Mlib -MFile::Compare -MFile::Copy -MIPC::Cmd -MPod::Html -MTime::Piece -e 1').and_return(true)
    run = fixture('source_openssl', 'almalinux', '8')
    expect(run).not_to install_package('perl-core')
  end

  it 'uses zlib-ng headers for the OpenSSL build on Leap 16' do
    run = fixture('source_openssl', 'opensuse', '16.0')

    expect(run).to install_package(%w(perl zlib-ng-compat-devel))
    expect(run).not_to install_package('zlib-devel')
  end

  it 'keeps custom OpenSSL libraries out of the system linker configuration' do
    run = fixture('source_openssl', 'opensuse', '16.0')

    expect(run).not_to create_file('/etc/ld.so.conf.d/openssl-3.5.5.conf')
  end

  %w(source_lua source_openssl).each do |fixture_name|
    it "avoids kernel development headers for #{fixture_name} on Fedora 45" do
      runner = ChefSpec::SoloRunner.new(platform: 'fedora', version: '32') do |node|
        node.automatic['platform_version'] = '45'
      end
      run = runner.converge("test::#{fixture_name}")

      expect(run).to install_package(%w(gcc make))
    end
  end
end
