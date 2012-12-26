---
kind: article
layout: post
excerpt: ''
title: Upcoming Events Calendar View in Drupal
created_at: Nov 4 2010
tags: 
- drupal
---
Here's what I have when I worked on an Event feature for a site. I first tried the [Event](http://drupal.org/project/event) module although it wasn't flexible enough to accomplish some of the things I needed. The modules I finally used (with their specific versions) were:

* [Calendar 6.x-2.2](http://drupal.org/project/calendar)
* [CCK 6.x-2.8](http://drupal.org/project/cck)
* [Date 6.x-2.6](http://drupal.org/project/date)
* [Views 6.x-2.11](http://drupal.org/project/views)

For my __Event__ content type, I just have the usual fields for a node with a __datestamp__ as a _CCK date field_. And for my __Upcoming Events Calendar__ view, I simply cloned the __Calendar__ view that came with the __Calendar__ module and removed some of the displays. It did have an __Upcoming__ display although wasn't a calendar view. 

The "trick" that I somehow came up was to change the _method_ in the argument __Date: Date (node)__ to __AND__ rather than __OR__ so the query that would come out would somehow look like this `...AND ((DATE_FORMAT(FROM_UNIXTIME([date field]), '%Y-%m-%d') >= '2010-11-03') __AND__ ((DATE_FORMAT(FROM_UNIXTIME([date field]), '%Y-%m')...` instead of `...AND ((DATE_FORMAT(FROM_UNIXTIME([date field]), '%Y-%m-%d') >= '2010-11-03') __OR__ ((DATE_FORMAT(FROM_UNIXTIME([date field]), '%Y-%m')...`.

[Attached](http://dl.dropbox.com/u/24796303/blog/files/events-6.x-1.0.tar) is the exported feature. Cheers! :D
