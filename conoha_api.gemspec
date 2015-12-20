# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'conoha_api/version'

Gem::Specification.new do |spec|
  spec.name          = "conoha_api"
  spec.version       = ConohaApi::VERSION
  spec.authors       = ["Kinoshita.Yasuhiro"]
  spec.email         = ["WhoIsDissolvedGirl+github@gmail.com"]

  spec.summary       = %q{ConoHa API Client}
  spec.description   = %q{ConoHa API Client}
  spec.homepage      = "https://github.com/kinoppyd/conoha-api"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.license       = "MIT"

  spec.add_runtime_dependency "sawyer", "~> 0.6"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
