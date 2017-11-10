# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "parxer/version"

Gem::Specification.new do |spec|
  spec.name          = "parxer"
  spec.version       = Parxer::VERSION
  spec.authors       = ["Platanus", "Leandro Segovia"]
  spec.email         = ["rubygems@platan.us", "ldlsegovia@gmail.com"]
  spec.homepage      = "https://github.com/platanus/parxer/master"
  spec.summary       = "ruby gem to parse data"
  spec.description   = "ruby gem to parse data from different source types"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "require_all"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "coveralls"
end
