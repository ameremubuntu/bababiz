Feature: price check on eBay

Scenario: Find product X listed prices from first search results page
    Then I cleanup
    Given I navigate to eBay
    And I search for "HDMI cable"
    And I filter search results by "Buy It Now"
    Then I list all listed products prices on the page


    
    







    

    