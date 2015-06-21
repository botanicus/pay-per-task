require 'capybara/cucumber'

if ENV['BROWSER']
  # Selenium.
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: ENV['BROWSER'].to_sym)
  end

  Capybara.default_driver = :selenium
else
  # PhantomJS.
  require 'capybara/poltergeist'
  Capybara.default_driver = :poltergeist
end

Capybara.app_host = "http://#{ENV['SITE'] || 'pay-per-task.dev'}/"
Capybara.run_server = false

# Hooks
Before do |scenario|
  visit '/'
end

After do |scenario|
  if scenario.failed?
    slug = scenario.title.delete("'").tr(' ', '_').downcase
    path = File.join(ENV['SCREENSHOT_DIR'] || 'tmp', "#{slug}.png")

    save_screenshot(path)
    # TODO: On CI, this never goes to console.
    # It's important there since we don't fail early.
    puts "~ Scenario #{title} failed, screenshot saved to #{path}"
  end
end
