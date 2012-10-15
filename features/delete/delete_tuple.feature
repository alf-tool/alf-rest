Feature: DELETE of a specific tuple
  In order to delete a specific tuple
  As a REST client
  I want to send a DELETE request specifying its id

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: DELETE on /suppliers/1

    Given I make a DELETE on /suppliers/1
    Then the status should be 204
    And the body should be empty

    Given I make a GET on /suppliers
    Then a decoded suppliers relation should equal:
      | sid |  name |  status |   city |
      |   2 | Jones |      10 |  Paris |
