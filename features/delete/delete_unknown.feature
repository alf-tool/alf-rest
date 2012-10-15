Feature: DELETE of a unknown tuple
  In order to detect the absence of a specific tuple
  As a REST client
  I want to receive a 404 when a tuple DELETE fails

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: DELETE on an unexisting supplier

    Given I make a DELETE on /suppliers/3
    Then the status should be 404
    And the body should be empty
