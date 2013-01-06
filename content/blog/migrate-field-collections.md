---
kind: article
layout: post
excerpt: ''
title: Migrating Field Collections
created_at: Jan 6 2013
tags: 
  - drupal
  - migrate
---
[Field collection](http://drupal.org/project/field_collection) allows users to group fields. Basically, when you create a 'field collection' field, you are creating a `field_collection_item` bundle in which you can then add fields on it. This is nice but unfortunately the [migrate](http://drupal.org/project/migrate) module doesn't support this. I got this working though with the patch [here](http://drupal.org/node/1175082#comment-6833952). To apply the patch you can do this:

~~~ bash
cd /path/to/field_collection/
wget http://drupal.org/files/field_collection_migrate-entity_load-1175082-120.patch
patch -p1 < field_collection_migrate-entity_load-1175082-120.patch
~~~

There is a sample usage of the destination handler found at the beginning of the file `field_collection.migrate.inc`. Basically, you'll need to have a `host_entity_id` mapped for it to work. Here's a sample of how I used it. Sources are both from CSV files. I have a field called `field_sample_field_collection` which has a field `field_sample_terms`. The term ids on the CSV file are already migrated over. My CSV files are in these format:

~~~ text
nodes.csv
"nid","title"
1,Foo
2,Bar

field-collections.csv
"item_id","tids","nid"
"1","9, 7, 8","2"
"2","3, 4, 9","1"
~~~

`node.inc`:

~~~ php
<?php

class SampleBundleNodeMigration extends DynamicMigration {
  public function __construct() {
    parent::__construct();

    $this->description = t('Migrate nodes.');

    $this->source = new MigrateSourceCSV(
      drupal_get_path('module', 'field_collections_migrate') . '/csv/nodes.csv',
      array(),
      array('header_rows' => 1)
    );

    $this->destination = new MigrateDestinationNode('sample_bundle');

    $this->map = new MigrateSQLMap(
      $this->machineName,
      array(
        'nid' => array(
          'type' => 'int',
          'not null' => TRUE,
        )
      ),
      MigrateDestinationNode::getKeySchema()
    );

    $this->addSimpleMappings(array('title'));
  }
}
~~~

`field_collection.inc`:

~~~ php
<?php

class SampleFieldCollectionMigration extends DynamicMigration {
  public function __construct() {
    parent::__construct();

    $this->description = t('Migrate field collection entities.');
    $this->dependencies = array('SampleBundleNode');

    $this->source = new MigrateSourceCSV(
      drupal_get_path('module', 'field_collections_migrate') . '/csv/field-collections.csv',
      array(),
      array('header_rows' => 1)
    );

    $this->destination = new MigrateDestinationFieldCollection(
      'field_sample_field_collection',
      array('host_entity_type' => 'node')
    );

    $this->map = new MigrateSQLMap(
      $this->machineName,
      array(
        'item_id' => array(
          'type' => 'int',
          'not null' => TRUE,
        )
      ),
      MigrateDestinationFieldCollection::getKeySchema()
    );

    $this
      ->addFieldMapping('host_entity_id', 'nid')
      ->sourceMigration('SampleBundleNode');

    $this
      ->addFieldMapping('field_sample_terms', 'tids')
      ->separator(',')
      ->arguments(array('source_type' => 'tid'));
  }
}
~~~

Cheers! :D
