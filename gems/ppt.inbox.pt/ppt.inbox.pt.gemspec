#!/opt/rubies/rbx-2.2.6/bin/gem build

require 'securerandom'

Gem::Specification.new do |s|
  s.name              = 'ppt.inbox.pt'
  s.version           = '0.0.1'
  s.date              = Date.today.to_s
  s.authors           = ['James C Russell']
  s.summary           = SecureRandom.hex
  s.description       = SecureRandom.hex
  s.email             = 'james@101ideas.cz'
  s.homepage          = 'http://pay-per-task.com'
  s.rubyforge_project = s.name
  s.license           = 'closed source'

  s.files             = ['README.md', *Dir.glob('**/*.rb')]
  s.executables       = ['ppt.inbox.pt.rb']

  s.add_runtime_dependency('ppt', '~> 0')
end
