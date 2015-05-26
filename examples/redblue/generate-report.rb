require 'bundler/setup'
require 'fileutils'
require 'vivisector'

# Minimal anatomy example: we hard-code 3 images we know are in the filesystem
class TestAnatomy < Vivisector::Anatomy

  def fetch_image_set
    dis = Vivisector::DesignImageSet.new

    im1 = Vivisector::DesignImage.new
    im1.id = "r"
    im1.description = "red"
    im1.path = File.join(File.dirname(__FILE__), "input", "red.png")
    dis.add(im1)

    im2 = Vivisector::DesignImage.new
    im2.id = "b"
    im2.attribute = "short"
    im2.description = "blue short"
    im2.path = File.join(File.dirname(__FILE__), "input", "blue_short.png")
    dis.add(im2)

    im3 = Vivisector::DesignImage.new
    im3.id = "b"
    im3.attribute = "tall"
    im3.description = "blue tall"
    im3.path = File.join(File.dirname(__FILE__), "input", "blue_tall.png")
    dis.add(im3)

    dis
  end

end


# Minimal appography example. We expect to have several of these.
# We hard-code the target here, and use path_component to indicate its attribute
class TestAppography < Vivisector::Appography
  attr_accessor :path_component

  def fetch_image_set
    ais = Vivisector::AppImageSet.new

    ais.target = Vivisector::Target.new
    ais.target.name = "#{@path_component} device"
    ais.target.attribute = @path_component

    im1 = Vivisector::AppImage.new
    im1.id = "r"
    im1.description = "red"
    im1.path = File.join(File.dirname(__FILE__), "input", @path_component, "red.png")
    ais.add(im1)

    im2 = Vivisector::AppImage.new
    im2.id = "b"
    im2.description = "blue"
    im2.path = File.join(File.dirname(__FILE__), "input", @path_component, "blue.png")
    ais.add(im2)

    ais
  end

end


# Create instances of the anatomy and appography(ies) we will use
my_anatomy = TestAnatomy.new

my_appography_short = TestAppography.new
my_appography_short.path_component = "short" # also the attribute of this "device"

my_appography_tall  = TestAppography.new
my_appography_tall.path_component  = "tall"  # also the attribute of this "device"


# Create the function we will use to determine the report names
def title_for_attribute attribute
  attribute = "default" if attribute.nil?
  "Report for #{attribute}"
end

# Create the function we will use to determine the report filenames
$output_dir = File.join(File.dirname(__FILE__), "output")
def html_report_path_for_attribute attribute
  attribute = "default" if attribute.nil?
  File.join($output_dir, "#{attribute}.html")
end

# create the output directory if it doesn't exist
FileUtils.mkdir_p $output_dir

# Kick off the reporting; the images will be fetched at this point.
Vivisector::report(my_anatomy,
                   [my_appography_short, my_appography_tall],
                   method(:title_for_attribute),
                   method(:html_report_path_for_attribute),
                   nil,
                   320)
