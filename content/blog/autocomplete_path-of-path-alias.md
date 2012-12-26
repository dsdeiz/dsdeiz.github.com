---
kind: article
layout: post
excerpt: ''
title: ! '#autocomplete_path of Path Alias'
created_at: Mar 11 2010
tags: 
---
I was trying to implement the <code>#autocomplete_path</code> to be used to autocomplete URL aliases. I believe this is somewhat a short introduction to doing autocomplete in your textfields when using the [Form API](http://api.drupal.org/api/drupal/developer--topics--forms_api_reference.html).

~~~ php
<?php
function example_autocomplete() {
  $items = array();
  $i = 2;
  while(arg($i))
  {
    $items[] = arg($i);
    $i++;
  }
  $string = implode('/', $items);

  $matches = array();
  if ($string) {
    $result = db_query_range("SELECT dst FROM {url_alias} WHERE LOWER(dst) LIKE LOWER ('%s%%')", $string, 0, 10);
    while ($destination = db_fetch_object($result)) {
      $matches[$destination->dst] = check_plain($destination->dst);
    }
  }

  drupal_json($matches);
}
?>
~~~

What it basically does is take advantage of the URL and using the [arg](http://api.drupal.org/api/function/arg) function in Drupal.

You'll then need to specify on your [hook_menu](http://api.drupal.org/api/function/hook_menu/6) this:

~~~ php
<?php
function example_menu() {
  $items['example/autocomplete'] = array(  
    'title' => 'Example autocomplete',
    'page callback' => 'example_autocomplete',  
    'access callback' => TRUE,
    'type' => MENU_CALLBACK,
  );

  return $items;
}
?>
~~~

You can try visiting the URL <code>example.com/example/autocomplete/path/to/autocomplete</code> to see if it indeed returns the expected URL in json format.

Once you are done, you can now make use of your <code>#autocomplete_path</code> in your form. For example:

~~~ php
<?php
  $form['example'] = array(
    '#type' => 'textfield',
    '#title' => t('Example Autocomplete Path'),
  );

  if (module_exists('path')) {
    $form['example']['#autocomplete_path'] = 'example/autocomplete';
  }
?>
~~~

You'll be able to find more information [here](http://api.drupal.org/api/drupal/developer--topics--forms_api_reference.html#autocomplete_path).

Thanks to [Jay Matwichuk](http://drupal.org/user/324696) for providing me a solution as autocompletion of URL aliases is somewhat tricky.