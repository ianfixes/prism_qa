require 'bundler/setup'
require 'fileutils'
require 'prism_qa'

# Minimal design spectrum example: we hard-code 3 images we know are in the filesystem
class TestDesignSpectrum < PrismQA::DesignSpectrum

  def fetch_image_set
    dis = PrismQA::DesignImageSet.new

    im1 = PrismQA::DesignImage.new
    im1.id = 'r'
    im1.description = 'red'
    im1.path = File.join(File.dirname(__FILE__), 'input', 'red.png')
    dis.add(im1)

    im2 = PrismQA::DesignImage.new
    im2.id = 'b'
    im2.attribute = 'short'
    im2.description = 'blue short'
    im2.path = File.join(File.dirname(__FILE__), 'input', 'blue_short.png')
    dis.add(im2)

    im3 = PrismQA::DesignImage.new
    im3.id = 'b'
    im3.attribute = 'tall'
    im3.description = 'blue tall'
    im3.path = File.join(File.dirname(__FILE__), 'input', 'blue_tall.png')
    dis.add(im3)

    dis
  end

end

# Minimal app spectrum example. We expect to have several of these.
# We hard-code the target here, and use path_component to indicate its attribute
class TestAppSpectrum < PrismQA::AppSpectrum
  attr_accessor :path_component

  def fetch_image_set
    ais = PrismQA::AppImageSet.new

    ais.target = PrismQA::Target.new
    ais.target.name = "#{@path_component} device"
    ais.target.attribute = @path_component

    im1 = PrismQA::AppImage.new
    im1.id = 'r'
    im1.description = 'red'
    im1.path = File.join(File.dirname(__FILE__), 'input', @path_component, 'red.png')
    ais.add(im1)

    im2 = PrismQA::AppImage.new
    im2.id = 'b'
    im2.description = 'blue'
    im2.path = File.join(File.dirname(__FILE__), 'input', @path_component, 'blue.png')
    ais.add(im2)

    ais
  end

end

# Create instances of the design spectrum and app spectra we will use
my_design_spectrum = TestDesignSpectrum.new

my_app_spectrum_short = TestAppSpectrum.new
my_app_spectrum_short.path_component = 'short' # also the attribute of this "device"

my_app_spectrum_tall  = TestAppSpectrum.new
my_app_spectrum_tall.path_component  = 'tall'  # also the attribute of this "device"

# Create the function we will use to determine the report names
def title_for_attribute(attribute)
  attribute = 'default' if attribute.nil?
  "Report for #{attribute}"
end

# Create the function we will use to determine the report filenames
$output_dir = File.join(File.dirname(__FILE__), 'output')
def html_report_path_for_attribute(attribute)
  attribute = 'default' if attribute.nil?
  File.join($output_dir, "#{attribute}.html")
end

# create the output directory if it doesn't exist
FileUtils.mkdir_p $output_dir

# Kick off the reporting; the images will be fetched at this point.
PrismQA::report(my_design_spectrum,
                [my_app_spectrum_short, my_app_spectrum_tall],
                method(:title_for_attribute),
                method(:html_report_path_for_attribute),
                File.dirname(__FILE__),    # pretend that this is the root of a web directory -- use relative paths
                320)
