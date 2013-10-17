desc "Generate the pages"
task :generate do
  page_template = File.join ".", "templating", "templates", "page.html.erb"
  output_dir = File.join ".", "next"

  home = File.join output_dir, "home.html"

  Page.new(:template => page_template, :out => home).tap do|it|
    it.on(:rendered){|e,args| puts "Wrote <#{args.first}>"}
  end.render
end

class Page
  require "audible"; include Audible

  def initialize(opts = {})
    @template = opts[:template]
    @out = opts[:out]
  end

  def render
    File.open @out, "w+" do |f|
      f.puts Press.render @template
      notify :rendered, @out
    end
  end
end

class Press
  class << self
    def render(path) 
      require "erb"
    
      @template_dir = File.dirname path

      renderer = ERB.new(File.read(path))
    
      renderer.result(binding)
    end
    
    def template_dir
      @template_dir
    end
  end
end