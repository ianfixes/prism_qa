
class ImageLoader

  attr_reader :image_set

  def initialize
    @image_set = nil  # the image set for this loader

  end

  def load
    image_set = self.fetch_image_set
    self.allow_image_set image_set
    @image_set = image_set
  end

  # implementation-specific: return a filled ImageSet
  def fetch_image_set
    puts "  +++ If you're seeing this, #{self.class.name}.#{__method__} was not overridden"
  end

  # implementation-specific: verify that an ImageSet is appropriate
  def allow_image_set image_set
    puts "  +++ If you're seeing this, #{self.class.name}.#{__method__} was not overridden"
  end

end


module Vivisector

  class Anatomy < ImageLoader

    def initialize
      super
      @order = []      # will hold the sorted indexes into the image set array
    end

    def allow_image_set image_set
      raise ImplementationError, "Got a nil DesignImageSet object; was #{self.class.name} properly extended?" if image_set.nil?

      # Ensure that we are only looking at design images
      raise IncompatibilityError, "Tried to add a non- DesignImageSet object to Anatomy" unless image_set.is_a? DesignImageSet
    end

  end


  class Appography < ImageLoader

    def allow_image_set image_set
      raise ImplementationError, "Got a nil DesignImageSet object; was #{self.class.name} properly extended?" if image_set.nil?

      # Ensure that we are only looking at implementation images
      raise IncompatibiltyError, "Tried to add a DesignImageSet object to Appography" if image_set.is_a? DesignImageSet
    end

  end

end
