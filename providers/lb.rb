use_inline_resources

action :create do
  # While there is no way to have an include directive for haproxy
  # configuration file, this provider will only modify attributes !
  listener = []
  if new_resource.bind.is_a? Hash
    new_resource.bind.map do |addresses, ports|
      addresses = Array(addresses) unless addresses.is_a? Array
      ports = Array(ports) unless ports.is_a? Array
      (Array(addresses).product Array(ports)).each do |combo|
        listener << "bind #{combo.join(':')}"
      end
    end
  else
    listener << "bind #{new_resource.bind}" unless new_resource.bind.nil?
  end
  listener << "balance #{new_resource.balance}" unless new_resource.balance.nil?
  listener << "mode #{new_resource.mode}" unless new_resource.mode.nil?
  listener += new_resource.servers.map { |server| "server #{server}" }

  listener += if new_resource.parameters.is_a? Hash
                new_resource.parameters.map { |k, v| "#{k} #{v}" }
              else
                new_resource.parameters
              end

  node.default['haproxy']['listeners'][new_resource.type][new_resource.name] = listener
end
