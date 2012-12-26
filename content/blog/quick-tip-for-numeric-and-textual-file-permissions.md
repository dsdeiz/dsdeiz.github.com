---
kind: article
layout: post
excerpt: ''
title: Quick Tip for Numeric and Textual File Permissions
created_at: Mar 11 2011
tags: 
- linux
---
There are times that I would want to list the File permissions in the current working directory. To do this, I would use the `ls -l` command which lists the files and shows the [Textual representation](http://www.zzee.com/solutions/linux-permissions.shtml#zzee_link_3_1077830297) of file permissions. But for some reason I would want the [Numeric representation](http://www.zzee.com/solutions/linux-permissions.shtml#numeric) such as 777, 755, etc. In order to achieve this, you can simply do `stat -c "%a %n" *`. If you often use this you may want to add in your `.bashrc` this line:

~~~ bash
alias statls='stat -c "%a %n"'
~~~

Then reload your `.bashrc` by doing `. ~/.bashrc`. You can use the alias like so `statls *` or `statls dir/*`.

For changing permissions, you can do `chmod u+x file` and such. But if you want to also use Numeric format, you can simply remember this [format](http://www.zzee.com/solutions/linux-permissions.shtml#numeric) (the data on the table). Or, you can just remember `rwx` to be similar to `421` e.g. you want it to be `r--` so it's `4` or `r-x` so it's `5`. If you want the permission of the file `foo` to come out as something like `rwxr-xr-x`, you can do `chmod 755 foo`.

Cheers. :D
