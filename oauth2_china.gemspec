# -*- encoding: utf-8 -*-
require File.expand_path('../lib/oauth2_china/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chagel"]
  gem.email         = ["mike@gmail.com"]
  gem.description   = %q{Weibo OAuth2 API Ruby wrapper.}
  gem.summary       = %q{Weibo OAuth2 API Ruby wrapper. Currently support Sina and Tencent Weibo APIs.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "oauth2_china"
  gem.require_paths = ["lib"]
  gem.version       = Oauth2China::VERSION

  gem.add_dependency 'faraday'
  gem.add_dependency 'hashie'
end
