---
kind: article
layout: post
excerpt: ''
title: ! '&lt;span&gt; Tag in Primary Links in a Genesis Subtheme'
created_at: Feb 14 2010
tags: 
---
The codes on this post below would result to a markup like this in a [Genesis](http://drupal.org/project/genesis) subtheme:

~~~ html
<a href="/" title="Home" class="active"><span>Home</span></a>
~~~

First, you would need to edit the `template.php` file of your Genesis subtheme and add the codes below. For the `SUBTHEME_primary_links` function, you'll need to copy the  [theme_links](http://api.drupal.org/api/function/theme_links/6) function. You'll then need to make some slight modifications on the function.

~~~ php
<?php
function SUBTHEME_theme(&$existing, $type, $theme, $path) {
  $hooks = genesis_theme($existing, $type, $theme, $path);
  $hooks['primary_links'] = array(
    'arguments' => array('links' => NULL),
  );

  return $hooks;
}

function SUBTHEME_primary_links($links, $attributes = array('class' => 'links')) {
      ...
      /* Changes are on this section */
      if (isset($link['href'])) {
        $link['title'] = '<span class="link">' . check_plain($link['title']) . '</span>';
        $link['html'] = TRUE;
        // Pass in $link as $options, they share the same keys.
        $output .= l($link['title'], $link['href'], $link);
      }
      ...
  return $output;
}
?>
~~~

You'll then need to edit your `page-*.tpl.php` files specifically changing the `$primary_menu` with this:

~~~ php
<?php print theme('primary_links', $primary_links, array('class' => 'links primary-links')); ?>
~~~

Finally, you'll need to clear your cache by going to Administer &rarr; Site Configuration &rarr; Performance.

You'll might as well check these threads, [&lt;span&gt; In Primary Links][1] and [Add &lt;SPAN&gt; to primary links?][2].

[1]:http://drupal.org/node/112761
[2]:http://drupal.org/node/373901