include_controls 'haproxy-common'

describe directory '/opt/lua-5.3.1' do
  it { should exist }
end

describe command('haproxy -vv | grep Lua') do
  its('stdout') { should match(/Built with Lua version/) }
end
