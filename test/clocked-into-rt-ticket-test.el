(ert-deftest yogurty-test/clocked-into-rt-ticket-happy-path ()
  "Make sure we can detect when we're clocked in."
  (my-org-file-fixture
   (lambda ()
     (my-email-fixture-new-ticket
      (lambda ()
	(yogurty-insert-rt-ticket-into-org-from-rt-email)
	(should (equal (yogurty-clocked-into-rt-ticket) "RT #2355")))))))

;; This test failed, but only if run in after
;; yogurty-test/clocked-into-rt-ticket-number-only-new-ticket.  If run
;; on its own it worked; if run as part of big batch it failed; if run
;; after clocked-into, it failed.  I added org-clock-out to the
;; fixtuure above, a that seems to have fixed things.  However, I'm
;; leaving this note here because I'm suspicious that it'll crop up
;; again.
(ert-deftest yogurty-test/clocked-into-rt-ticket-sad-path-not-clocked-in ()
  "Make sure we can detect when we're clocked in."
  (my-org-file-fixture
   (lambda ()
     (my-email-fixture-new-ticket
      (lambda ()
	(should (equal (yogurty-clocked-into-rt-ticket) nil)))))))
