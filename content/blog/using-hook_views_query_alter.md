---
kind: article
layout: post
excerpt: ''
title: Using hook_views_query_alter
created_at: Sep 20 2011
tags: 
- drupal
- views
---
There are times that you might want to alter the query that the Views module generates. My problem was to include an attribute filter for products from the [Ubercart](http://www.ubercart.org/) module. [uc_views](http://drupal.org/project/uc_views) might be able to do the trick although filters for product attributes were only for products that have already been order. There is also a [patch](http://drupal.org/node/651036) available although I didn't make use of it as I only needed something simple. I decided to use [hook_views_query_alter](http://views.doc.logrus.com/group__views__hooks.html#gf4d538493930fe0fa0ce6fb3bf42c156). It says to put your function `MODULENAME_views_query_alter` in __MODULENAME.views.inc__ although it seemed to have just been called in my __MODULENAME.module__.

In order to add a new table to join, you'll need to create a new `views_join` object. This is what I have for mine:

~~~ php
<?php
$join = new views_join;
$join->construct('uc_product_options', 'node', 'nid', 'nid');
~~~

Details related to `views_join` can be found under __views/includes/handlers.inc__. After this, I used the method `add_relationship` from the class `views_query` which can be found in __views/includes/query.inc__. Most functions for building a query can be found on this file, I believe. This is how my relationship was added:

~~~ php
<?php
// $join is the views_join object created above
$query->add_relationship('uc_product_options', $join, 'node');
~~~

Now that I have my relationship, I will be needing to add my __where__ clause. I only needed to append in the default group as it was only a simple clause. I have this:

~~~ php
<?php
$query->where[0]['clauses'][] = 'uc_product_options.oid = %d';
// I used GET for getting the value for an attribute
$query->where[0]['args'][] = $_GET['attribute'];
~~~

There are also times that you might want to group a clause. This is what I did for another view that I've altered the query:

~~~ php
<?php
$query->set_where_group('OR');
$query->add_where(1, 'baz = "baz"');
// Unfortunately, nested groups are not allowed
$query->add_where(1, '(foo = "%s" AND bar = "%s")', 'foo', 'bar');
~~~

And that's it, cheers! :D
