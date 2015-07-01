require 'prism_qa'
require_relative 'prepopulated.rb'

# the "allow" method

RSpec.describe PrismQA::DesignSpectrum, "#allow_image_set" do
  context "When loading a design image set" do
    it "allows the image set to be added" do
      spectrum = MyDS.new
      expect { spectrum.load }.to_not raise_error()
    end
  end
end

RSpec.describe PrismQA::DesignSpectrum, "#allow_image_set" do
  context "When loading an app image set" do
    it "throws IncompatibilityError" do
      class MyDSBad < PrismQA::DesignSpectrum
        def fetch_image_set
          populated_app_image_set()["ais"]
        end
      end

      spectrum = MyDSBad.new
      expect { spectrum.load }.to raise_error(PrismQA::IncompatibilityError)
    end
  end
end


# App image spectrum

RSpec.describe PrismQA::AppSpectrum, "#allow_image_set" do
  context "When loading an app image set" do
    it "allows the image set to be added" do
      spectrum = MyAS.new
      expect { spectrum.load }.to_not raise_error()
    end
  end
end

RSpec.describe PrismQA::AppSpectrum, "#allow_image_set" do
  context "When loading a design image set" do
    it "throws IncompatibilityError" do
      class MyASBad < PrismQA::AppSpectrum
        def fetch_image_set
          populated_design_image_set()["dis"]
        end
      end

      spectrum = MyASBad.new
      expect { spectrum.load }.to raise_error(PrismQA::IncompatibilityError)
    end
  end
end
