# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'd2l_sdk/version'

Gem::Specification.new do |spec|
    spec.name = 'd2l_sdk'
    spec.version       = D2lSdk::VERSION
    spec.authors       = ['Andrew Kulpa']
    spec.email         = ['AJ-Kulpa@wiu.edu']

    spec.summary       = 'Simple Ruby Gem to utilize the Valence/D2L SDK'
    spec.description   = 'Simple Ruby Gem to utilize the Valence/D2L SDK; requires config file to have variables declared.'
    spec.homepage      = 'https://gitlab.wiu.edu/ajk142/valence_testing'
    spec.license       = 'MIT'

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
    # to allow pushing to a single host or delete this section to allow pushing to any host.
    # if spec.respond_to?(:metadata)
    #    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
    #  else
    #    raise "RubyGems 2.0 or newer is required to protect against " \
    #      "public gem pushes."
    #  end

    spec.files         = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
    end
    spec.bindir        = 'exe'
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ['lib']

    spec.add_development_dependency 'bundler', '~> 1.13'
    spec.add_development_dependency 'rake', '~> 10.0'
    spec.add_development_dependency 'rspec', '~> 3.0'
    spec.add_development_dependency 'awesome_print', '~> 0.1'
    spec.add_development_dependency 'rest-client', '~> 2.0'
    spec.add_development_dependency 'json', '~> 1.8'
    spec.add_development_dependency 'colorize', '~> 0.8'
    spec.add_development_dependency 'test-unit', '~> 3.1'
    spec.add_development_dependency 'json-schema', '~> 2.0'
end
