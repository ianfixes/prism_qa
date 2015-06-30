Prism QA Example: Sketch
========================

This example shows a design that is implemented on two separate targets (with attributes `iPhone4` and `iPhone5`, respectively).  The design has one image -- red -- that is relevant to all targets, and a set of images that are target-specific representations of the same conceptual screen -- blue.

Rather than existing on the filesystem, the design images come from a sketch file and are generated on demand.

It generates reports in the `output/` directory:

1. A report for the "default" attribute (nil), containing only the red image.
2. A report for the "iPhone4" attribute
3. A report for the "iPhone5" attribute

To generate these reports, run `ruby generate_report_from_sketchfile.rb iPhone_canvas.sketch`


Requirements
------------

You will need to install [sketchtool](http://bohemiancoding.com/sketch/tool/) -- a free download.