desc "Generate the pages"
task :generate do
  page_template = File.join ".", "templating", "templates", "page.html.erb"
  
  puts Press.new.render page_template
end

class Press
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
