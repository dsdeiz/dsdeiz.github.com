---
kind: article
layout: post
excerpt: ''
title: URL Shortening Custom Module
created_at: Apr 13 2010
tags: 
- drupal
---
I first tried using the modules [Short URL](http://drupal.org/project/shorturl) and [Shorten URLs](http://drupal.org/project/shorten) but I believe the module __Short URL__ is currently on its early stages.

I've decided to create a custom module for our project but basing it on the modules above. Unfortunately, the module isn't an API like __Short URL__. It was a combination of both in which it provides a UI for shortening URLs and records them.

I started with how the module redirects the URLs when it encounters one from the record. The __Short URL__ implemented the <code>hook_init()</code> to do this. This is somewhat what I was able to come up with based on the __Short URL__ module:

~~~ php
<?php
/**
 * Implementation of hook_init().
 */
function url_shorten_init() {
  $token = arg(0); // Retrieve 1st segment of the URL.
  $long_url = NULL;

  if (!empty($token)) {
    $data = db_fetch_object(db_query("SELECT id, long_url FROM {url_shorten} WHERE short_url = '%s';", $token));

    if (!empty($data)) {
      $record = new stdClass();
      $record->sid = $data->id;
      $record->referer = (isset($_SERVER['HTTP_REFERER'])) ? $_SERVER['HTTP_REFERER'] : '';
      $record->date = time();
      $record->ip_address = ip2long(ip_address());

      drupal_write_record('url_shorten_stats', $record);
      drupal_goto($data->long_url, NULL, NULL, 301);
    }
  }
}
~~~

The code <code>drupal_goto()</code> is the one handling the redirect. I then did the UI for shortening URLs in which it makes use of a function for shortening. This was the function that I was able to copy from [this page](http://www.bytemycode.com/snippets/snippet/579/):

~~~ php
<?php
/**
 * Generate a string with url_shorten_maxlength alpha characters. Snippet was taken
 * from http://www.bytemycode.com/snippets/snippet/579/.
 */
function url_shorten_generate_code($length) {
  $code = '';

  // Recreate length to have different number of 
  // characters. 3 would be the minimum length.
  $new_length = rand(3, $length);

  for ($i = 0; $i < $new_length; $i++) {
    $code .= rand(0, 1) ? chr(rand(65, 90)) : chr(rand(97, 122));
  }

  // Check if the generated code already exists.
  db_query("SELECT id FROM {url_shorten} WHERE short_url = '%s'", $code);

  if (db_affected_rows() != 0) {
    url_shorten_generate_code($length);
  }
  else {
    return $code;
  }
}
~~~

It simply creates a string depending on the <code>$length</code> that is being generated randomly. The characters generated are being randomly picked from the ASCII table in which 65-90 are alpha characters in uppercase and 97-122 in lowercase. It then calls the function if the generated code already exists.

As for the UI, it simply provides a textfield for the __Long URL__ and another textfield for the __Short URL__ which is optional. I've also implemented the tagging feature taken from the Taxonomy core module. It was the <code>taxonomy_autocomplete()</code> that I made use of. I was able to come up (not really come up but copied :D) with this:

~~~ php
<?php
function url_shorten_autocomplete($string = '') {
  $arr = drupal_explode_tags($string);

  $last_string = trim(array_pop($arr));
  $matches = array();
  if ($last_string != '') {
    $result = db_query_range("SELECT tag FROM {url_shorten_tags} WHERE LOWER(tag) LIKE LOWER('%%%s%%')", $last_string, 0, 10);
    $prefix = count($arr) ? implode(', ', $arr) .', ' : '';

    while ($row = db_fetch_object($result)) {
      $matches[$prefix . $row->tag] = check_plain($row->tag);
    }
  }

  drupal_json($matches);
}
~~~

I've added some minor features e.g. records referrer and IP address for every redirect. Most are copied from other codes but I think their combination still provided a good URL Shortener. :bigsmile:
