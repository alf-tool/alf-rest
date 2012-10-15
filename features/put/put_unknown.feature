Feature: PUT of a unknown tuple
  In order to detect the absence of a specific tuple
  As a REST client
  I want to receive a 404 when a tuple PUT fails

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: PUT on an unexisting supplier

    Given the body of the next request is the following suppliers tuple:
      | status |   city |
      |     30 |  Paris |
    And I make a PUT on /suppliers/3

    Then the status should be 404
    And the body should be empty
