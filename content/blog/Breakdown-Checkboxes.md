---
kind: article
layout: post
excerpt: ''
title: Breakdown checkboxes in FAPI and '#disabled' Property
created_at: Dec 12 2012
tags: 
---
If you wish to set some FAPI properties of the checkboxes generated with `#type => 'checkboxes'` individually, you'll need to breakdown the checkboxes first. There are two ways to do this that I am aware of. One is to add a `#process` callback to the form element, and another is to set each `#options` as a separate element e.g. `$form['checkboxes'][{#option-key}]`.

For adding the `#process` callback, you can do it like this:

~~~ php
<?php
$form['checkboxes'] = array(
  '#type' => 'checkboxes',
  '#options' => $options,
  '#process' => array('some_callback'),
  ...
)
~~~

You'll then need to break the checkboxes on the `#process` callback using `form_process_checkboxes()` like this:

~~~ php
<?php

function some_callback($element) {
  $element = form_process_checkboxes($element);
  foreach (element_children($element) as $key) {
    // You now have access to each '#option' properties.
    $element[$key]['#default_value'] = 'foo';
    print $element[$key]['#title'];
  }

  return $element;
}
~~~

If you are altering an existing form, you might want to add the `#process` callback into the array rather than doing `array('some_callback')`. See the note [here](http://api.drupal.org/api/drupal/developer%21topics%21forms_api_reference.html/7#process). Also, by this time, the element might have already gone through the `form_process_checkboxes`, so there is no need to call that function.

The other way is to set each `#options` during form generation or alteration. This is thanks to `form_process_checkboxes`. I don't think this is mentioned in the FAPI documentation but I was able to find this [comment](http://drupal.org/node/342316#comment-4732130). To set each property for the checkbox on form generation or alteration, you can do it like this:

~~~ php
<?php

foreach ($form['checkboxes']['#options'] as $key) {
  $form['checkboxes'][$key]['#title'] = t('Foo');
  $form['checkboxes'][$key]['#default_value'] = t('Bar');
}
~~~

You won't be needing `form_process_checkboxes` with this method.

I'm not sure which one is the recommended way though I think both will work just fine. But the first method would probably be a bit longer.

For the `#disabled` property, one thing I noticed is when a checkbox is checked by default but has the `#disabled` property, the submitted value for that checkbox becomes 'empty'. I haven't found out why though. It might be somewhere in `form_type_checkbox_value()`. All I have is [this link](http://drupal.stackexchange.com/a/4137) which provided me a hint.