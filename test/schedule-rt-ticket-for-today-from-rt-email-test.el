(ert-deftest yogurty-test/scheedule-rt-ticket-for-today-from-rt-email ()
  "Make sure RT ticket scheduled for today."
  (my-org-file-fixture
   (lambda ()
     (my-email-fixture-new-ticket
      (lambda ()
	(yogurty-insert-rt-ticket-into-org-from-rt-email)
	(save-excursion
	  (find-file yogurty-org-file)
	  (goto-line (yogurty-find-rt-ticket-in-org-file "2355"))
	  (next-line)
	  (message (buffer-string))
	  (should (looking-at "foo bar baz"))))))))

(ert-deftest yogurty-test/schedule-rt-ticket-for-today-generic ()
  "Make sure RT ticket scheduled for today."
  (my-org-file-fixture
   (lambda ()
     (yogurty-schedule-rt-ticket-for-today-generic 2348)
     (find-file yogurty-org-file)
     (goto-line (yogurty-find-rt-ticket-in-org-file "2348"))
     (next-line)
     (message (buffer-string))
     (should (looking-at "SCHEDULED: <2014-08-31 Sun>")))))
