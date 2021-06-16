name 'haproxy'

default_source :supermarket, 'https://supermarket.chef.io'
cookbook 'haproxy', path: '.'
cookbook 'test', path: 'test/cookbooks/test'

run_list 'haproxy'

tests = (Dir.entries('./test/cookbooks/test/recipes').select { |f| !File.directory? f })
tests.each do |test|
  test = test.gsub('.rb', '')
  named_run_list :"#{test.to_sym}", "test::#{test}"
end
