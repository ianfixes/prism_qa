[![Gem Version](https://badge.fury.io/rb/prism_qa.svg)](https://rubygems.org/gems/prism_qa)

# Prism (QA)

Prism helps you split your apps and your design document into visible components.  Its purpose is to enable designers to be an effective part of a QA / Continuous Integration process.

Prism provides a framework for generating reports that compare design "master" images to actual screenshots from various implementations.


## Motivation

* Engineers can't be expected to maintain the quality of the UX design any more than the designers can be expected to maintain the quality of the app code.

* Making engineers the gatekeepers of app design (being that they are gatekeepers of the source code) is at best unfair and at worst unwise.  The skill sets are different, and complementary -- we need to use both, and a way for them to work toether.

* If designers are pointing out problems in the design of a released build (nightly or otherwise), they are too late -- perpetually.  They need to be involved during the pull request phase, doing the design equivalent of a code review.


## Installation

The most straightforward way is to install the gem.

`$ gem install prism_qa`

Bundler is the preferred method.

`gem 'prism_qa', '~> 0.2', '>= 0.2.0'`


## Prism Requirements

You supply the input images.  You supply the output images.  You specify how they are related by defining a set of IDs and tagging the images with the appopriate ID.

Prism really doesn't do much; it simply generates reports.


## Setup

See the [example implementations](examples/) for information on how to set up a basic Prism QA script.
