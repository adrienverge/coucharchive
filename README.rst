coucharchive
============

Use coucharchive to create and restore backups of a whole CouchDB server /
cluster of servers, or to simply replicate it to another server / cluster.

Backup archives are saved as single tar.gz file, and can be imported later to
any other CouchDB server.

Useful for making backups, or replicating your database to a secondary test
environment.

Installation
------------

Using pip:

.. code:: bash

 $ pip3 install --user coucharchive

Examples
--------

Make a backup archive from a running server:

.. code:: bash

 $ coucharchive create --from http://root:password@server.com:5984 \
                       --output test.tar.gz

Restore this archive to another server:

.. code:: bash

 $ coucharchive restore --to http://other-server.com:5984 \
                        --input test.tar.gz

Simply load a backup in a temporary CouchDB server:

.. code:: bash

 $ coucharchive load -i test.tar.gz
 Launched CouchDB instance at http://root:L76mqQE5fE@localhost:38095

Replicate from a CouchDB installation to another one:

.. code:: bash

 $ coucharchive replicate --from http://root@server.com:5984 \
                          --to http://admin@other-server.com:5984

Slow down replication (to decrease servers load) so that it runs in one hour:

.. code:: bash

 $ coucharchive replicate --from http://root@server.com:5984 \
                          --to http://admin@other-server.com:5984 \
                          --ideal-duration 3600

Don't pass credentials on the command line:

.. code:: bash

 $ coucharchive create --from private.server.com:5984 -o test.tar.gz
 CouchDB admin for private.server.com: root<ENTER>
 CouchDB password for root@private.server.com: p4ss<ENTER>

How do archives work?
---------------------

coucharchive spawns a local CouchDB instance locally, using a temporary directory
for storing data and configuration.

When dumping, it replicates your source CouchDB server (i.e. replicates all dbs,
including `_users`) to the fresh local one, then saves and compresses its data
to a tar.gz archive.

When loading, it uncompresses the archive, has the local CouchDB instance use it
as its data, then replicates to your remote CouchDB server.

Go further
----------

For repetitive backups, you can use a config file:

.. code:: bash

 $ cat config.ini
 [source]
 url = http://root:password@my-server:5984

 [replication]
 ignore_dbs = db_to_ignore, other_useless_db

 $ coucharchive -c config.ini create -o test.tar.gz

To save a backup on AWS S3 and notify somebody via email:

.. code:: bash

 $ aws s3 cp /tmp/archive.tar.gz s3://my-backups/archive.tar.gz
 $ cat >/tmp/email.txt <<EOM
 Subject: New backup saved on S3

 A CouchDB backup called archive.tar.gz was successfully created and pushed
 on Amazon S3.
 EOM
 $ sendmail user@example.com </tmp/email.txt
