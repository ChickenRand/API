require 'rspec/core/rake_task'

Dir.glob(File.expand_path('../task/*.rake', __FILE__)) { |task| import task }

RSpec::Core::RakeTask.new(:spec)
task :default => :spec