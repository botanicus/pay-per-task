# General.
When(/^I visit (.+)$/) do |url|
  visit(url)
end

When(/^I click "(.+)"$/) do |link|
  click_link link
end

Then(/^I should see "(.+)"$/) do |text|
  expect(page).to have_content(text)
end

