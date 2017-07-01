def default_conf
  node.default['haproxy']['conf_template_source'] = 'haproxy.cfg.erb' unless node['haproxy']['conf_template_source']
  node.default['haproxy']['conf_cookbook'] = 'haproxy' unless node['haproxy']['conf_cookbook']
end
