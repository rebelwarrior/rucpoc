Feature: Import

  Scenario: Succesfully importing CSV
    Given Im logged in.
    When I select CSV for import 
    And import.
    Then The database is populated correctly
  
  Scenario: Unsuccessfully importing CSV
    Given Im loggend in.
    When I select an incoreclty formated CSV for import 
    And import
    Then I see an error message. 
    And the database is intact.