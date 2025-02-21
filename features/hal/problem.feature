Feature: Error handling valid according to RFC 7807 (application/problem+json)
  In order to be able to handle error client side
  As a client software developer
  I need to retrieve an RFC 7807 compliant serialization of errors

  Scenario: Get an error
    When I add "Content-Type" header equal to "application/json"
    And I add "Accept" header equal to "application/json"
    And I send a "POST" request to "/dummies" with body:
    """
    {}
    """
    Then the response status code should be 422
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/problem+json; charset=utf-8"
    And the JSON should be equal to:
    """
    {
      "type": "/validation_errors/c1051bb4-d103-4f74-8988-acbcafc7fdc3",
      "title": "An error occurred",
      "detail": "name: This value should not be blank.",
      "status": "422",
      "violations": [
        {
          "propertyPath": "name",
          "message": "This value should not be blank.",
          "code": "c1051bb4-d103-4f74-8988-acbcafc7fdc3"
        }
      ]
    }
    """

  Scenario: Get an error during deserialization of simple relation
    When I add "Content-Type" header equal to "application/json"
    And I add "Accept" header equal to "application/json"
    And I send a "POST" request to "/dummies" with body:
    """
    {
      "name": "Foo",
      "relatedDummy": {
        "name": "bar"
      }
    }
    """
    Then the response status code should be 400
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/problem+json; charset=utf-8"
    And the JSON node "type" should be equal to "/errors/400"
    And the JSON node "title" should be equal to "An error occurred"
    And the JSON node "detail" should be equal to 'Nested documents for attribute "relatedDummy" are not allowed. Use IRIs instead.'
    And the JSON node "trace" should exist
