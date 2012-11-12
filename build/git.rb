class Version
  def self.to_s
    File.read("VERSION").strip
  end
end

class Changes
  class << self
    def all(since,path)
      Git.new(since, path).changes
    end
  end
end

class Git
  def initialize(since,path)
    @since,@path = since,path
  end
  
  def changes
    Changelist.new(modified, deleted)
  end

  private

  def modified
    to_files `git diff --name-status #{@since}..HEAD -- #{@path} | grep '^[A|M]'`
  end

  def deleted
    to_files `git diff --name-status #{@since}..HEAD -- #{@path} | grep '^[D]'`
  end

  def to_files(lines)
    lines.split("\n").map do |line|
      /^[A-Z]{1}\s+(.+)$/.match(line)[1]  
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
