@smoke
Feature: The index page
  As a visitor
  I want to be able to see the list of blog posts.
  So that I can read them.

Scenario: Going to the index page
  When I visit "/"
  Then I should see "Hello world" in the main content
