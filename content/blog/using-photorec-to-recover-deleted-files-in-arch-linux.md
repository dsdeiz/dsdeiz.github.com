---
kind: article
layout: post
excerpt: ''
title: Using PhotoRec to Recover Deleted Files in Arch Linux
created_at: Aug 24 2010
tags: 
- linux
---
Recently I accidentally deleted my `xmonad.hs` file which I've worked on for so long. I had no back up or a Trash folder whatsoever. I searched for a file recovery software that would bring back my config file. I took a look at [Arch Linux's File Recovery](http://wiki.archlinux.org/index.php/File_Recovery) wiki to try out the ones they've listed.

The first software I tested was [Extundelete](http://extundelete.sourceforge.net/) unfortunately it seems to require me to unmount the device although the file resided on the same partition where my OS is so I didn't seem to work out for me.

I also tried searching for a Windows program to recover files from an [ext4](http://en.wikipedia.org/wiki/Ext4) partition but unfortunately never found one.

The next was [PhotoRec](http://www.cgsecurity.org/wiki/PhotoRec) which did it for me.

Here are some screenshots on the steps I did for recovering the deleted file (most are similar to the screenshots found in [PhotoRec's Step by Step guide](http://www.cgsecurity.org/wiki/PhotoRec_Step_By_Step)):

[<img src="http://dl.dropbox.com/u/24796303/blog/first.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/first.png)

[<img src="http://dl.dropbox.com/u/24796303/blog/second.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/second.png)

[<img src="http://dl.dropbox.com/u/24796303/blog/third.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/third.png)

[<img src="http://dl.dropbox.com/u/24796303/blog/fourth.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/fourth.png)

[<img src="http://dl.dropbox.com/u/24796303/blog/fifth.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/fifth.png)

[<img src="http://dl.dropbox.com/u/24796303/blog/sixth.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/sixth.png)

[<img src="http://dl.dropbox.com/u/24796303/blog/seventh.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/seventh.png)

[<img src="http://dl.dropbox.com/u/24796303/blog/eighth.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/eighth.png)

I'm not certain which to check in the __sixth step__ though. I've only selected __Free__ as I believe it would be fast searching there. In the __seventh step__, it was required to select a different partition to where to store the recovered files. After the search was complete you'll find the folders <strong>recup_dir.*</strong> in the directory to where you chose to save the recovered files. It would somehow look like this:

[<img src="http://dl.dropbox.com/u/24796303/blog/browser.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/browser.png)

I then just did a simple command to search for my `xmonad.hs` latest config file (I had `import Xmonad.Layout.Gaps` on my latest config):

~~~ bash
find . -name "recup_dir.*" -exec grep -iR "xmonad.layout.gaps" '{}' \;
~~~

Now I have my config back! 8) It wasn't really the latest one but rather the latest one recovered by __PhotoRec__. :D
