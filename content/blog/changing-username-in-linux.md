---
kind: article
layout: post
excerpt: ''
title: Changing Username in Linux
created_at: Apr 16 2010
tags: 
---
I tried changing my username on my Arch Linux install but somewhat caused a problem. I did the usual <code>usermod -l new_login old_login</code> and renamed my HOME directory. I followed the instructions from [this page](http://www.cyberciti.biz/faq/howto-change-rename-user-name-id/).

I tried logging in with the new username but for some reason, it wasn't logging me in. I was not able to spot any "useful information" in the logs - _auth.log_ and _user.log_. 

Someone advised me to login from the root shell by calling the command <code>login</code>. This then gave me the error message. I obviously didn't change my HOME directory correctly as it was pointing to /home/old_login and goes to / as it can't find the directory (since I've moved it :bigsmile:). I misunderstood the statement below:

> ...In particular, the user's home directory name should probably be changed to reflect the new login name.

So I guess the way to change the username and _renaming the HOME directory_ would be <code>usermod -l new_login -d /home/new_login/ -m old_login</code>. I gotta read the man pages more. :D