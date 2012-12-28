---
kind: article
layout: post
excerpt: ''
title: Image Gallery in Nanoc
created_at: Dec 28 2012
tags: 
- nanoc
- ruby
---
My image gallery for [screenies](/gallery/screenies) is a custom data source for Nanoc which generates items for each JSON file located in the `gallery` directory. This makes it easy for me to grab the images rather than creating an item for each image by hand.

I created a ruby [script](https://github.com/dsdeiz/dsdeiz.github.com/blob/source/scripts/dropbox.rb) that grabs all images from my Dropbox account since it is where all my desktop screenshots are stored. The script then generates a JSON file with each image in an entry `{ 'image': '...', 'thumbnail': '...' }`. This is my first time messing around with the Dropbox API too. The API is well documented so I just had to follow the [tutorial](https://www.dropbox.com/developers/start/setup#ruby). I've used [this](https://www.dropbox.com/static/developers/dropbox-ruby-sdk-1.5.1-docs/) and the file located under `/path/to/dropbox-sdk/cli_example.rb` as references. What the script does is just grab the files on my Dropbox account under `Public/screenies` and their corresponding thumbnails which are located under `Public/screenies/thumbs`. The filename for a thumbnail is the original filename + '-thumb.png'. The script only includes the images that have thumbnails. It then generates the JSON entry mentioned above. The URLs for each image and thumbnail can be generated using this pattern - `https://dl.dropbox.com/u/[uid]/screenies/filename.png`. I just then need to run the script for it to generate the JSON file under the `gallery` directory.

After having the JSON file, I created a [custom data source](https://github.com/dsdeiz/dsdeiz.github.com/blob/source/lib/image_gallery.rb) for image galleries. What the data source does is grab each JSON files located under `gallery` and create items for each entry in those files. Each item would have the identifier `/gallery/filename_of_json_file/image_property_of_entry`. Attributes for each items are hardcoded so each entry on the JSON file requires the 'image' and 'thumbnail' properties. It also adds the attributes 'kind' and 'type' in which 'kind' is 'gallery' and 'type' is the basename of the JSON file. In this data source, I only implemented the [items](http://nanoc.stoneship.org/docs/api/3.4/Nanoc/DataSource.html#items-instance_method) method. In my `Rules` file, I then have this:

~~~ ruby
compile '/gallery/*/' do
  # Galleries have identifiers /gallery/*. Only compile if extension is 'html'.
  if item[:extension] == 'html'
    filter :erb
    layout 'page'
  end
end

route '/gallery/*/' do
  if item[:extension] == 'html'
    item.identifier + 'index.html'
  else
    # no output for galleries
    nil
  end
end
~~~

The rule only compiles items with identifiers `/gallery/` and extension 'html'. This is so each items the data source creates doesn't have its page.

With this custom data source, I could now create galleries for each json file other than 'screenies'. It could use some improvements but for now, I'm satisfied with this implementation.
