(ert-deftest yogurty-test/scheedule-rt-ticket-for-today-from-rt-email ()
  "Make sure RT ticket scheduled for today."
  (my-org-file-fixture
   (lambda ()
     (my-email-fixture-new-ticket
      (lambda ()
	(yogurty-schedule-rt-ticket-for-today-from-rt-email)
	(find-file yogurty-org-file)
	(save-buffer)
	(goto-line (yogurty-find-rt-ticket-in-org-file "2355"))
	(next-line)
	(forward-word)
	(backward-word)
	;; FIXME: Should use Org date string stuff
	(should (looking-at (format-time-string "SCHEDULED: <%Y-%m-%d %a>"))))))))


(ert-deftest yogurty-test/schedule-rt-ticket-for-today-generic-no-previous-schedule ()
  "Make sure RT ticket scheduled for today."
  (my-org-file-fixture
   (lambda ()
     (yogurty-schedule-rt-ticket-for-today-generic 2348)
     (find-file yogurty-org-file)
     (save-buffer)
     (goto-line (yogurty-find-rt-ticket-in-org-file "2348"))
     (next-line)
     (forward-word)
     (backward-word)
     ;; FIXME: Should use Org date string stuff
     (should (looking-at (format-time-string "SCHEDULED: <%Y-%m-%d %a>"))))))

(ert-deftest yogurty-test/schedule-rt-ticket-for-today-generic-overwrite-previous-schedule ()
  "Make sure we override any previous scheduling."
  (my-org-file-fixture
   (lambda ()
     (goto-line (yogurty-find-rt-ticket-in-org-file "2348"))
     (org-schedule nil "-7d")
     (message (buffer-string))
     (save-buffer)
     (yogurty-schedule-rt-ticket-for-today-generic 2348)
     (find-file yogurty-org-file)
     (save-buffer)
     (next-line)
     (forward-word)
     (backward-word)
     ;; FIXME: Should use Org date string stuff
     (should (looking-at (format-time-string "SCHEDULED: <%Y-%m-%d %a>"))))))
