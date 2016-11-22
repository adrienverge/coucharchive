# Copyright 2016 Adrien Vergé
# All rights reserved

from distutils.core import setup


setup(
    name='coucharchive',
    version='1.0.0',
    author='Adrien Vergé',
    url='https://github.com/adrienverge/coucharchive',

    scripts=['coucharchive'],
    requires=[
        'CouchDB',
    ],
)
