---
kind: article
layout: post
excerpt: ''
title: Add a "Save and continue editing" button in a Node Edit Form
created_at: Sep 8 2010
tags: 
  - drupal
---
There are times that I would somehow want to continue editing a node rather than view it after saving. Here's a little snippet that would achieve what I needed.

~~~ php
<?php
function module_form_alter(&$form, &$form_state, $form_id) {
  if (isset($form['type']) && isset($form['#node']) && $form['type']['#value'] .'_node_form' == $form_id) {
    $form['buttons']['continue_edit'] = array(
      '#type' => 'submit',
      '#value' => t('Save and continue editing'),
      '#submit' => array('node_form_submit', '_module_continue_edit'),
    );
  }
}

function _module_continue_edit($form, &$form_state) {
  $form_state['redirect'] = 'node/' . $form_state['nid'] . '/edit';
}
~~~

A contributed module that would do this better would be [Save & Edit](http://drupal.org/project/save_edit).
