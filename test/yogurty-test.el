(defvar rt-test-string "[rt.example.com #2341] opt-out for google analytics on website")

(ert-deftest yogurty/find-ticket-from-string ()
  "Should find ticket subject from string."
  (should (equal (yogurty-find-rt-ticket-subject-from-string rt-test-string) "2341")))
