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
    Time.parse(item[:created_at]).strftime('%B %d, %Y')
  end

  # Retrieve the articles belonging to the current tag. See
  # https://gist.github.com/889341 as the base. This is a static site so items
  # rendered here are only random upon compilation.
  def related_articles
    articles = []

    unless item[:tags].nil?
      item[:tags].each do |tag|
        articles.concat(items_with_tag(tag))
      end
    end

    # Return only unique items.
    articles.uniq!

    # Sort articles.
    articles.sort_by! do |a|
      attribute_to_time(a[:created_at])
    end.reverse

    # Return only items from first to fifth.
    articles[0..4]
  end

  # Generate the url for the current item with the hash of the item's raw
  # content appended after ?. Used as cache buster.
  def url_with_hash_for(identifier)
    require 'digest/sha1'

    item = @items.find { |i| i.identifier == identifier }
    item.path + '?' + Digest::SHA1.hexdigest(item.raw_content)[0, 8]
  end
end

include MyHelper
