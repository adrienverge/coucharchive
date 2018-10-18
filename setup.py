# Copyright 2016 Adrien Vergé
# All rights reserved

from setuptools import setup


setup(
    name='coucharchive',
    version='2.1.2',
    author='Adrien Vergé',
    url='https://github.com/adrienverge/coucharchive',
    license='MIT',
    description=('Create and restore backups of a whole CouchDB server, with '
                 'simple tar.gz files.'),

    scripts=['coucharchive'],
    install_requires=[
        'CouchDB >=1.0.1',
    ],
)
