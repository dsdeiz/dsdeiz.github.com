---
kind: article
layout: post
excerpt: ''
title: Installation Profile with Content
created_at: Feb 3 2013
tags:
  - drupal
---

Recently, I encountered a project that requires rebuilding a site over and over in order to test recent changes. There were a bunch of scripts that did this automatically. The scripts were bash and PHP scripts. The bash scripts consist of calling `drush` commands such as `drush en`, `drush si` and `drush scr`. The PHP scripts task were to import content, terms, and probably set some configurations. These PHP scripts are also the ones ran through `drush scr`. I didn't go through each line of the scripts but I think what they basically do is enable modules, import contents from a data source, copy some files over to `sites/default/files` and install Drupal.

While all these are cool and all (and works perfectly), I thought that there might be a 'Drupal way' to do it. The first thing that came to my mind to automate all these is to use [Installation Profiles](http://drupal.org/developing/distributions). Basically, include all needed modules in the profile's `.info` file and do the importing on an added task.

These are the things I did:

1. Create sample content types and export these through features.
2. Export CSV files and images.
3. Create a migration class using [Migrate](http://drupal.org/project/migrate) module.
4. Add a new task in the profile to process the import created in the previous step.

The first step is simple. I created 3 content types namely __Pants__, __Shirt__, and __Product__. __Pants__ and __Shirts__ contain the fields _Image_ (created automatically when using the _Standard_ profile) and _Price_. The two content types also contain fields that are specific to each of them e.g. color for __Shirt__ and size for __Pants__. __Product__ content type has a multi-value field called _Items_. This field is an [entityreference](http://drupal.org/project/entityreference) that accepts the bundles __Pants__ and __Shirt__.

For the second step, I used [Views data export](http://drupal.org/project/views_data_export) to create the CSV export. I messed up the field names and values though so I had to modify each exported CSV file.

The third step is quite tricky since I don't use the Migrate module that much. It's quite powerful though. I created three migration classes - one for each content type. I had simple content types so the migration classes were a bit easy to create.

The fourth step is to create an installation profile. This was my first time creating one so I did some researches before proceeding. My `.install` file basically just calls `standard_install()`. It only contains this `hook_install` implementation:

~~~ php
<?php

/**
 * Implements hook_install().
 */
function myprofile_install() {
  // Do the installation from the Standard profile.
  include_once DRUPAL_ROOT . '/profiles/standard/standard.install';
  standard_install();
}
~~~

I encountered a few issues with this one though. I removed a few core modules from my `.info` file which caused the installation to break. Probably it's best to review what exactly `standard_install()` contains other than just calling it.

I then added one task for importing the content. I was advised to checkout [Commerce Kickstart](http://drupal.org/project/commerce_kickstart) distribution since it has a 'demo' task which does the importing. I simply just investigated what was defined in `commerce_kickstart_import_content()` and `migrate_ui_batch()`.

So yeah, that's just it. :D I did a few re-installations before I got the Installation Profile to work. This works for simple tasks though I'm not sure how well it would when it comes to a large Drupal application. You can download the profile [here](https://www.dropbox.com/s/8eaemxweacygg7k/myprofile.tar.gz?dl=1). Boom! 8-)
