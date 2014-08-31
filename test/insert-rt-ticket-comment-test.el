(ert-deftest yogurty-test/insert-rt-ticket-commit-comment ()
  "Test return code."
  (my-org-file-fixture
   (lambda ()
     (yogurty-insert-rt-ticket-into-org-generic "2350" "Communitize thought leadership")
     (save-buffer)
     (with-temp-buffer
       (yogurty-insert-rt-ticket-commit-comment)
       (beginning-of-line)
       (should (looking-at "see RT #2350 for details."))))))
