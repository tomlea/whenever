require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
require 'echoe'

require File.expand_path(File.dirname(__FILE__) + "/lib/version")

Echoe.new('whenever', Whenever::VERSION::STRING) do |p|
  p.description    = "Provides clean ruby syntax for defining messy cron jobs and running them Whenever."
  p.url            = "http://github.com/javan/whenever"
  p.author         = "Javan Makhmali"
  p.email          = "javan@javan.us"
  p.dependencies   = ["chronic >=0.2.3"]
end
rescue LoadError
  puts "Could not load echoe"
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :default => [:test]
