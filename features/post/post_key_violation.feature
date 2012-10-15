Feature: POST that violates a key constraint
  In order to detect key violations
  As a REST client
  I want POST requests failures to be clearly stated through a 400 status

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: POST with a tuple that violates the primary key

    Given the body of the next request is the following suppliers tuple:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
    And I make a POST to /suppliers

    Then the status should be 400
    And the body should be empty
