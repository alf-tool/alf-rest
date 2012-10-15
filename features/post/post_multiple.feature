Feature: POST on a collection url, with many tuples
  In order to insert many tuples at once
  As a REST client
  I want to make POST requests to a collection url with a json array

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |

  Scenario: POST to /suppliers with a tuple

    Given the body of the next request is the following suppliers tuples:
      | sid |  name |  status |   city |
      |   2 | Jones |      10 |  Paris |
      |   3 | Blake |      30 |  Paris |
    And I make a POST to /suppliers

    Then the status should be 201
    And the body should be empty

    Given I make a GET on /suppliers
    Then a decoded suppliers relation should equal:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |
      |   3 | Blake |      30 |  Paris |
