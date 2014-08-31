;; We're testing the are-we-clocked-in? part in clocked-int-rt-ticket-test.el.
(ert-deftest yogurty-test/insert-rt-ticket-into-org-from-rt-email-new-ticket ()
  "Make sure new ticket ends up in org file."
  (my-org-file-fixture
   (lambda ()
     (my-email-fixture-new-ticket
      (lambda ()
	(yogurty-insert-rt-ticket-into-org-from-rt-email)
	(should (equal (yogurty-find-rt-ticket-in-org-file "2355") 4)))))))

(ert-deftest yogurty-test/insert-rt-ticket-into-org-from-rt-email-dont-clock-in ()
  "Test that we don't clock in when arg provided."
  (my-org-file-fixture
   (lambda ()
     (my-email-fixture-new-ticket
      (lambda ()
	(yogurty-insert-rt-ticket-into-org-from-rt-email 1)
	(should (equal (yogurty-clocked-into-rt-ticket) nil)))))))
