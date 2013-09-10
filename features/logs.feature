Feature: Logs Feature

  Scenario: Adding a log item
    Given   I am logged in as test_user
    And     I am on the show collection page
    When    I hit the add item to the log(bitacora)
    And     Save the log
    Then    Expect the log to belong_to test_user and collection
    And     Expect to see log with user name on collection page.
    
  Scenario: Regular user tries to delete log
    Given   I'm not logged in as an admin
    When    I send a delete message to logs controller
    Then    The log item is still present