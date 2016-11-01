#!/usr/bin/env ruby
# ^syntax detection

require 'finstyle'

guard :rubocop, :keep_failed => false, :cli => '-r finstyle' do
  watch(%r{.+\.rb$}) { |m| m[0] }
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard 'foodcritic', :cookbook_paths => '.', :cli => '-C -t ~FC001' do
  watch(%r{attributes/.+\.rb$})
  watch(%r{providers/.+\.rb$})
  watch(%r{recipes/.+\.rb$})
  watch(%r{resources/.+\.rb$})
end

spec_path = 'test/unit'
rspec_guard_config = {
  :cmd => "bundle exec rspec --color --format progress --default-path=#{spec_path}",
  :all_on_start => true,
  :spec_paths => [spec_path]
}

guard 'rspec', rspec_guard_config do
  watch(%r{^#{spec_path}/.+_spec\.rb$})
  watch("#{spec_path}/spec_helper.rb")  { spec_path }
  watch(%r{^(libraries|providers|recipes|resources)/(.+)\.rb$}) do |m|
    "#{spec_path}/#{m[2]}_spec.rb"
  end
end
