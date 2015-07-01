require 'prism_qa'

RSpec.describe PrismQA, "#ancestor?" do
  context "when reading a path that is an ancestor of another path" do
    it "returns true" do
      a = '/foo/bar'
      b = '/foo/bartholomew/monkey'
      c = '/foo/bar/baz'
      d = '/foo/../foo/bar/monkey'
      expect(PrismQA.send(:ancestor?, a, b)).to eq false
      expect(PrismQA.send(:ancestor?, b, a)).to eq false
      expect(PrismQA.send(:ancestor?, d, a)).to eq false
      expect(PrismQA.send(:ancestor?, c, a)).to eq false
      expect(PrismQA.send(:ancestor?, a, c)).to eq true
      expect(PrismQA.send(:ancestor?, a, d)).to eq true
    end
  end
end

RSpec.describe PrismQA, "#web_relative_path" do
  context "when given the url of a document and a child element in a web root" do
    it "returns the relative path" do
      r = File.dirname(__FILE__)  # ./spec
      rr = File.dirname(r)        # <repo root>
      b = __FILE__                # ./spec/filesystem_spec.rb
      bb = r                      # ./spec (pretending its an html file)
      e = File.join(File.dirname(__FILE__), 'spec_helper.rb')
      expect(PrismQA.send(:web_relative_path, r, b, e)).to eq "spec_helper.rb"
      expect(PrismQA.send(:web_relative_path, rr, bb, e)).to eq "spec/spec_helper.rb"
    end
  end
end

RSpec.describe PrismQA, "#web_relative_path" do
  context "when given the url of a document and a child element that is outside the web root" do
    it "raises an execption" do
      r = File.dirname(__FILE__)             # ./spec
      g = File.join(File.dirname(r), "gem")  # <repo root>/gem
      b = __FILE__                           # ./spec/filesystem_spec.rb
      e = File.join(File.dirname(__FILE__), 'spec_helper.rb')
      expect { raise PrismQA::OperationalError }.to raise_error(PrismQA::OperationalError)
      expect { PrismQA.send(:web_relative_path, g, b, e) }.to raise_error(PrismQA::OperationalError)
    end
  end
end
