require "rspec/core/rake_task"

desc "run all tests"
RSpec::Core::RakeTask.new

task :default => :spec

desc "switch configuration"
task :config, :name do |t,args|
  from = "public_html/js/config.#{args.name}.js"
  to = 'public_html/js/config.js'

  current_configs = Dir.glob("public_html/js/config.*.js").map do |file| 
    /config.(.+).js/.match(file)[1]
  end

  unless File.exists? from
    puts "There is no configuration for <#{args.name}>. No such file <#{from}>.\n" + 
      "Available choices are: #{current_configs.join(',')}"
    exit 1
  end

  require "fileutils"
  FileUtils.copy from, to

  puts "copied <#{from}> to <#{to}>"
end

desc "print the list of changed files"
task :changes do
  root_revision = File.read("VERSION").strip
  puts Changes.all root_revision, "public_html/"
end

class Changes
  class << self
    def all(since,path)
      `git diff --name-status #{since}..HEAD -- #{path}`
    end
  end
end
