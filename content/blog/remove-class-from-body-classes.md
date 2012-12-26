---
kind: article
layout: post
excerpt: ''
title: Remove Class from Body Classes
created_at: Mar 8 2010
tags: 
- drupal
---
Removing a class from the variable `$body_classes` is very simple. All you need to do is make some changes on the variable in the `SUBTHEME_preprocess_page` function.

I have done this with a [Zen](http://drupal.org/project/zen) subtheme:

~~~ php
<?php
function SUBTHEME_preprocess_page(&$vars, $hook) {
  if {$node = menu_get_object()) {
    $vars['node'] = $node;
  }

  /*
   * Make some changes once the node type is 'full'. 'full' is the content
   * type I am using for pages with no sidebars.
   */
  if ($node->type == 'full') {
    $body_classes = explode(' ', $vars['body_classes']);
    $new_body_classes = array();

    // Remove from the array one-sidebar and sidebar-right if they exist.
    foreach($body_classes AS $val) {
      if ($val != 'one-sidebar' && $val != 'sidebar-right') {
        $new_body_classes[] = $val;
      }   
    }   

    // This is to make sure that the variables $right and $left don't have values.
    unset($vars['right']);
    unset($vars['left']);

    // Setup the new $body_classes variable.
    $vars['body_classes'] = implode(' ', $new_body_classes);
  }
}
~~~

Cheers! ;)
