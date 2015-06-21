@tests
Feature: Kitchen sink sample features
  Login into application

  @san1
  Scenario: Verify Labels
    Given I am Home screen
    When I choose "Label" on home screen
    Then I wait to see "Basic"
    When I press "Basic"
    Then I wait to see "Appcelerator"
    When I press "Hide/Show"
    Then I must not see "Appcelerator"
    When I press "Hide/Show"
    Then I wait to see "Appcelerator"

  @san2
  Scenario: Verify Search bar
    Given I am Home screen
    When I choose "Search Bar" on home screen
    Then I wait to see "Search Bar"
    When I clear text from search bar
    When I enter text "Titanium tests"
    Then I wait to see text "Titaniu1m tests"





