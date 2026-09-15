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
end
