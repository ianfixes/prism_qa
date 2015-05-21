require 'vivisector/version'

require 'vivisector/target'
require 'vivisector/image'
require 'vivisector/imageset'
require 'vivisector/imageloader'
require 'vivisector/report'
require 'vivisector/reportset'


module Vivisector

  def self.report(anatomy, appographies, title_for_attribute_fn, path_for_attribute_fn, web_document_root)
    # load source images
    anatomy.load
    appographies.each { |appog| appog.load }

    unless web_document_root.nil?
      appographies.each do |appog|
        # if the path isn't within web_document_root, throw
      end

      # copy all images to an images/ directory inside web_document_root
      # mangle all image sets to point to there
      # use dirnames like "images/design", "images/target1", "images/target2", etc
    end

    rs = Vivisector::ReportSet.new
    rs.anatomy                = anatomy
    rs.appographies           = appographies
    rs.title_for_attribute_fn = title_for_attribute_fn
    rs.path_for_attribute_fn  = path_for_attribute_fn
    rs.web_document_root      = web_document_root

    rs.write
  end

end
