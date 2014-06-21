#!/opt/rubies/rbx-2.2.6/bin/gem build

Gem::Specification.new do |s|
  s.name              = 'ppt.inbox.backup'
  s.version           = '0.0.1'
  s.date              = Date.today.to_s
  s.authors           = ['https://github.com/botanicus']
  s.summary           = 'TODO'
  s.description       = 'TODO 2'
  s.email             = 'james@101ideas.cz'
  s.homepage          = 'http://pay-per-task.com'
  s.rubyforge_project = s.name
  s.license           = 'Closed source. Never ever ever ever touch this shit or I will go medieval on your arse!'

  s.files             = ['README.md', *Dir.glob('**/*.rb')]
end
