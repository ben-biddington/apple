desc "Generate the pages"
task :generate do
  Site.on(:page){|e,args|               puts "Generated <#{args.first}>"}
  Site.on(:output_dir_created){|e,args| puts "Created <#{args.first}>"}
  
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
       page(template("page.template"), "index"),
       page(template("availability.template"), "calendar"),
       page(template("rooms.template"), "rooms")
      ]
    end

    def template(name)
      File.join(".", "templating", "templates", name)
    end

    def page(template, name)
      Page.new(:template => template, :out => File.join(output_dir, "#{name}.html"))
    end

    def output_dir
      File.join(".", "next").tap do |dir|
        make dir unless Dir.exists? dir
      end
    end
    
    def make(what)
      Dir.mkdir what
      notify :output_dir_created, what
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
      
      f.puts template.render "title" => "Split Apple Rock"

      notify :rendered, @out
    end
  end
end
