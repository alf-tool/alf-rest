Feature: POST on a collection url, with a single tuple
  In order to insert a single tuple
  As a REST client
  I want to make POST requests to a collection url with a single tuple

  Background:
    Given the following suppliers relation is mapped under /suppliers:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |

  Scenario: POST to /suppliers with a tuple

    Given the JSON body of the next request is the following suppliers tuple:
      | sid |  name |  status |   city |
      |   3 | Blake |      30 |  Paris |
    And I make a POST to /suppliers

    Then the status should be 201
    And the content type should be application/json
    And the body should be a JSON object
    And a decoded suppliers tuple should equal:
      | sid |  name |  status |   city |
      |   3 | Blake |      30 |  Paris |

    Given I make a GET on /suppliers
    Then a decoded suppliers relation should equal:
      | sid |  name |  status |   city |
      |   1 | Smith |      20 | London |
      |   2 | Jones |      10 |  Paris |
      |   3 | Blake |      30 |  Paris |
