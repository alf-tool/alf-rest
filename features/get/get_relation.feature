Feature: GET on a full relation
  In order to use a specific relation
  As a REST client
  I want to receive it through a GET request

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: GET on /suppliers

    Given I make a GET on /suppliers
    Then the status should be 200
    And the content type should be application/json
    And the body should be a JSON array
    Then a decoded suppliers relation should equal:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |
