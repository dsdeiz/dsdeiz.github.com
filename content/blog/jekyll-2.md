---
kind: article
layout: post
excerpt: ''
title: Migrating to Jekyll Part 2
created_at: Feb 2 2012
tags: 
---
After setting up the basic install of my Jekyll site, I then migrated the posts of my current Drupal site over to Jekyll.

## Migrating Drupal Posts to Jekyll

Migration was also easy as I only needed to follow [these steps](https://github.com/mojombo/jekyll/wiki/Blog-Migrations). I first installed the extensions `sequel` and `mysqlplus`.

~~~ bash
$ sudo gem install sequel mysqlplus
~~~

After this, I downloaded a backup copy of the database of my current blog using [Backup and Migrate](http://drupal.org/project/backup_migrate) and imported it to a newly created database. As far as I know, you would only actually need the tables `node` and `node_revisions`. My Drupal site has a prefix `drpl_` for its tables so I need to make some minor modifications on the migration script. If you are not aware if where the migration script exists, I was able to find it at `/var/lib/gems/1.8/gems/jekyll-0.11.2/lib/jekyll/migrators/drupal.rb`. I've prepended the tables with `drpl_`. You can also opt to use this [script](http://drupal.org/node/403742) to remove the prefixes. The migration script also makes use of the **System URL** i.e. node/\[nid\]. I've read in other sites that the script messes up when nodes use an alias. What I did was that I deleted all aliases since the database I'm using is only a backup. I did `mysql -u user -p -e "TRUNCATE TABLE drpl_url_alias"` for this.

After preparing the script and removing the aliases, I executed the migration command from Jekyll's documentation.

~~~ bash
$ ruby -rubygems -e 'require "jekyll/migrators/drupal"; Jekyll::Drupal.process("database", "user", "pass")'
~~~

> **Note:** You'll need to execute this on the root directory of your site which is `$HOME/dsdeiz.github.com/` for me.

After the migration, the posts were created under the directory `_posts`. All I needed to do then was to just move them over to my subdirectory `blog`, added the variable `category: blog` for the **YAML Front Matter** on each post and made some changes on the posts for images, code highlighting and file attachments.

## Deploying the Site

I've used Github's Pages feature to host the site. Deployment was also very easy as Github has documented it [here](http://pages.github.com/). I only followed the instructions and waited for a few minutes for the site to be published. For updating the site, I only needed to push the changes and new files over to my repo.