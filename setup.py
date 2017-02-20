# Copyright 2016 Adrien Vergé
# All rights reserved

from setuptools import setup


setup(
    name='coucharchive',
    version='1.0.2',
    author='Adrien Vergé',
    url='https://github.com/adrienverge/coucharchive',
    license='MIT',
    description=('Dump/restore a whole CouchDB server contents to/from a '
                 'single tar.gz file.'),

    scripts=['coucharchive'],
    install_requires=[
        'CouchDB >=1.0.1',
    ],
)
