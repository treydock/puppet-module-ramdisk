require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

task :default do
  sh %{rake -T}
end

desc "Run rspec-puppet and puppet-lint tasks"
task :ci => [
  :lint,
  :spec,
]