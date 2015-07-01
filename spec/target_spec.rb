require 'prism_qa'

RSpec.describe PrismQA::Target, "#init" do
  context "when initialized and populated" do
    it "retains values" do
      target = PrismQA::Target.new
      expect(target.name).to eq nil
      expect(target.attribute).to eq nil
      target.name = "my_name"
      target.attribute = "my attribute"
      expect(target.name).to eq "my_name"
      expect(target.attribute).to eq "my attribute"
    end
  end
end
