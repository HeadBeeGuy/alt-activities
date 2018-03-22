require 'redcarpet'

module ApplicationHelper
  
  # specifying options for Markdown rendering with Redcarpet
  # pinching from https://richonrails.com/articles/rendering-markdown-with-redcarpet
  # at present, disallowing links and other stuff that might assist in spamming or scamming
  def markdown(text)
    options = {
      filter_html: true,
      hard_wrap: true,
      fenced_code_blocks: true,
      no_links: true,
      no_styles: true
    }
    
    extensions = {
      no_intra_emphasis: true,
      tables: true,
      strikethrough: true,
      highlight: true
    }
    
    # for some reason Redcarpet doesn't capitalize the C! Whatever happened to CamelCase?!
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    
    markdown.render(text).html_safe
  end
end
