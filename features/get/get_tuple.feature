Feature: GET on a single tuple
  In order to use a specific tuple
  As a REST client
  I want to receive it through a GET request specifying its id

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: GET on /suppliers/1

    Given I make a GET on /suppliers/1
    Then the status should be 200
    And the content type should be application/json
    And the body should be a JSON object
    And a decoded suppliers tuple should equal:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
