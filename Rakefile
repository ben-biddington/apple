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
  puts Git.changes root_revision, "public_html/"
end

class Git
  class << self
    def changes(since,path)
      Changelist.new(modified(since, path), deleted(since, path))
    end

    private

    def modified(since,path)
      to_files `git diff --name-status #{since}..HEAD -- #{path} | grep '^[A]'`
    end

    def deleted(since,path)
      to_files `git diff --name-status #{since}..HEAD -- #{path} | grep '^[D]'`
    end

    def all(since,path)
      `git diff --name-status #{since}..HEAD -- #{path}`
    end

    def to_files(lines)
      lines.split("\n").map do |line|
        /^[A-Z]{1}\s+(.+)$/.match(line)[1]  
      end
    end
  end
end

class Changelist
  attr_reader :modified,:deleted

  def initialize(modified=[], deleted=[])
    @modified = modified
    @deleted = deleted
  end

  def to_s
    self.modified.inspect + self.deleted.inspect
  end
end
