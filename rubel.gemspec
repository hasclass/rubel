# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rubel/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["hasclass"]
  gem.email         = ["sebi.burkhard@gmail.com"]
  gem.description   = %q{ruby enterprise language. Run excel-like formulas ruby code. E.g. SUM(MAP(KEY_ACCOUNTS(), revenue))}
  gem.summary       = %q{A dsl for excel-like formulas to run as regular rubycode. E.g. SUM(MAP(KEY_ACCOUNTS(), revenue))}
  gem.homepage      = "http://hasclass.com/rubel"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rubel"
  gem.require_paths = ["lib"]
  gem.version       = Rubel::VERSION
end
