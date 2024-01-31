include_recipe 'config_2'

haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats uri: '/',
        realm: 'Haproxy-Statistics',
        auth: 'user:pwd'
  extra_options('block if restricted_page' => '!network_allowed')
end

haproxy_acl 'acls for listen' do
  section 'listen'
  section_name 'admin'
  acl ['network_allowed src 127.0.0.1']
end

haproxy_acl 'restricted_page path_beg /' do
  section 'listen'
  section_name 'admin'
end
