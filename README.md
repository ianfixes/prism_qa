[![Gem Version](https://badge.fury.io/rb/vivisector.svg)](https://rubygems.org/gems/vivisector)

# Vivisector

Vivisector helps you see inside your apps, specifically so that designers can be part of a QA / Continuous Integration process.  It's a framework to help you compare design "master" images to actual screenshots from various implementations.


## Motivation

* Engineers can't be expected to maintain the quality of the UX design any more than the designers can be expected to maintain the quality of the app code.

* Making engineers the gatekeepers of app design (being that they are gatekeepers of the source code) is at best unfair and at worst unwise.  The skill sets are different, and complementary -- we need to use both, and a way for them to work toether.

* If designers are pointing out problems in the design of a released build (nightly or otherwise), they are too late -- perpetually.  They need to be involved during the pull request phase, doing the design equivalent of a code review.


## Installation

The most straightforward way is to install the gem.

`$ gem install vivisector`

Bundler is the preferred method.

`gem 'vivisector', '~> 0.1', '>= 0.1.1'`


## Vivisector Requirements

You supply the input images.  You supply the output images.  You specify how they are related by defining a set of IDs and tagging the images with the appopriate ID.

Vivisector really doesn't do much; it simply generates reports.


## Setup

See the [example implementations](examples/) for information on how to set up a basic Vivisector script.
