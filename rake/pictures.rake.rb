desc "Resize an image"
task :resize do
  source_dir = File.expand_path(File.join ".", "pictures")
  
  require "fileutils"

  out = "next/img"

  FileUtils.mkdir_p out unless Dir.exists? out

  Image.new("#{source_dir}/IMG_2477.JPG").tap do |img|
    img.on(:resized){|e,args| puts args.first}
  end.resize(:percentage => 40, :to => "#{out}/home.jpg")
end

class Image
  require "audible"; include Audible

  def initialize(name)
    @name = name
  end

  def resize(opts = {})
    percentage = opts[:percentage] || 50
    
    output = opts[:to] || fail("No :to supplied, don't know where to save it to.")

    fail "I refuse to overwrite" if output === @name

    `convert #{@name} -resize #{percentage}% #{output}`

    notify :resized, "Resized <#{@name}> by #{percentage}% and wrote to <#{output}>"
  end
end
