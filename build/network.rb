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
