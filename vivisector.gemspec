# coding: utf-8
lib = File.expand_path('../gem/lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vivisector/version'

Gem::Specification.new do |spec|
  spec.name          = "vivisector"
  spec.description   = "Vivisector helps you see inside your apps, specifically so that designers can be part of a QA / Continuous Integration process. It's a framework to help you compare design 'master' images to actual screenshots from various implementations."
  spec.version       = Vivisector::VERSION
  spec.licenses      = ['Apache 2.0']
  spec.authors       = ["Ian Katz"]
  spec.email         = ["ifreecarve@gmail.com"]

  spec.summary       = %q{Design QA tool}
  spec.homepage      = "http://github.com/ifreecarve/vivisector"

  spec.files         =  Dir['gem/**/*.*'].reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["gem/lib"]

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_development_dependency "bundler", '~> 1.3', '>= 1.3.6'
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "markaby", '~> 0.8', ">= 0.8.0"
end
