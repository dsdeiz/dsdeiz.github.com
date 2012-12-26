---
kind: article
layout: post
excerpt: ''
title: Pathauto Batch Custom Module
created_at: May 31 2010
tags: 
- drupal
---
I recently just started studying about Drupal's [Batch API](http://api.drupal.org/api/group/batch/6). I've decided to duplicate [Pathauto Bulk Update](http://drupal.org/project/pathauto) but using the __Batch API__ in order to bypass the limit you set for Pathauto Bulk Update. Mostly are based on the samples from the [API reference](http://api.drupal.org/api/group/batch/6) and the [Handbook](http://drupal.org/node/180528).

For my __.info__ file, I simply added the dependency for pathauto like so, <code>dependencies[] = "pathauto"</code>.

For the __.module__ file specifically the Batch API section, I have this:

~~~ php
<?php
function pathauto_batch_form_submit($form, &$form_state) {
  $batch = array(
    'title' => t('Generating Aliases'),
    'finished' => 'pathauto_batch_finished',
    'progress_message' => t('Processed @current out of @total.'),
    'error_message' => t('Pathauto Batch has encountered an error.'),
  );

  $types = array_filter($form_state['values']['node_types']);

  foreach ($types AS $type) {
    $batch['operations'][] = array('pathauto_batch_node', array($type));
  }

  batch_set($batch);
}

function pathauto_batch_node($type, &$context) {
  if (empty($context['sandbox'])) {
    $context['sandbox']['progress'] = 0;
    $context['sandbox']['current_node'] = 0;
    $context['sandbox']['max'] = db_result(db_query("SELECT COUNT(DISTINCT nid) FROM {node} WHERE type = '%s'", $type));
  }

  if ($context['sandbox']['max'] == 0) {
    $context['message'] = t('No nodes found belonging to %type.', array('%type' => $type));
    $context['finished'] = 1;
  }
  else {
    $placeholders = array();
    $limit = 5;
    $result = db_query_range("SELECT nid FROM {node} WHERE nid > %d AND type = '%s' ORDER BY nid ASC", $context['sandbox']['current_node'], $type, 0, $limit);

    while ($row = db_fetch_array($result)) {
      $node = node_load($row['nid'], NULL, TRUE);
      $placeholders = pathauto_get_placeholders('node', $node);
      $src = "node/$node->nid";

      if (pathauto_create_alias('node', 'update', $placeholders, $src, $node->nid, $node->type, $node->language) != NULL) {
        $context['results'][] = $node->title .' : '. drupal_get_path_alias('node/' . $node->nid);
      }

      $context['sandbox']['progress']++;
      $context['sandbox']['current_node'] = $node->nid;
    }

    if ($context['sandbox']['progress'] != $context['sandbox']['max']) {
      $context['finished'] = $context['sandbox']['progress'] / $context['sandbox']['max'];
    }
  }
}

function pathauto_batch_finished($success, $results, $operations) {
  if ($success) {
    $message = format_plural(count($results), 'One alias generated.', '@count aliases generated.');
  }
  else {
    $message = t('Finished with an error.');
  }
  drupal_set_message($message);
}
~~~


This obviously isn't perfect as this is my first attempt but seems to work the way I want it to be. :bigsmile:

You can download the module [here](http://dl.dropbox.com/u/24796303/blog/files/pathauto_batch.tar.gz). Hope this helps! ;-)
