Feature: Clock into task from email

  Background:
    Given I switch to buffer "*yogurty*"
    And I clear the buffer
    And I insert:
      """
      From: <aardvark@saintaardvarkthecarpeted.com>
      To: <rt@example.com>
      Subject: [rt.example.com #2341] opt-out for google analytics on website
      """
    And I go to the beginning of the buffer
    And I bind key "C-c o t" to "yogurty-insert-rt-ticket-into-org-from-rt-email"
    And I bind key "C-c o c" to "yogurty-clocked-into-rt-ticket"
    And I open temp file "yogurty.org"
    And I insert:
      """

      """
    And I set "yogurty-org-file" to "yogurty.org"

  Scenario: Clock in and verify org-clock-current-task
    When I press "C-c o t"
    And  I press "C-c o c"
    Then I should see message "RT #2341"
