require 'prism_qa'
require_relative 'prepopulated.rb'

RSpec.describe PrismQA::ReportSet, "#write" do
  context "When writing a report with an AppImageSet that lacks a target" do
    it "raises an error" do
      design_spectrum = MyDS.new
      class MyASNoTarget < PrismQA::AppSpectrum
        def fetch_image_set
          populated_app_image_set()["ais"]
        end
      end
      app_spectrum = MyASNoTarget.new

      expect do
        PrismQA::report(design_spectrum,
                        [app_spectrum],
                        method(:title_for_attribute),
                        method(:html_report_path_for_attribute),
                        $output_dir,
                        10) end.to raise_error(PrismQA::OperationalError)
    end
  end
end

RSpec.describe PrismQA::ReportSet, "#write" do
  context "When writing a report with proper path" do
    it "writes a report set" do
      design_spectrum = MyDS.new
      app_spectrum = MyAS.new

      expect do
        PrismQA::report(design_spectrum,
                        [app_spectrum],
                        method(:title_for_attribute),
                        method(:html_report_path_for_attribute),
                        $output_dir,
                        10) end.to_not raise_error()
    end
  end
end
