# General.
When(/^I visit (.+)$/) do |url|
  visit(url)
end

When(/^I click "(.+)"$/) do |link|
  click_link link
end

Then(/^I should see "(.+)" in the main content$/) do |text|
  within('[ng-view]') do
    expect(page).to have_content(text)
  end
end

