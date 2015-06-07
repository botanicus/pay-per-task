require 'capybara/cucumber'

if ENV['BROWSER']
  # Selenium.
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: ENV['BROWSER'].to_sym)
  end
else
  # PhantomJS.
  require 'capybara/poltergeist'
  Capybara.default_driver = :poltergeist
end

Capybara.app_host = 'http://pay-per-task.dev/'
Capybara.run_server = false

# Hooks
Before do |scenario|
  visit '/'
end

After do |scenario|
  slug = scenario.title.delete("'").tr(' ', '_').downcase
  if ENV['DBG'] && scenario.failed?
    Dir.mkdir('tmp')
    save_and_open_screenshot("tmp/#{slug}.png")
  elsif ENV['CI'] && scenario.failed?
    path = File.join(ENV['CIRCLE_ARTIFACTS'], "#{slug}.png")
    save_screenshot(path)
  end
end
