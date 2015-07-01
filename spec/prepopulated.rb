require 'fileutils'

# create output directory if it doesn't exist
$output_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "coverage", "_prism_qa"))
FileUtils.mkdir_p $output_dir

$dummy_file = File.join($output_dir, "dummy_image.txt")
FileUtils.touch $dummy_file

def populated_design_image_set()
  dis = PrismQA::DesignImageSet.new

  im1 = PrismQA::DesignImage.new
  im1.id = 'r'
  im1.description = 'red'
  im1.path = $dummy_file
  dis.add(im1)

  im2 = PrismQA::DesignImage.new
  im2.id = 'b'
  im2.attribute = 'short'
  im2.description = 'blue short'
  im2.path = $dummy_file
  dis.add(im2)

  im3 = PrismQA::DesignImage.new
  im3.id = 'b'
  im3.attribute = 'tall'
  im3.description = 'blue tall'
  im3.path = $dummy_file
  dis.add(im3)

  im4 = PrismQA::DesignImage.new
  im4.id = 'g'
  im4.attribute = 'short'
  im4.description = 'green short'
  im4.path = $dummy_file
  dis.add(im4)

  im5 = PrismQA::DesignImage.new
  im5.id = 'g'
  im5.attribute = 'tall'
  im5.description = 'green tall'
  im5.path = $dummy_file
  dis.add(im5)

  {"dis" => dis,
    "im1" => im1,
    "im2" => im2,
    "im3" => im3,
    "im4" => im4,
    "im5" => im5}
end

def populated_app_image_set(target_name = nil)
  ais = PrismQA::AppImageSet.new

  im1 = PrismQA::AppImage.new
  im1.id = 'r'
  im1.description = 'red'
  im1.path = $dummy_file
  ais.add(im1)

  im2 = PrismQA::AppImage.new
  im2.id = 'b'
  im2.description = 'blue'
  im2.path = $dummy_file
  ais.add(im2)

  im3 = PrismQA::AppImage.new
  im3.id = 'g'
  im3.description = 'green'
  im3.path = $dummy_file
  ais.add(im3)

  unless target_name.nil?
    target = PrismQA::Target.new
    target.name = target_name
    ais.target = target
  end

  {"ais" => ais,
    "im1" => im1,
    "im2" => im2,
    "im3" => im3}
end

class MyDS < PrismQA::DesignSpectrum
  def fetch_image_set
    populated_design_image_set()["dis"]
  end
end

class MyAS < PrismQA::AppSpectrum
  def fetch_image_set
    populated_app_image_set("my target")["ais"]
  end
end


# Create the function we will use to determine the report names
def title_for_attribute(attribute)
  attribute = 'default' if attribute.nil?
  "Report for #{attribute}"
end

# Create the function we will use to determine the report filenames
def html_report_path_for_attribute(attribute)
  attribute = 'default' if attribute.nil?
  File.join($output_dir, "#{attribute}.html")
end
