# Vivisector

Vivisector helps you see inside your apps.  It compares design "master" images to a set of images from various implementations.


## Requirements

You supply the input images.  You supply the output images.  You follow a format for all the image filenames.  Vivisector really doesn't do much there; it simply generates reports.


## File naming

All files processed by vivisector must indicate the following information in their filenames:

* An integer ID indicating the section of the app
* An integer ID indicating the screen of the app (within a section)
* An integer ID indicating the scenario (within a screen)

Optionally, the following information can be provided in the filename:

* A string indicating a specific attribute covered by the file (e.g. short or tall screen size)
* A string indicating a specific variant covered by the file (e.g. a specific country or locale)
* A free-form string description of the file


### General format

* (section).(screen).(scenario)+(attribute).(variant)-(any-description).png
* (section).(screen).(scenario)+(attribute)-(any-description).png
* (section).(screen).(scenario)-(any-description).png


### Examples

* 1.1.1-splash screen.png
* 1.2.1-welcome screen.png
* 2.1.1-login screen.png
* 2.1.1+phablet-login screen for phablet devices.png
* 2.1.1+phablet.UK-login screen for UK phablet devices.png
* 2.1.2-login screen with data entered.png
* 2.2.1-login options screen.png