# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ans-feature-helpers/version"

Gem::Specification.new do |s|
  s.name        = "ans-feature-helpers"
  s.version     = Ans::Feature::Helpers::VERSION
  s.authors     = ["sakai shunsuke"]
  s.email       = ["sakai@ans-web.co.jp"]
  s.homepage    = "https://github.com/answer/ans-feature-helpers"
  s.summary     = %q{cucumber:feature のヘルパー}
  s.description = %q{cucumber の feature に関連する helper を提供}

  s.rubyforge_project = "ans-feature-helpers"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_development_dependency "ans-gem-builder"
end
