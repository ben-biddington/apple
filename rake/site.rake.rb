desc "Generate the pages"
task :generate do
  Site.on(:page){|e,args| puts "Generated <#{args.first}>"}
  Site.generate
end

class Site
  require "audible"; extend Audible
  
  class << self
    def generate
      pages.each do |page| 
        page.on(:rendered){|e,args| notify(:page, args.first)}
        page.render
      end      
    end

    private

    def pages
      [
       Page.new(:template => page_template, :out => File.join(output_dir, "home.html")),
       Page.new(:template => page_template, :out => File.join(output_dir, "about.html"))
      ]
    end

    def page_template
      File.join ".", "templating", "templates", "page.html.erb"
    end

    def output_dir
      File.join ".", "next"
    end
  end
end

class Page
  require "audible"; include Audible

  def initialize(opts = {})
    @template = opts[:template]
    @out = opts[:out]
  end

  def render
    File.open @out, "w+" do |f|
      require "liquid"

      template_path = File.join ".", "templating", "templates"

      fail unless File.exists? template_path

      Liquid::Template.file_system = Liquid::LocalFileSystem.new(template_path) 

      template = Liquid::Template.parse(File.read(@template), :error_mode => :strict)
      
      f.puts template.render "title" => "xxx", "template_dir" => File.dirname(@template)

      notify :rendered, @out
    end
  end
end
