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

Dir.glob("#{File.dirname(__FILE__)}/build/**/*.rb").each{|f| require f}

desc "print the list of changed files"
task :changes do
  release = Release.new(
    Git.new(Version.to_s,"public_html/"),
    DryRunNetwork.new                        
  )

  release.deploy
end

class DryRunNetwork
  def send(modified)
    puts "MODIFIED (#{modified.size}):\n"
    list modified
  end

  def delete(deleted)
    puts "DELETED (#{deleted.size}):\n"
    list deleted
  end

  private

  def list(files=[])
    files.each{|file| puts file}
  end
end
