# coding: utf-8
lib = File.expand_path('../gem/lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prism_qa/version'

Gem::Specification.new do |spec|
  spec.name          = 'prism_qa'
  spec.description   = 'Prism helps you split your apps and your design document into visible components.  '\
                       'Its purpose is to enable designers to be an effective part of a QA / Continuous Integration process.'
  spec.version       = PrismQA::VERSION
  spec.licenses      = ['Apache 2.0']
  spec.authors       = ['Ian Katz']
  spec.email         = ['ianfixes@gmail.com']

  spec.summary       = 'Design QA tool'
  spec.homepage      = 'http://github.com/ianfixes/prism_qa'

  spec.files         =  Dir['gem/**/*.*'].reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['gem/lib']

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, "\
    #                                      "or delete to allow pushes to any server."
  end

  spec.add_development_dependency 'bundler', '~> 1.3', '>= 1.3.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.49', '>= 0.49.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'
  spec.add_development_dependency 'simplecov-json', '~> 0.2', '>= 0.2.0'
  spec.add_development_dependency 'yard', '~>0.9.11', '>= 0.9.11'

  spec.add_runtime_dependency 'markaby', '~> 0.8', '>= 0.8.0'
end
