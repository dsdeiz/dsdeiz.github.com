include Nanoc::Helpers::Rendering
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Blogging

require 'redcarpet'

class CustomRenderer < Redcarpet::Render::HTML
  def block_code(code, language)
    "<pre><code class=\"highlight language-#{language}\">\n#{code}\n</code></pre>\n"
  end
end
