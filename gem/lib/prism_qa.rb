require 'prism_qa/version'

require 'prism_qa/exceptions'
require 'prism_qa/target'
require 'prism_qa/image'
require 'prism_qa/imageset'
require 'prism_qa/spectrum'
require 'prism_qa/report'
require 'prism_qa/reportset'

# The top-level prism module
module PrismQA

  # Create a prism report
  #
  # design_spectrum:        a DesignSpectrum object
  # app_spectra:            an array of AppSpectrum objects
  # title_for_attribute_fn: a function taking a string attribute (or nil) and returning a string title
  # path_for_attribute_fn:  a function taking a string attribute (or nil) and returning the path for the saved report
  # web_document_root:      a path relative to which images within the report should be referenced
  # img_width_px:           an integer width for images in the report
  def self.report(design_spectrum, app_spectra, title_for_attribute_fn, path_for_attribute_fn, web_document_root, img_width_px)
    # load source images
    design_spectrum.load
    app_spectra.each(&:load)

    rs = PrismQA::ReportSet.new
    rs.design_spectrum        = design_spectrum
    rs.app_spectra            = app_spectra
    rs.title_for_attribute_fn = title_for_attribute_fn
    rs.path_for_attribute_fn  = path_for_attribute_fn
    rs.web_document_root      = web_document_root
    rs.img_width_px           = img_width_px

    rs.write
  end

end
