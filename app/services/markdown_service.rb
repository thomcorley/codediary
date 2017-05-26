class MarkdownService
require 'redcarpet'

def render(markdown_input)

  renderer = Redcarpet::Render::HTML.new
  markdown = Redcarpet::Markdown.new(renderer)

end
