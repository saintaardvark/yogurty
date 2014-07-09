(ert-deftest yogurty-test/find-rt-ticket-subject-from-email ()
  "Should find ticket subject from email."
  (my-email-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-subject-from-rt-email) "opt-out for google analytics on website")))))
