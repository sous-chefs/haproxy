use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do
  set_updated { install_haproxy_config }
end

def install_haproxy_config
  template "#{new_resource.conf_dir}/haproxy.cfg" do
    cookbook new_resource.conf_cookbook
    source new_resource.conf_template_source
    owner "root"
    group "root"
    mode 00644
    variables(
      :defaults_options => defaults_options,
      :defaults_timeouts => defaults_timeouts
    )
  end
end

def defaults_options
  options = node['haproxy']['defaults_options'].dup
  if node['haproxy']['x_forwarded_for']
    options.push("forwardfor")
  end
  return options.uniq
end

def defaults_timeouts
  node['haproxy']['defaults_timeouts']
end

def set_updated
  r = yield
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
