Feature: GET on a unknown tuple
  In order to detect the absence of a specific tuple
  As a REST client
  I want to receive a 404 when a tuple GET fails

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: GET on a missing supplier

    Given I make a GET on /suppliers/3
    Then the status should be 404
