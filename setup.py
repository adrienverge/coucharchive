# Copyright 2016 Adrien Vergé
# All rights reserved

from setuptools import setup


setup(
    name='coucharchive',
    version='1.0.0',
    author='Adrien Vergé',
    url='https://github.com/adrienverge/coucharchive',
    license='MIT',

    scripts=['coucharchive'],
    install_requires=[
        'CouchDB >=1.0.1',
    ],
)
