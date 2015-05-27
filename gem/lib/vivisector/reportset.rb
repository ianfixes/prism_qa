require_relative 'filesystem'

module Vivisector

  class ReportSet
    attr_accessor :anatomy
    attr_accessor :appographies
    attr_accessor :title_for_attribute_fn
    attr_accessor :path_for_attribute_fn
    attr_accessor :web_document_root
    attr_accessor :img_width_px

    # Check whether the path is correct, particularly if we are making a web-based report
    def allow_path path
      unless @web_document_root.nil?
        unless ancestor?(@web_document_root, path)
          raise OperationalError, "Report #{path} is not an ancestor of the web root #{@web_document_root}"
        end
      end
    end

    def write
      @anatomy.image_set.contained_attributes.map do |attr|

        # first check whether the destination is ok
        path = @path_for_attribute_fn.call(attr)
        self.allow_path path

        r = Report.new
        r.title             = @title_for_attribute_fn.call(attr)
        r.attribute         = attr
        r.anatomy           = @anatomy
        r.appographies      = @appographies
        r.web_document_root = @web_document_root
        r.destination_path  = path
        r.img_width_px      = @img_width_px

        File.open(path, 'w') {|f| f.write(r.to_s) }
      end
    end

  end


end #Vivisector
