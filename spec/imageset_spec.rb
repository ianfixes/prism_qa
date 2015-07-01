require 'prism_qa'
require_relative 'prepopulated.rb'

# the "allow" method

RSpec.describe PrismQA::ImageSet, "#allow" do
  context "When adding an Image" do
    it "allows the image to be added" do
      pis = PrismQA::ImageSet.new
      img = PrismQA::Image.new
      img.path = __FILE__ # shouldn't matter. we just need a real path
      expect { pis.add(img) }.to_not raise_error()
    end
  end
end

RSpec.describe PrismQA::DesignImageSet, "#allow" do
  context "When adding a DesignImage" do
    it "allows the image to be added" do
      dis = PrismQA::DesignImageSet.new
      img = PrismQA::DesignImage.new
      img.path = __FILE__ # shouldn't matter. we just need a real path
      expect { dis.add(img) }.to_not raise_error()
    end
  end
end

RSpec.describe PrismQA::DesignImageSet, "#allow" do
  context "When adding a non-DesignImage" do
    it "raises an IncompatibilityError" do
      dis = PrismQA::DesignImageSet.new
      img = PrismQA::AppImage.new
      img.path = __FILE__ # shouldn't matter. we just need a real path
      expect { dis.add(img) }.to raise_error(PrismQA::IncompatibilityError)
    end
  end
end

RSpec.describe PrismQA::DesignImageSet, "#allow" do
  context "When adding a duplicate DesignImage" do
    it "raises an OperationalError" do
      dis = PrismQA::DesignImageSet.new
      img1 = PrismQA::DesignImage.new
      img1.id = "1"
      img1.path = __FILE__ # shouldn't matter. we just need a real path
      img2 = PrismQA::DesignImage.new
      img2.id = "1"
      img2.path = __FILE__ # shouldn't matter. we just need a real path
      expect { dis.add(img1) }.to_not raise_error()
      expect { dis.add(img2) }.to raise_error(PrismQA::OperationalError)
    end
  end
end

RSpec.describe PrismQA::AppImageSet, "#allow" do
  context "When adding an AppImage" do
    it "allows the image to be added" do
      ais = PrismQA::AppImageSet.new
      img = PrismQA::AppImage.new
      img.path = __FILE__ # shouldn't matter. we just need a real path
      expect { ais.add(img) }.to_not raise_error()
    end
  end
end

RSpec.describe PrismQA::AppImageSet, "#allow" do
  context "When adding a DesignImage" do
    it "raises an IncompatibilityError" do
      ais = PrismQA::AppImageSet.new
      img = PrismQA::DesignImage.new
      img.path = __FILE__ # shouldn't matter. we just need a real path
      expect { ais.add(img) }.to raise_error(PrismQA::IncompatibilityError)
    end
  end
end

RSpec.describe PrismQA::AppImageSet, "#allow" do
  context "When adding a duplicate AppImage" do
    it "raises an OperationalError" do
      dis = PrismQA::AppImageSet.new
      img1 = PrismQA::AppImage.new
      img1.id = "1"
      img1.path = __FILE__ # shouldn't matter. we just need a real path
      img2 = PrismQA::AppImage.new
      img2.id = "1"
      img2.path = __FILE__ # shouldn't matter. we just need a real path
      expect { dis.add(img1) }.to_not raise_error()
      expect { dis.add(img2) }.to raise_error(PrismQA::OperationalError)
    end
  end
end


# DesignImageSet stuff

RSpec.describe PrismQA::DesignImageSet, "#contained_attributes" do
  context "When calculating contained attributes" do
    it "only unique attributes are returned" do
      dis = populated_design_image_set()["dis"]
      expect(dis.contained_attributes).to include(nil, 'short', 'tall')
    end
  end
end

RSpec.describe PrismQA::DesignImageSet, "#images_for_attribute" do
  context "When looking at images for attribute" do
    it "all images matching the attribute are returned" do
      set = populated_design_image_set
      dis = set["dis"]
      expect(dis.images_for_attribute('short')).to include(set['im1'], set['im2'], set['im4'])
      expect(dis.images_for_attribute('tall')).to include(set['im1'], set['im3'], set['im5'])
    end
  end
end


# AppImageSet stuff

RSpec.describe PrismQA::AppImageSet, "#images_for_attribute" do
  context "When looking at images for attribute" do
    it "all images matching the attribute are returned" do
      set = populated_app_image_set
      ais = set["ais"]
      expect(ais.best_image_for('r')).to eq set['im1']
      expect(ais.best_image_for('b')).to eq set['im2']
      expect(ais.best_image_for('g')).to eq set['im3']
      expect(ais.best_image_for('a')).to eq nil
    end
  end
end
