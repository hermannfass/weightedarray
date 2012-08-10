# -*- encoding: utf-8 -*-
require File.expand_path('../lib/weightedarray/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hermann Faß"]
  gem.email         = ["hf@vonabiszet.de"]
  gem.description   = %q{Arrays for random selection with individual likelihoods per element}
  gem.summary       = %q{WeightedArray contains elements of type WeightedElement. WeightedArray#sample considers the weight of each element when returning arandom element.}
  gem.homepage      = "https://github.com/hermannfass/weightedarray"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "weightedarray"
  gem.require_paths = ["lib"]
  gem.version       = Weightedarray::VERSION
end
