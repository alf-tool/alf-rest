Feature: PUT of a specific tuple
  In order to update a specific tuple
  As a REST client
  I want to send a PUT request specifying its id

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: PUT on /suppliers/1

    Given the body of the next request is the following suppliers tuple:
      | status |   city |
      |     30 |  Paris |
    And I make a PUT on /suppliers/1

    Then the status should be 200
    And the body should be a JSON object
    And a decoded suppliers tuple should equal:
      | sid |  name |  status |   city |
      |   1 | Smith |      30 |  Paris |
