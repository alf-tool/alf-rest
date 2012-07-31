Feature: PATCH of a specific tuple
  In order to update a specific tuple
  As a REST client
  I want to send a PATCH request specifying its id

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: PATCH on /suppliers/1

    Given the JSON body of the next request is the following suppliers tuple:
      | status |   city |
      |     30 |  Paris |
    And I make a PATCH on /suppliers/1

    Then the status should be 200
    And the body should be a JSON object
    And a decoded suppliers tuple should equal:
      | sid |  name |  status |   city |
      |   1 | Smith |      30 |  Paris |
