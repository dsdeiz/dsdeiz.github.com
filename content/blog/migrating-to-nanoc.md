---
kind: article
layout: post
excerpt: ''
title: Migrating to Nanoc
created_at: Dec 27 2012
tags: 
- nanoc
- ruby
---
Recently, I've migrated my blog to [Nanoc](http://nanoc.stoneship.org). I think there's too much hacking involved if you want to extend [Jekyll](http://jekyllrb.com/). Or perhaps I didn't just read enough documentation about Jekyll. But anyway, I've already made the switch. What's done is done.

The first thing I did was to convert my markdown files. This wasn't really a problem since both Jekyll and Nanoc almost have the same format for the markdown files. Only difference I think would be the `kind` and `created_at` attributes so to be able to use the [Blogging](http://nanoc.stoneship.org/docs/api/3.4/Nanoc/Helpers/Blogging.html)  helper for Nanoc. Since I am trying to learn Ruby, I decided to create a [script](https://github.com/dsdeiz/dsdeiz.github.com/blob/source/scripts/editor.rb) to make these changes on the files. This is what the script does:

1. Retrieve the files with the extension **.md** on a specified directory.
2. Split up the YAML attributes and the actual content.
3. Create new YAML attributes based on the old one but add the `created_at`, `kind`, and `excerpt`(not using this one at the moment) attributes.
4. Replace `{% highlight language %}...{% endhighlight %}` with `~~~ language...~~~`. This is so I could use **fenced code blocks**.
5. Delete the current file.
6. Write the new contents to a new file deleting the date from the beginning of the file name.

I then created a new [helper](https://github.com/dsdeiz/dsdeiz.github.com/blob/source/lib/helpers.rb#L7). The helper contains an implementation of Redcarpet's renderer. I needed the code blocks to generate the tags `<pre><code class="language-[language]">...</code></pre>` in order for Nanoc's [ColorizeSyntax](http://nanoc.stoneship.org/docs/api/3.4/Nanoc/Filters/ColorizeSyntax.html) to pass it over to `pygmentize`. This is what I have in my `Rules` file in order for Nanoc to use the renderer.

~~~ ruby
filter :redcarpet,
       :options => { :fenced_code_blocks => true },
       :renderer => MyHelper::CustomRenderer
~~~

I didn't use **kramdown** which is the default markdown parser for Nanoc since I don't know how to do it. In my helper, I also had the `publish_date` method which displays a better format of the `created_at` attribute.

As for the layouts, it seems Nanoc's layouts are almost the same as Jekyll's but instead of using Liquid, it uses [ERB](http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html). I don't really know what ERB is but I think it's just like putting `<?php print $foo ?>` in your template files e.g. `<%= foo %>`. For the index file, I had a list of all articles with their 'excerpts'. Nanoc has the [Text](http://nanoc.stoneship.org/docs/api/3.4/Nanoc/Helpers/Text.html) helper to generate excerpts. It isn't that good though. To generate an excerpt, I used this snippet:

~~~ ruby
excerptize(strip_html(item.compiled_content), { :length => 600 })
~~~

For stylesheets, I still used Compass. There is an existing [documentation](https://github.com/chriseppstein/compass/wiki/nanoc-Integration) on the integration of Compass with Nanoc. I don't really know what are the advantages of having a `:sass` filter rather than just editing the `config.rb` file and running `compass watch` inside your project directory.

For the **Tag** items, I used [this](https://github.com/telemachus/ithaca/blob/master/lib/categories.rb) and [this](http://stackoverflow.com/questions/13866141/how-to-generate-pages-for-each-tag-in-nanoc) for the [tags](https://github.com/dsdeiz/dsdeiz.github.com/blob/source/lib/tags.rb) helper (it's the same as the latter though).

For the **Related Articles**, I have a method for this at `MyHelper`. This one is based on [this gist](https://gist.github.com/889341). It's kinda funny though since I was planning to display random articles for each tags tagged on the current article displayed but since this is a static site, the random articles are only generated on compilation. xD

That's it for now. I'm still planning to create an image gallery, portfolio, about page, rss feed and probably a contact page. And also add disqus. And probably a way to create new blog posts other than creating the files by hand.

**References:**

* [Nanoc's Documentation](http://nanoc.stoneship.org/docs/)
* [Building a Blog with Nanoc](http://www.danhoey.com/blog/2011_09_23_building_a_blog_with_nanoc/)
* [Building a static blog with nanoc](http://clarkdave.net/2012/02/building-a-static-blog-with-nanoc/)
* [Blogging with nanoc](http://mhyee.com/blog/nanoc.html)
