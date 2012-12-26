---
kind: article
layout: post
excerpt: ''
title: Bad Theming Job
created_at: Aug 9 2010
tags: 
---
I read last time about [Drupal Theming Nightmares](http://sotak.co.uk/blog/drupal-theming-nightmares-part-1) written by a [Drupalist](http://sotak.co.uk/about-me). It is somehow a series of the blogger's experience upon continuing the theming job started by another themer. If you know about theming in Drupal then your reaction would probably be similar to the comments.

I then recently checked one of the themes I've created and also found out that it had __a few__ (:P) mistakes too considering that I wasn't that familiar to theming when we've started this. This one is a subtheme from [Zen](http://drupal.org/project/zen) (at least the theme came from a decent base theme :P). A screenshot of the file structure follows:

[<img src="http://dl.dropbox.com/u/24796303/blog/2010-08-09-122419_1280x800_scrot.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/2010-08-09-122419_1280x800_scrot.png)

##Back up Files##

If you try to look at the files listed you'll see a file called `xxx1.css` and `xxx.css`, and `html-elements.css` and `html-elements.css.bak`. We were not using any [VCS](http://en.wikipedia.org/wiki/Revision_control) so I've decided to ask other themers to simply put the back up of the files they are modifying on the theme directory itself for reference and in case another I overwritten the files that another themer was modifying.

##Hardcoded Block Titles and Content##

There is a file there called `block-block-4.tpl.php`, it was designed specifically for the fourth block obviously. This is what it basically contains:

~~~ php
<?php
<h2 class="title">Title of the Block</h2>
...
<?php
   $video = theme('flowplayer', array(
  'clip' => array(
    'url' => '/path/to/video.flv',
    'autoPlay' => FALSE, // Turn autoplay off 
  ),
),'flowplayer', array(), theme('image', '/path/to/splash-image.png', 'Some description', 'Some description', NULL, FALSE));

    print $video;
?>
~~~

I'm not entirely sure why we've hardcoded the title and put the content on the template file. If I remember correctly, I must've thought that doing it on template files are pretty cool. Silly idea if you ask me now. I should have just done it by implementing a [hook_block](http://api.drupal.org/api/function/hook_block/6) or simply using the __PHP Input Filter__. Might as well change if I learn a better way to do this again.

##Page Specific Templates and Contemplate##

It's also a bit weird that we are creating different templates and at the same time using the [Contemplate](http://drupal.org/project/contemplate) module. Contemplate if I remember correctly allows administrators to define different templates through the admin UI.

##Undeleted Template Files##

We've also used this same theme on another website although we haven't deleted the template files that were specific to the other site. An example is `block-block-8.tpl.php` which is the same as `block-block-2.tpl.php`.

##Conclusion##

Not really that bad for a theme compared to the mistakes listed on the __Drupal Theming Nightmares__ blog entries :P. Still, it could use some improvements although we might not rewrite this as it works just fine :D. It isn't just the "Drupal Way" I believe. Although I'll try to remember these mistakes so as not to commit them again. 8)