---
kind: article
layout: post
excerpt: ''
title: Migrating to Jekyll Part 1
created_at: Feb 2 2012
tags: 
- jekyll
- ruby
---
Recently, I read about a few Drupal blogs migrating over to [Jekyll](https://github.com/mojombo/jekyll) &mdash; [acko.net](http://acko.net/blog/making-love-to-webkit/) and [Development Seed](http://developmentseed.org/blog/2011/09/09/jekyll-github-pages/). The concept seems nice as you will be writing the content in files instead of a database so I thought I would give it a try. With this, I am able to write blog posts using [Vim](http://www.vim.org/). Also, on my current blog, I am using [Markdown](http://daringfireball.net/projects/markdown/) as my input filter for writing blog posts.

## Installation &amp; Configuration

Installing **Jekyll** was easy as I had only to follow [these instructions](https://github.com/mojombo/jekyll/wiki/Install). Did the following steps to install it:

~~~ bash
$ sudo apt-get install rubygems
$ sudo gem install jekyll
$ sudo apt-get install python-pygments
$ export PATH=$PATH:/var/lib/gems/1.8/bin
~~~

For the path, I added it after on my `.bashrc`. I then created a directory structure based on [this](https://github.com/mojombo/jekyll/wiki/Usage). I have also added the directories **css, images and fonts** that would store media files. And for my `_config.yml` file, I have this:

~~~ yaml
baseurl: /
name: dsdeiz.github.com
pygments: true
~~~

## Setup

The current setup of my Jekyll site has 2 categories namely **blog** and **gallery**. The **blog** category would contain the actual blog posts as the **gallery** would contain images. The variables used for [YAML Front Matter](https://github.com/mojombo/jekyll/wiki/YAML-Front-Matter) for my **blog** post only contain the basic ones:

* layout (value is *post* always)
* title
* category

For my **gallery** post, I have this format:

{% highlight yaml %}
