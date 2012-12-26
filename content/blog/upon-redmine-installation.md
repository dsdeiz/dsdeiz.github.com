---
kind: article
layout: post
excerpt: ''
title: Upon Redmine Installation
created_at: Jul 28 2010
tags: 
---
Recently I stumbled upon an [entry](http://www.cyberciti.biz/tips/open-source-project-management-software.html) from [nixCraft](http://www.cyberciti.biz/) about Web-Based [Project Management Software](http://en.wikipedia.org/wiki/Project_management_software). The one that got my attention at first was [Trac](http://trac.edgewall.org/) as it was the tool we are using in our projects and that it was written in [Python](http://www.python.org/) (a programming language I was very much interested to learn but didn't have the time; and was too complicated for me :P). I also wanted to integrate [Git](http://git-scm.com) with __Trac__. I then found an entry from [Stack Overflow](http://stackoverflow.com/questions/623130/git-and-trac-or-similar) in which the "best" answer was to use [Redmine](http://www.redmine.org/). It's a bit new to me so I decided to give it a try.

##Installation##

It was a good thing that there was a [wiki](http://wiki.archlinux.org/index.php/Redmine_setup) about setting up __Redmine__ in __Arch Linux__. These were the steps I did:

1. `pacman -Rd ruby` (I had __gVim__ installed which I believe makes use of Ruby)
2. `slurpy -d ruby1.8` (I have [slurpy](http://aur.archlinux.org/packages.php?ID=28285) instead of __yaourt__) and then did the usual `makepkg` and `pacman -U package`.
3. `slurpy -d rubygems1.8` and once again did the `makepkg` and `pacman -U package`.
4. Then followed the rest of the guide for [Ruby 1.8 Environment](http://wiki.archlinux.org/index.php/Redmine_setup#Ruby_1.8_Environment) (I've also invoked the commands that were optional) including installation of MySQL gem. I wanted to use [SQLite](http://www.sqlite.org/) although was getting an error `ERROR:  While executing gem ... (OptionParser::InvalidOption)  invalid option: --with-sqlite3-include=/usr/include` and had no time to find a fix for it. Also, upon installation of __rails__ with __gem__, I've encountered a bunch of _No definition for xyz_ errors in which after researching was just about the documents.
5. `slurpy -d redmine-mysql-git`, `makepkg`, and `pacman -U package` (I've also modified the __PKGBUILD__ as mentioned in the guide)
6. Then followed the guide for [Create the Default Redmine DB Structure](http://wiki.archlinux.org/index.php/Redmine_setup#Create_the_Default_Redmine_DB_Structure).
7. And finally did `script/server -e production` under __/opt/redmine__.

I then visited __http://hostname:3000/__. I had Redmine up and running in no less than __45 minutes__. Sweet! 8)

##Configuration##

Since I really wanted to test out __Git__, I then immediately followed the guide from __Redmine__ on configuring repositories specifically for [Git](http://www.redmine.org/wiki/redmine/RedmineRepositories#Git-repository).

##Screenshots##

Screenshots for my __Redmine__ installation :D:

[<img src="http://dl.dropbox.com/u/24796303/blog/Pathauto%20Batch%20-%20Overview%20-%20Redmine_1280237854127.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/Pathauto%20Batch%20-%20Overview%20-%20Redmine_1280237854127.png)

[<img src="http://dl.dropbox.com/u/24796303/blog/Pathauto%20Batch%20-%20pathauto_batch.module%20-%20Redmine_1280237875077.png" width="383" />](http://dl.dropbox.com/u/24796303/blog/Pathauto%20Batch%20-%20pathauto_batch.module%20-%20Redmine_1280237875077.png)

I still haven't played much with Redmine though. I would really like __Syntax Highlighting__ for __.module__ files but haven't look into it yet. Redmine++! Oh, and the demo for __Redmine__ can be found [here](http://demo.redmine.org/). :D