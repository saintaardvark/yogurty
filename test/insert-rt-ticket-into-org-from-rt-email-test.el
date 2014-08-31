(ert-deftest yogurty-test/insert-rt-ticket-into-org-from-rt-email-new-ticket ()
  "Make sure new ticket ends up in org file."
  (my-org-file-fixture
   (lambda ()
     (my-email-fixture-new-ticket
      (lambda ()
	(yogurty-insert-rt-ticket-into-org-from-rt-email)
	(should (equal (yogurty-find-rt-ticket-in-org-file "2355") 4)))))))
