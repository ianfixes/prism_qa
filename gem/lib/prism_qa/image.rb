
module PrismQA

  # A simple container for image information
  class Image
    attr_accessor :path         # the location on disk
    attr_accessor :id           # an application-specific unique identifier
    attr_accessor :description  # a friendly description
  end


  # Design images may optionally specify an attribute
  class DesignImage < Image
    attr_accessor :attribute
  end

  # App images are the same as images, but create this alias for symmetry / clarity
  class AppImage < Image; end
end
