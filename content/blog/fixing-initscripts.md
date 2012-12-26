---
kind: article
layout: post
excerpt: ''
title: Fixing Initscripts
created_at: Feb 12 2010
tags:
- linux
- initscripts
---
I had a problem yesterday with my [Archlinux](http://archlinux.org) installation. Everything was just going fine until I restarted my computer. Arch was trying to load the daemons and modules but can't seem to do it as there was an error saying __"Read-only filesystem"__.

I was thinking to simply remount it after Arch gives me a prompt though it never did.

After some few research and inquiries in the __#archlinux__ channel in __Freenode__, I was able to resolve this. The solution an arch user gave me:

1. Used an Archlinux Live CD (mine was in a USB drive) to mount my Archlinux system that was not booting.
2. Put <code>sleep 60</code> in __/etc/rc.sysinit__ just before the line <code>status "Mounting Root Read-only" /bin/mount -n -o remount,ro /</code> so when I reboot it would give me 60 seconds to scroll up (Shift + PgUp) and check for errors. This wasn't necessary for me since boot just hangs after the last daemon was being ran.
<!--break-->
I had a problem yesterday with my [Archlinux](http://archlinux.org) installation. Everything was just going fine until I restarted my computer. Arch was trying to load the daemons and modules but can't seem to do it as there was an error saying __"Read-only filesystem"__.

I was thinking to simply remount it after Arch gives me a prompt though it never did.

After some few research and inquiries in the __#archlinux__ channel in __Freenode__, I was able to resolve this. The solution an arch user gave me:

1. Used an Archlinux Live CD to mount my Archlinux system that was not booting.
2. Put <code>sleep 60</code> in __/etc/rc.sysinit__ just before the line <code>status "Mounting Root Read-only" /bin/mount -n -o remount,ro /</code> so when I reboot it would give me 60 seconds to scroll up (Shift + PgUp) and check for errors. This wasn't necessary for me since boot just hangs after the last daemon was being ran.

I was able to find out that the error was <code>INIT: Couldn't execute /etc/rc.sysinit</code>. Also probably means that even if I modified __/etc/rc.sysinit__ for the 60-second delay, it still wouldn't be executed. Solution given to me was to reinstall the __Initscripts__ package.

1. Used an Archlinux Live CD again to mount my messed up Archlinux system.
2. Issued the command <code>pacman --root /mnt --dbpath /mnt/var/lib/pacman -S initscripts</code>.

Then all was good! :party: I have no idea what caused the change of the file beforehand though.