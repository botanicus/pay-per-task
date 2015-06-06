require 'capybara/cucumber'

if ENV['BROWSER']
  # Selenium.
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: ENV['BROWSER'].to_sym)
  end
else
  # PhantomJS.
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
end

Capybara.app_host = 'http://pay-per-task.dev/'
Capybara.run_server = false

# Hooks
Before do |scenario|
  visit '/'
end

After do |scenario|
  if ENV['DBG'] && scenario.failed?
    save_and_open_screenshot
  end
end
