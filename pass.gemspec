# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pass/version'

Gem::Specification.new do |spec|
  spec.name          = "pass"
  spec.version       = Pass::VERSION
  spec.authors       = ["Hitoshi Kurokawa"]
  spec.email         = ["hitoshi@nextseed.jp"]

  spec.summary       = %q{Password Generator (CLI)}
  spec.description   = %q{gem pass - Password Generator (CLI)}
  spec.homepage      = "http://github.com/krhitoshi/pass"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
