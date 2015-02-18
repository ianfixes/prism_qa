from setuptools import setup, find_packages
import io
import os

import vivisector

here = os.path.abspath(os.path.dirname(__file__))

# http://www.jeffknupp.com/blog/2013/08/16/open-sourcing-a-python-project-the-right-way/
def read(*filenames, **kwargs):
    encoding = kwargs.get('encoding', 'utf-8')
    sep = kwargs.get('sep', '\n')
    buf = []
    for filename in filenames:
        with io.open(filename, encoding=encoding) as f:
            buf.append(f.read())
    return sep.join(buf)

long_description = read('README.md', 'CHANGES.md')

setup(
    name='vivisector',
    version=vivisector.__version__,
    url='https://github.com/ifreecarve/vivisector',
    license='Apache Software License',
    author='Ian Katz',
    author_email='ifreecarve@gmail.com',
    description='A tool for comparing design spec images with various implementation images'
    long_description=long_description,
    packages=['vivisector'],
    include_package_data=True,
    platforms='any',
    classifiers = [
        'Programming Language :: Python',
        'Natural Language :: English',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: Apache Software License',
        'Operating System :: OS Independent',
        'Topic :: Software Development :: Libraries :: Python Modules',
        ],
)
