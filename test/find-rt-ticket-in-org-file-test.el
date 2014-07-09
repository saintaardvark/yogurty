(ert-deftest yogurty-test/find-rt-ticket-in-org-file-level-1-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-in-org-file "2347") 1)))))

(ert-deftest yogurty-test/find-rt-ticket-in-org-file-level-2-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-in-org-file "2348") 2)))))

(ert-deftest yogurty-test/find--rt-ticket-in-org-file-level-3-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-in-org-file "2349") 3)))))
