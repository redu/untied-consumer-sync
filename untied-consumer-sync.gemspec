# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'untied-consumer-sync/version'

Gem::Specification.new do |gem|
  gem.name          = "untied-consumer-sync"
  gem.version       = Untied::Consumer::Sync::VERSION
  gem.authors       = ["Igor Calabria", "Guilherme Cavalcanti", "Tiago Ferreira", "Juliana Lucena"]
  gem.email         = ["igor.calabria@gmail.com", "guiocavalcanti@gmail.com", "fltiago@gmail.com", "julianalucenaa@gmail.com"]
  gem.description   = %q{Untied Consumer Synchronizer.}
  gem.summary       = %q{Process the messages comming from your Untied::Publisher and syncs it directly to the database.}
  gem.homepage      = "http://github.com/redu/untied-consumer-sync"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'activerecord'

  gem.add_runtime_dependency 'untied-consumer', '~> 0.0.5'
  gem.add_runtime_dependency 'configurable'

  if RUBY_VERSION < "1.9"
    gem.add_development_dependency "ruby-debug"
  else
    gem.add_development_dependency "debugger"
  end
end
