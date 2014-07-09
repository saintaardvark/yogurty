;; FIXME:  Need to account for when notes directory not present.
(ert-deftest yogurty-test/open-org-file-for-rt-ticket-happy-path ()
  "Open the right notes file for a ticket if clocked in."
  (my-org-file-fixture
   (lambda ()
     (yogurty-insert-rt-ticket-into-org-generic "2350" "Communitize thought leadership")
     (yogurty-open-org-file-for-rt-ticket)
     (should (equal (buffer-file-name) "/home/hugh/git/rt_2350/notes.org")))))

(ert-deftest yogurty-test/open-org-file-for-rt-ticket-sad-path ()
  "Don't open notes file for a ticket if not clocked in."
  (my-org-file-fixture
   (lambda ()
     (unwind-protect
	 (yogurty-open-org-file-for-rt-ticket))
      (should (equal (buffer-file-name) yogurty-org-file)))))
