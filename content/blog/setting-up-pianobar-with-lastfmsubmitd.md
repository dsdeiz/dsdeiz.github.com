---
kind: article
layout: post
excerpt: ''
title: Setting Up Pianobar with lastfmsubmitd
created_at: Dec 15 2010
tags: 
- linux
- pianobar
---
[Pandora](http://www.pandora.com/) is a really neat, free internet radio service. I am using a console client for __Pandora__ which is [Pianobar](https://github.com/PromyLOPh/pianobar). It's lacking one feature that I wanted though in which it would scrobble the music it plays over to [Last.fm](http://www.last.fm/). Previously it did support scrobbling to __Last.fm__ but has been [moved](https://github.com/PromyLOPh/pianobar/issues/issue/21). The author said you can make use an external scrobbler.

For my external scrobbler I've used [lastfmsubmitd](http://www.red-bean.com/decklin/lastfmsubmitd/). To set it up, you'll first need to have a script that would handle the events for __Pianobar__. You can use the [eventcmd.sh](https://github.com/PromyLOPh/pianobar/blob/master/contrib/eventcmd.sh) script under __contrib__ from Pianobar's source. For __lastfmsubmitd__, you can simply uncomment the lines from `songfinish` to `;;`. Leave the `scrobbler-helper ...` commented (or remove) since it would be replaced with __lastfmsubmitd__. What I have in my `eventcmd.sh` script is this:

~~~ bash
  songfinish)
      # scrobble if 75% of song have been played, but only if the song hasn't
      # been banned
      if [ -n "$songDuration" ] &&
              [ $(echo "scale=4; ($songPlayed/$songDuration*100)>50" | bc) -eq 1 ] &&
              [ "$rating" -ne 2 ]; then
        /usr/lib/lastfmsubmitd/lastfmsubmit --artist "$artist" --title "$title" --album "$album" --length "$((songDuration/1000))"
      fi
      ;;
~~~

Once you have your `eventcmd.sh` script set up, you simply need to add this in your __config__:

~~~ bash
event_command = /path/to/eventcmd.sh
~~~

Now that that's set up, you can run the lastfmsubmitd daemon. If you're on __Arch Linux__, you can do `sudo /etc/rc.d/lastfmsubmitd start`, then finally start `pianobar`.

Cheers! :D
