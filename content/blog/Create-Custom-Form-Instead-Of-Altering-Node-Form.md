---
kind: article
layout: post
excerpt: ''
title: Create Custom Form Instead Of Altering Node Form
created_at: Sep 14 2012
tags: 
  - drupal
---
This a post to remind me to not alter the node form as much as possible, but instead create a custom form and save the node upon submission. Some issues I had trouble with:

* Field attach form isn't that flexible for altering.
* The node form becomes ugly for administrators that want to just create/edit a node due to form alterations.

The fields I have in the node type I'm trying to create are:

* Taxonomy term with a 'select' widget.
* Taxonomy term with the 'checkboxes' widget.
* 2 textfields for 'First name' and 'Last name'.
* Email field.
* Checkbox for agreement.

### Requirements:

1. Make the first taxonomy term field display its field image on a 'change' event; and only display child terms.
2. Second taxonomy term has some sort of a custom theme where it displays an image and description.
3. Make the 2 textfields and email address field only available for anonymous users.
4. All fields are required when submitting a new node.

### My solution:

I've implemented `hook_admin_paths()` to disable admin theme on node/add/content-type.

I've implemented `hook_field_widget_form_alter()` and added the `#ajax` property on the element. The structure of the terms are also in a format of 'parent' > 'children' so I had to generate a flat list of child terms to omit the parents. Since I've used `hook_field_widget_form_alter`, the node form to me looks ugly when trying to edit an existing node. I tried to add a condition to only do the alteration when the path is 'node/add/content-type' (since I don't have enough context) like so:

~~~ php
<?php
/**
 * Implements hook_field_widget_form_alter().
 */
function MY_FEATURE_field_widget_form_alter(...) {
  if (arg(0) == 'node' && arg(1) == 'content-type') {
    ...
  }
}
~~~

This creates a problem for the ajax function since the path becomes 'system/ajax'. So I had to remove it, and now the alteration affects all the places the field is located. This includes the field's settings form. xD

In `hook_field_widget_form_alter()`, I added a `#theme` property to display the images and description. In the theme function, I also made some alterations on the element. I wasn't able to do this on the widget form alter since the element didn't have the individual checkboxes in it.

I've altered the node form itself and set `#access` for each fields to `FALSE`. I've also set the `#access` to `FALSE` for the vertical tabs to hide them. Theme isn't really designed for admin purposes so vertical tabs didn't have much attention on styling. There was also another field that was created just for storing a value and shouldn't be accessible as well. Hid that field once again. Hah! :D

The email address field needs to be unique. I was able to do this with the [Field validation](http://drupal.org/project/field_validation) module. Error messages for the required fields need to be custom too. This was a problem for me since Drupal by default has the message "\[field_name\] field is required." and isn't changeable per field. Or perhaps I just don't know how. I've disabled the "Required field" on the remaining fields so I can just do my custom validation. I've implemented `hook_field_attach_validate()` to achieve this.

I've also implemented `hook_theme` for the node form since it needs to display some text.

### What I'll Do Next Time

I think a better way to do this is create a custom form. It might contain more codes but at least I have full control over the form. No need to hide fields and such. Validate handler would include the "required" fields and checking if the email address is unique. In the submit handler, make use of [Entity API's](http://drupal.org/project/entity) `entity_metadata_wrapper` to create the node. Also make use of templates rather than theme functions, it looks a bit messy when you have things like `$output = '<div>' . t('Foo') . '</div>'` in the theme function.
