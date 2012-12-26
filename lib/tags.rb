module TagItems
  # Create items for each tag. See
  # https://github.com/telemachus/ithaca/blob/master/lib/categories.rb and
  # http://stackoverflow.com/questions/13866141/how-to-generate-pages-for-each-tag-in-nanoc
  def create_tag_items
    require 'set'

    tags = Set.new
    items.each do |item|
      item[:tags].each { |t| tags.add(t) } unless item[:tags].nil?
    end

    tags.each do |tag|
      @items << Nanoc::Item.new('', { :tag => tag, :title => "Articles on &ldquo;#{tag}&rdquo;" }, "/tags/#{tag}")
    end
  end
end

include TagItems
