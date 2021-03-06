# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'marcellus/version'

Gem::Specification.new do |gem|
  gem.name          = "marcellus"
  gem.version       = Marcellus::VERSION
  gem.authors       = ["Written Software"]
  gem.email         = ["contact@writtensoftware.com"]
  gem.description   = %q{A simple gatekeeper for Git over SSH}
  gem.summary       = %q{A simple gatekeeper for Git over SSH}
  gem.homepage      = "https://github.com/nzaillian/marcellus"

  gem.add_dependency('rspec')
  gem.add_dependency('activesupport')
  gem.add_dependency('psych')


  gem.files         = Dir["**/*.*"]
  gem.executables   = ["marcellus"]
  gem.test_files    = Dir["spec/**/*.*"]
  gem.require_paths = ["lib"]
end