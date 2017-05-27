class MarkdownService
require 'redcarpet'

def render(markdown_input)
  renderer = Redcarpet::Render::HTML.new
  markdown = Redcarpet::Markdown.new(renderer)
  markdown.render(markdown_input)
end

end
