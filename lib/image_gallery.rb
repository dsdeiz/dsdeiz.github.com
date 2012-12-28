module ImageGalleryHelper
  require 'json'

  class ImageGalleryDataSource < Nanoc::DataSource
    identifier :image_gallery

    # Create the items from the screenies.json file.
    def items
      items = []

      # Retrieve all json files.
      dir_name = 'gallery'
      Dir[dir_name + '/*.json'].each do |file|
        # Open the current file and load its content.
        json = File.open(file, 'r') { |f| JSON.load(f) }
        filename = File.basename(file, '.json')

        # Iterate over each item on the JSON file and create new Nanoc::Item.
        json.each do |screen|
          image_filename = File.basename(screen['image'], '.*')
          identifier = "/#{dir_name}/#{filename}/#{image_filename}"
          attributes = {
            :image => screen['image'],
            :thumbnail => screen['thumbnail'],
            :kind => 'gallery',
            :type => filename
          }

          items << Nanoc::Item.new(screen.to_s, attributes, identifier)
        end
      end

      items
    end
  end

  # Retrieve gallery.
  def get_gallery(type)
    @items.select { |item| item[:kind] == 'gallery' and item[:type] == type }
  end
end

include ImageGalleryHelper
