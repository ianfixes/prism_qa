require 'prism_qa/version'

require 'prism_qa/exceptions'
require 'prism_qa/target'
require 'prism_qa/image'
require 'prism_qa/imageset'
require 'prism_qa/spectrum'
require 'prism_qa/report'
require 'prism_qa/reportset'


module PrismQA

  def self.report(design_spectrum, app_spectra, title_for_attribute_fn, path_for_attribute_fn, web_document_root, img_width_px)
    # load source images
    design_spectrum.load
    app_spectra.each { |app_spectrum| app_spectrum.load }

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
