require 'redcarpet'

# this comes from https://github.com/vmg/redcarpet/issues/92#issuecomment-35462000
# it works, but I can't figure out how to incorporate the options hash down below, which has useful functionality
# at some point this needs to be integrated, because Redcarpet surrounds its output in <p> tags, which causes unnecessary line breaks
#class RenderWithoutWrap < Redcarpet::Render::HTML
#  def postprocess(full_document)
#    Regexp.new(/\A<p>(.*)<\/p>\Z/m).match(full_document)[1] rescue full_document
#  end
#end

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
      no_images: true,
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
    
    #markdown = Redcarpet::Markdown.new(RenderWithoutWrap, extensions)
    
    markdown.render(text).html_safe
  end

end
