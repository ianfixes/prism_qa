Vivisector Example: Red and Blue
================================

This example shows a design that is implemented on two separate targets (with attributes `tall` and `short`, respectively).  The design has one image -- red -- that is relevant to all targets, and a set of images that are target-specific representations of the same conceptual screen -- blue.

It generates reports in the `output/` directory:

1. A report for the "default" attribute (nil), containing only the red image.
2. A report for the "tall" attribute
3. A report for the "short" attribute

To generate these reports, run `ruby generate-report.rb`
