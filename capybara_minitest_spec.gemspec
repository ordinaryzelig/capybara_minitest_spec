# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capybara_minitest_spec/version"

Gem::Specification.new do |s|
  s.name        = "capybara_minitest_spec"
  s.version     = CapybaraMiniTestSpec::VERSION
  s.authors     = ["Jared Ning"]
  s.email       = ["jared@redningja.com"]
  s.homepage    = "https://github.com/ordinaryzelig/capybara_minitest_spec"
  s.summary     = %q{Capybara + MiniTest::Spec}
  s.description = %q{Use Capybara matchers with MiniTest. Specifically, it defines MiniTest::Spec expectations like page.must_have_content('content').}
  s.license     = "MIT"

  s.rubyforge_project = "capybara_minitest_spec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'capybara', '>= 2'
  s.add_runtime_dependency 'minitest', '>= 2'

  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sinatra', '>= 0.9.4'
end
