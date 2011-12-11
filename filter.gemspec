# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "filter/version"

Gem::Specification.new do |s|
  s.name        = "filter"
  s.version     = Filter::VERSION
  s.authors     = ["Alexey Mikhaylov"]
  s.email       = ["amikhailov83@gmail.com"]
  s.homepage    = "https://github.com/take-five/filter"
  s.summary     = %q{Enumerable#filter - extended Enumerable#select combined with Enumerable#collect}
  s.description = File.read(File.expand_path('../README.rdoc', __FILE__))
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.rubyforge_project = "filter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'deferred_enum'
  s.add_development_dependency "rspec"
end
