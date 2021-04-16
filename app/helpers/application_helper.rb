require 'redcarpet'

module ApplicationHelper
  
  # potential levels: :restricted, :permissive, :image_and_video
  def markdown(text, specifications = {})

    # restricted options set by default
    options = {
      filter_html: true,
      hard_wrap: true,
      fenced_code_blocks: true,
      no_links: true,
      no_images: true,
      no_styles: true
    }
    
    extensions = {
      no_intra_emphasis: true,
      tables: true,
      strikethrough: true,
      highlight: true
    }

    if specifications[:level] == :permissive
      options[:no_links] = false
    elsif specifications[:level] == :image_and_video
      options[:no_links] = false
      options[:no_images] = false
      options[:filter_html] = false
    end
    
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    
    markdown.render(text).html_safe
  end
end
