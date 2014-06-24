#!/opt/rubies/rbx-2.2.6/bin/gem build

Gem::Specification.new do |s|
  s.name              = 'ppt'
  s.version           = '0.0.1'
  s.date              = Date.today.to_s
  s.authors           = ['https://github.com/botanicus']
  s.summary           = 'Library for http://pay-per-task.com.'
  s.description       = 'Containts models, AMQP helpers and shit.'
  s.email             = 'james@101ideas.cz'
  s.homepage          = 'http://pay-per-task.com'
  s.rubyforge_project = s.name
  s.license           = 'closed source'

  s.files             = ['README.md', *Dir.glob('**/*.rb')]

  s.add_runtime_dependency('amq-client')
  s.add_runtime_dependency('simple-orm')
end
