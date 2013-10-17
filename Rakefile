require "rspec/core/rake_task"

require File.join ".", "rake", "pictures.rake.rb"

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

desc "Print the list of changed files"
task :changes do
  dir = "public_html/"

  release = Release.new(
    Git.new(Version.to_s, dir),
    DryRunNetwork.new                        
  )

  puts "Reading changes from: #{dir}"
  
  release.deploy
end

desc "Deploys the changes between the remote version and the current head"
task :deploy do
  dir = "public_html/"
  
  release = Release.new(
    Git.new(Version.to_s, dir),
    FtpNetworkFactory.create
  )

  puts "Reading changes from: #{dir}"

  release.deploy

  # TODO: Need to rename the js config file
end

desc "Sets remote version to the current head"
task :set_remote_version do
  RemoteVersion.new(FtpNetworkFactory.create).set
end
