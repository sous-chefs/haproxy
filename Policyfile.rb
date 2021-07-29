name 'haproxy'

default_source :supermarket, 'https://supermarket.chef.io'
metadata
cookbook 'test', path: 'test/cookbooks/test'

run_list 'haproxy'

Dir.each_child('./test/cookbooks/test/recipes') do |test|
  named_run_list :"#{File.basename(test, '.*')}".to_sym, "test::#{File.basename(test, '.*')}"
end
