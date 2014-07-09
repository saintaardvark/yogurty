;; FIXME: Need sad-path tests for this -- give it a bogus string and
;; make sure it fails.
(ert-deftest yogurty-test/find-ticket-number-from-string ()
  "Should find ticket subject from string."
  (should (equal (yogurty-find-rt-ticket-number-from-string rt-test-string) "2341")))

(ert-deftest yogurty-test/find-ticket-subject-from-string ()
  "Should find ticket subject from string."
  (should (equal (yogurty-find-rt-ticket-subject-from-string rt-test-string) "opt-out for google analytics on website")))
