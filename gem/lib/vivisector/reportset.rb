require 'markaby'

module Vivisector

  class ReportSet
    attr_accessor :anatomy
    attr_accessor :appographies
    attr_accessor :title_for_attribute_fn
    attr_accessor :path_for_attribute_fn
    attr_accessor :web_document_root

    def write
      @anatomy.image_set.contained_attributes.map do |attr|
        r = Report.new
        r.title             = @title_for_attribute_fn.call(attr)
        r.attribute         = attr
        r.anatomy           = @anatomy
        r.appographies      = @appographies
        r.web_document_root = @web_document_root

        path = @path_for_attribute_fn.call(attr)
        File.open(path, 'w') {|f| f.write(r.to_s) }
      end
    end

  end


end #Vivisector
