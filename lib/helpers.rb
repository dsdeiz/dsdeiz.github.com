include Nanoc::Helpers::Rendering
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Blogging
include Nanoc::Helpers::Text
include Nanoc::Helpers::Tagging

module MyHelper
  require 'redcarpet'

  class CustomRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      "<div class=\"highlight\"><pre><code class=\"language-#{language}\">\n#{code.gsub(/[<>]/, '<' => '&lt;', '>' => '&gt;')}\n</code></pre></div>\n"
    end
  end

  # Prettify the date.
  def published_date(item)
    require 'time'
    Time.parse(item[:created_at]).strftime('%B %m, %Y')
  end
end

include MyHelper
