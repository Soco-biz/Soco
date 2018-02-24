# -*- encoding: utf-8 -*-
# stub: rack-user_agent 0.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-user_agent"
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Takashi Kokubun"]
  s.date = "2016-07-11"
  s.description = "Rack::Request extension for handling User-Agent."
  s.email = ["takashikkbn@gmail.com"]
  s.homepage = "https://github.com/k0kubun/rack-user_agent"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Rack::Request extension for handling User-Agent."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.5"])
      s.add_runtime_dependency(%q<woothee>, [">= 1.0.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 1.5"])
      s.add_dependency(%q<woothee>, [">= 1.0.0"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.5"])
    s.add_dependency(%q<woothee>, [">= 1.0.0"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
  end
end
