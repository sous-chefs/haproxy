use_inline_resources if defined?(use_inline_resources)

require 'digest/sha2'
require 'securerandom'

action :create do
  user = "user #{new_resource.username}"

  if new_resource.insecure_password
    user << " insecure-password #{new_resource.password}"
    node.normal_attrs['haproxy']['userlists'][new_resource.userlist]['stored_salts'].delete(new_resource.username)
  elsif new_resource.password[0..2] == '$6$'
    user << " password #{new_resource.password}"
  else
    salt = node['haproxy']['userlists'][new_resource.userlist]['stored_salts'][new_resource.username]
    unless salt
      salt = '$6$' + case Chef::Config[:solo]
                     when true
                       digest_key = new_resource.userlist + new_resource.username
                       name_shasum = Digest::SHA512.new.digest(digest_key).unpack('L_')[0]
                       Random.new(name_shasum).rand(36**8)
                     else
                       salt = SecureRandom.random_number(36**8)
                     end.to_s(36)
    end
    crypted_pw = new_resource.password.crypt(salt)
    node.normal['haproxy']['userlists'][new_resource.userlist]['stored_salts'][new_resource.username] = crypted_pw
    user << " password #{crypted_pw}"
  end

  user << " groups #{new_resource.groups.join(',')}" if new_resource.groups
  node.set['haproxy']['userlists'][new_resource.userlist]['users'][new_resource.username] = user
end
