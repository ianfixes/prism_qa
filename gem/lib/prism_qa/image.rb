
module PrismQA

  # A simple container for image information.
  # Image objects represent a path on disk, with an additional
  # ID field (for cross-referencing design and app images) and
  # an optional user-friendly description
  class Image
    # The image's location on disk
    # @return [String]
    attr_accessor :path

    # an application-specific unique identifier
    # @return [String]
    attr_accessor :id

    # a friendly description
    # @return [String]
    attr_accessor :description
  end

  # Design images extend Images by optionally specifying an attribute.
  # This enables different design variants to be labeled, such as
  # for a modified screen size.
  class DesignImage < Image
    # A design attribute of the image
    # @return [String]
    attr_accessor :attribute
  end

  # App images are no different than the base class they use.
  # THis class is essentially an alias for symmetry / clarity
  class AppImage < Image; end
end
