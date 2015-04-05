# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuckoo/version'

Gem::Specification.new do |spec|
  spec.name          = "cuckoo"
  spec.version       = Cuckoo::VERSION
  spec.authors       = ["Dave Sullivan"]
  spec.email         = ["dave@dave-sullivan.com"]

  spec.summary       = "A cuckoo clock."
  spec.description   = "A cuckoo clock."
  spec.homepage      = "https://github.com/demsullivan/cuckoo"

  spec.files         =
    Dir['bin/**/*'] +
    Dir['lib/**/*'] +
    Dir['spec/**/*'] +
    ['README.md']
                   
  spec.bindir        = "bin"
  spec.executables   = ["cko"]
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency "chronic",          "~> 0.10.2"
  spec.add_dependency "chronic_duration", "~> 0.10.6"
  # spec.add_dependency "rest-client",      "1.8.0"
  # spec.add_dependency "ruby-trello",      "~> 1.2.1"
  spec.add_dependency "pivotal-tracker",  "~> 0.5.13"
  spec.add_dependency "activerecord",     "~> 4.2.1"
  spec.add_dependency "sqlite3",          "~> 1.3.10"
  spec.add_dependency "skywalker"
  spec.add_dependency "celluloid",        "0.16.0"
  spec.add_dependency "pg"
  
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rspec", "~> 3.2"
end
