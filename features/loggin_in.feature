Feature: Logging in

  Scenario: Unsuccessful signin
    Given  a user visits the login page
    When   he submits invalid login information
    Then   he should see and error message
    
  Scenario: Successful login
    Given a user visits the sigin page
    And   the user has an account
    When  the user submits valid signin information
    Then  he should see his profile page
    And   he should see a logout link