require 'bundler/setup'
require 'fileutils'
require 'vivisector'


if ARGV.length == 0
  puts "Missing argument: path to sketch file"
  exit 1
end

$output_dir = File.join(File.dirname(__FILE__), "output")

# Sketch file anatomy example: we dynamically process artboards from a sketch file as design images
class SketchAnatomy < Vivisector::Anatomy
  attr_accessor :sketch_file_path

  def fetch_image_set
    # create and fill output directory
    sketch_output_dir = File.join($output_dir, "sketch")
    FileUtils.mkdir_p sketch_output_dir
    self.run_sketch_command(@sketch_file_path, sketch_output_dir)

    # create design image set, and iterate through sketch output directory to process filenames
    dis = Vivisector::DesignImageSet.new
    sketch_image_filenames = Dir.entries(sketch_output_dir).reject{|f| File.directory? f}
    sketch_image_filenames.each do |f|
      image = Vivisector::DesignImage.new
      image.path = File.join(sketch_output_dir, f)

      # the (arbitrary) artboard naming convention is either id.png or attribute_id.png
      tokenizer = /([^._]+)(_)?([^.]*?).png/
      tokens = tokenizer.match(f).to_a
      if tokens[2].nil?
        image.id = image.description = tokens[1]
      else
        image.id          = tokens[3]
        image.attribute   = tokens[1]
        image.description = "#{tokens[3]} on #{tokens[1]}"
      end
      dis.add(image)
    end

    # we chose not to sort the images by name this time.

    dis
  end

  def run_sketch_command(sketch_doc_path, img_output_dir)
    system("sketchtool", "export", "artboards", File.expand_path(sketch_doc_path), "--output=#{File.expand_path(img_output_dir)}")
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
    im1.id = "red"
    im1.description = "red"
    im1.path = File.join(File.dirname(__FILE__), "input", @path_component, "red.png")
    ais.add(im1)

    im2 = Vivisector::AppImage.new
    im2.id = "blue"
    im2.description = "blue"
    im2.path = File.join(File.dirname(__FILE__), "input", @path_component, "blue.png")
    ais.add(im2)

    ais
  end

end


# Create instances of the anatomy and appography(ies) we will use
my_anatomy = SketchAnatomy.new
my_anatomy.sketch_file_path = ARGV[0]

my_appography_short = TestAppography.new
my_appography_short.path_component = "iPhone4" # also the attribute of this "device"

my_appography_tall  = TestAppography.new
my_appography_tall.path_component  = "iPhone5"  # also the attribute of this "device"


# Create the function we will use to determine the report names
def title_for_attribute attribute
  attribute = "default" if attribute.nil?
  "Report for #{attribute}"
end

# Create the function we will use to determine the report filenames
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
