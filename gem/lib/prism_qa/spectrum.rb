
# A Spectrum in Prism defines a set of images that can be loaded on demand
# It is not exposed in the PrismQA module
class Spectrum

  attr_reader :image_set

  def initialize
    @image_set = nil  # the image set for this spectrum
  end

  def load
    image_set = fetch_image_set
    allow_image_set image_set
    @image_set = image_set
  end

  # implementation-specific: return a filled ImageSet
  def fetch_image_set
    puts "  +++ If you're seeing this, #{self.class.name}.#{__method__} was not overridden"
  end

  # implementation-specific: verify that an ImageSet is appropriate
  def allow_image_set(_image_set)
    puts "  +++ If you're seeing this, #{self.class.name}.#{__method__} was not overridden"
  end

end

# Extensions of Spectrum are exposed in the module

module PrismQA

  # A DesignSpectrum defines an order on a set of images used to represent the design
  class DesignSpectrum < Spectrum

    def initialize
      super
      @order = []  # will hold the sorted indexes into the image set array
    end

    def allow_image_set(image_set)
      raise ImplementationError, "Got a nil DesignImageSet object; was #{self.class.name} properly extended?" if image_set.nil?

      # Ensure that we are only looking at design images
      unless image_set.is_a? DesignImageSet
        raise IncompatibilityError, 'Tried to add a non- DesignImageSet object to DesignSpectrum'
      end
    end
  end

  # An AppSpectrum defines a set of images used to represent the actual app
  class AppSpectrum < Spectrum

    def allow_image_set(image_set)
      raise ImplementationError, "Got a nil DesignImageSet object; was #{self.class.name} properly extended?" if image_set.nil?

      # Ensure that we are only looking at implementation images
      raise IncompatibilityError, 'Tried to add a DesignImageSet object to AppSpectrum' if image_set.is_a? DesignImageSet
    end

  end

end
