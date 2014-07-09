(ert-deftest yogurty-test/find-rt-ticket-org-headline-in-buffer-level-1-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-org-headline-in-buffer "2341") 1)))))

(ert-deftest yogurty-test/find-rt-ticket-org-headline-in-buffer-level-2-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-org-headline-in-buffer "2342") 2)))))

(ert-deftest yogurty-test/find-rt-ticket-org-headline-in-buffer-level-3-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-org-headline-in-buffer "2343") 3)))))

(ert-deftest yogurty-test/find-rt-ticket-org-headline-in-buffer-sad-path-part-match ()
  "Should return nil for non-existing RT ticket in org buffer."
  (my-org-fixture
   (lambda ()
     (should (equal (yogurty-find-rt-ticket-org-headline-in-buffer "234") nil)))))

(ert-deftest yogurty-test/find-rt-ticket-org-headline-in-buffer-sad-path-complete-mismatch ()
  "Should return nil for non-existing RT ticket in org buffer."
  (my-org-fixture
   (lambda ()
     (should (equal (yogurty-find-rt-ticket-org-headline-in-buffer "5678") nil)))))
