Feature: PATCH of a unknown tuple
  In order to detect the absence of a specific tuple
  As a REST client
  I want to receive a 404 when a tuple PATCH fails

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: PATCH on an unexisting supplier

    Given the JSON body of the next request is the following suppliers tuple:
      | status |   city |
      |     30 |  Paris |
    And I make a PATCH on /suppliers/3

    Then the status should be 404
