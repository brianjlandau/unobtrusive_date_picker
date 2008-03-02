require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'
require 'spec/rake/spectask'

desc 'Test the unobtrusive_date_picker plugin.'
Rake::TestTask.new(:test) do |t|
   t.libs << 'lib'
   t.pattern = 'test/**/*_test.rb'
   t.verbose = true
end

desc 'Generate documentation for the unobtrusive_date_picker plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
   rdoc.rdoc_dir = 'rdoc'
   rdoc.title    = 'Unobtrusive Date-Picker'
   rdoc.options << '--line-numbers' << '--inline-source'
   rdoc.rdoc_files.add ['lib/**/*.rb', 'README', 'MIT-LICENSE']
   rdoc.options << '--main' << 'README'
end

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', 'spec/spec.opts']
end
