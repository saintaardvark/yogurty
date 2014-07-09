;; FIXME: This next test was failing when I used ticket number that
;; *already existed* in the org file fixture; it was clocking in on
;; the task above it.  yogurty-insert-rt-ticket-into-org-generic
;; searched for a matching ticket, did not find it (FIXME: I think)
;; and so clocked in on the first ticket in the file -- not the
;; correct one.  If that's the case, I need a better test for this, or
;; to figure out what I've done wrong in that test.

;; As a result, when we in, we're clocking in on the one above it:
;; 2347, leverage-more-synergy.

;; Thus: we need a new test for that error!

;; (ert-deftest yogurty-test/clocked-into-rt-ticket-number-only ()
;;   "Should get ticket number that we're clocked into."
;;   (my-org-file-fixture
;;    (lambda ()
;;      (yogurty-insert-rt-ticket-into-org-generic "2348" "Communitize thought leadership" 1)
;;      (save-buffer)
;;      (should (equal (yogurty-clocked-into-rt-ticket-number-only) "2348")))))

;; save-buffer here and elsewhere not strictly needed, but a good bit
;; of housekeeping.
(ert-deftest yogurty-test/clocked-into-rt-ticket-number-only-new-ticket ()
  "Should get ticket number that we're clocked into."
  (my-org-file-fixture
   (lambda ()
     (yogurty-insert-rt-ticket-into-org-generic "2350" "Communitize thought leadership")
     (save-buffer)
     (should (equal (yogurty-clocked-into-rt-ticket-number-only) "2350")))))

;; FIXME: So this test is for the situation above: inserting a ticket
;; when there's already one in there with that number.  There are two
;; things to think about here: first, should we update the org entry
;; if the subject line is different?  (This could probably be
;; configurable, or dependable on an argument.)  Second, make sure
;; that we're clocking into the right damn ticket -- because right
;; now, we're not.
(ert-deftest yogurty-test/clocked-into-rt-ticket-number-only-matching-ticket ()
  "Should get ticket number that we're clocked into."
  (my-org-file-fixture
   (lambda ()
     (yogurty-insert-rt-ticket-into-org-generic "2348" "Communitize thought leadership")
     (save-buffer)
     (should (equal (yogurty-clocked-into-rt-ticket-number-only) "2348")))))
