Feature: DELETE of a full relation
  In order to empty a relation variable
  As a REST client
  I want to send a DELETE request to its url

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: DELETE on /suppliers

    Given I make a DELETE on /suppliers
    Then the status should be 204
    And the body should be empty

    Given I make a GET on /suppliers
    Then a decoded suppliers relation should be empty
