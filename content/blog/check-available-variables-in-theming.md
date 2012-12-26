---
kind: article
layout: post
excerpt: ''
title: Check Available Variables in Theming
created_at: Mar 18 2010
tags: 
---
First off, you can probably check out [this entry](http://www.thingy-ma-jig.co.uk/blog/02-10-2007/hugely-useful-hugely-undocumented) which provides four functions to look at upon developing. You would need the [Devel](http://drupal.org/project/devel) module for this.

I personally use <code>dsm</code> though I believe it simply makes use of the <code>dpm</code> function from devel. I am not certain if this is the _proper_ way of checking the available variables when theming. You could first take a look at the template files e.g. [page.tpl.php](http://api.drupal.org/api/drupal/modules--system--page.tpl.php/6) or [node.tpl.php](http://api.drupal.org/api/drupal/modules--node--node.tpl.php/6) to check what variables are available for you. I also sometimes add the code below to check for the available variables in a template file. 

~~~ php
<?php dsm(get_defined_vars()); ?>
~~~

[dsm](http://drupalcontrib.org/api/function/dsm/6) I believe print outs the array provided by [get_defined_vars](http://php.net/manual/en/function.get-defined-vars.php) onto the message area.

You could also make use of <code>krumo_ob</code> by simply adding the code below to the location you'd wish to print out the variables.

~~~ php
<?php print krumo_ob(get_defined_vars()); ?>
~~~

Works perfectly for me. :bigsmile: