require_relative 'filesystem'

module PrismQA

  # A prism ReportSet produces a set of reports, one for each attribute (plus one for the nil attribute)
  class ReportSet
    attr_accessor :design_spectrum
    attr_accessor :app_spectra
    attr_accessor :title_for_attribute_fn
    attr_accessor :path_for_attribute_fn
    attr_accessor :web_document_root
    attr_accessor :img_width_px

    # Check whether the path is correct, particularly if we are making a web-based report
    def allow_path(path)
      unless @web_document_root.nil?
        unless ancestor?(@web_document_root, path)
          raise OperationalError, "Report #{path} is not an ancestor of the web root #{@web_document_root}"
        end
      end
    end

    def _configured_report(attribute, output_path)
      r = Report.new
      r.title             = @title_for_attribute_fn.call(attribute)
      r.attribute         = attribute
      r.design_spectrum   = @design_spectrum
      r.app_spectra       = @app_spectra
      r.web_document_root = @web_document_root
      r.destination_path  = output_path
      r.img_width_px      = @img_width_px
      r
    end

    def write
      @design_spectrum.image_set.contained_attributes.map do |attr|

        # first check whether the destination is ok
        path = @path_for_attribute_fn.call(attr)
        allow_path path

        rpt = _configured_report(attr, path)
        File.open(path, 'w') { |f| f.write(rpt.to_s) }
      end
    end
  end
end
