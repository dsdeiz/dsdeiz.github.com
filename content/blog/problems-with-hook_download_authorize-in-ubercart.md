---
kind: article
layout: post
excerpt: ''
title: Problems with hook_download_authorize in Ubercart
created_at: May 11 2010
tags: 
---
My task involved to limit the number of downloads to 1 but with an exemption for those with a specific role or a so-called "credit". I've used <code>hook_download_authorize()</code> to try this one out.

The first problem I encountered was that if you do a <code>return FALSE</code> as what the [documentation](http://api.ubercart.org/api/function/hook_download_authorize/2) mentioned, it would return the error __"A hook denied your access to this file. Please contact the site administrator if this message has been received in error."__ based on this section of the code:

~~~ php
<?php
//Check any if any hook_download_authorize calls deny the download
foreach (module_implements('download_authorize') as $module) {
  $name = $module .'_download_authorize';
  $result = $name($user, $file_download);
  if (!$result) {
    return UC_FILE_ERROR_HOOK_ERROR;
  }
}
~~~

The second problem I've encountered is that if you wish to create some validations that are called during that hook, all validations need to be passed rather than just an OR since in my problem, there are other options that lets you download the files if you failed one.

I did not set any __Download Limits__ under the _File Download Settings_. What I did then was this:

~~~ php
<?php
define('MYMODULE_DOWNLOAD_LIMIT', 1) // Need to fake the download limit.

function mymodule_download_authorize($user, $file_download) {
  if (in_array('Unlimited Downloads Role', array_values($user->roles))) {
    return TRUE;
  }
  else {
    // I've used Userpoints for the Credit part.
    if (userpoints_get_current_points($user->uid) >= 1 && $file_download->accessed >= variable_get('mymodule_download_limit', MYMODULE_DOWNLOAD_LIMIT)) {
      return TRUE;
    }
    else {
      if ($file_download->accessed < variable_get('mymodule_download_limit', MYMODULE_DOWNLOAD_LIMIT)) {
        return TRUE;
      }
      else {
        drupal_set_message(t('Download limit has been reached.', 'error'));
        return FALSE;
      }
    }
  }
}
~~~

Works fine but seems like a failed logic. Any suggestions much appreciated. :D

__Update:__ For the "A hook has denied..." message problem,  [rszrama](http://drupal.org/user/49344) (a developer of [Ubercart](http://www.ubercart.org/)) has suggested to me to simply replace the message using [String Overrides](http://drupal.org/project/stringoverrides) since the messages are being wrapped around <code>t()</code>.