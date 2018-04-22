
module PrismQA

  # A container for sets of images, with basic sanity checking
  class ImageSet

    # The container for all the images in the set
    # @return [Array] of PrismQA::Image objects
    attr_reader :images

    def initialize
      @images = []
      @cache_valid = false  # cache invalidation is so easy
    end

    # Safely add images to the container
    # @param [PrismQA::Image] The image to be added
    def add(image)
      allow image
      # fix relative paths
      image.path = File.expand_path(image.path)
      @images << image
      @cache_valid = false
      nil
    end

    # Raise an error if the image is not appropriate for this type of set
    # @param [PrismQA::Image] The image to be added
    # @throws
    def allow(_image)
      puts "  +++ If you're seeing this, #{self.class.name}.#{__method__} was not overridden"
    end

  end

  # Design image sets need to be able to report on the images they contain
  class DesignImageSet < ImageSet

    def allow(image)
      # Ensure that image objects have an "attribute" field, among other things
      raise IncompatibilityError, 'Tried to add a non- DesignImage object to a DesignImageSet' unless image.is_a? DesignImage

      # no duplicates allowed
      if @images.map { |i| [i.id, i.attribute] }.include? [image.id, image.attribute]
        raise OperationalError, "Tried to add an image with duplicate ID '#{image.id}' and attribute '#{image.attribute}'"
      end
    end

    # Get the list of unique attributes contained by the images within
    def contained_attributes
      @images.map(&:attribute).uniq
    end

    # cache the image attributes
    def cache_image_attributes
      return if @cache_valid

      # make a hash -- hash[image id] = list of attributes defined for this image id
      # we use this for convenience later
      @attributes_by_id = {}
      @images.each do |img|
        proper_key = img.id.to_s
        @attributes_by_id[proper_key] = [] unless @attributes_by_id.key? proper_key
        @attributes_by_id[proper_key] << img.attribute
      end

      @cache_valid = true
    end

    # get the list of images that are valid for a particular attribute
    def images_for_attribute(attribute)
      cache_image_attributes

      # return the pared-down list
      @images.select do |img|
        # this covers nil == nil and attribute == attribute
        next true if img.attribute == attribute

        # if there is no attribute for this image, it should be pulled in
        #        ... unless there's an exact match elsewhere in the set.
        next true if img.attribute.nil? && !(@attributes_by_id[img.id.to_s].include? attribute)

        false
      end
    end

  end

  # App image sets are tied to a target
  class AppImageSet < ImageSet

    attr_accessor :target

    def allow(image)
      # no duplicates
      if @images.map(&:id).include? image.id
        raise OperationalError, "Tried to add an image with duplicate ID '#{image.id}'"
      end

      # App image sets don't need to worry about specific fields, but we keep it clean and symmetric.
      raise IncompatibilityError, 'Tried to add a DesignImage object to a non- DesignImageSet' if image.is_a? DesignImage
    end

    def cache_image_lookups
      return if @cache_valid

      @image_lookup = {}
      @images.each do |img|
        @image_lookup[img.id.to_s] = img
      end

      @cache_valid = true
    end

    def best_image_for(id)
      cache_image_lookups
      @image_lookup.fetch(id.to_s, nil)
    end

  end

end
