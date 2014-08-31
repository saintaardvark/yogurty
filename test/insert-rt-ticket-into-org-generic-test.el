;; Wah, there's a lot to test with this one (and doubtless many
;; others):
;; - new ticket gets inserted
;; - already-existing ticket not duplicated
;; - clocking in works
;; - *not* clocking in works.

;; Note: previous version of this test used "progn" to do a bunch of
;; things, and I think this messed with the order of evaluation.
;; Don't do that.
(ert-deftest yogurty-test/insert-rt-ticket-into-org-generic ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
     (lambda ()
       (yogurty-insert-rt-ticket-into-org-generic "2346" "eBiz it up a notch" 166)
       (save-buffer)
       (should (equal (yogurty-find-rt-ticket-in-org-file "2346") 4)))))

(ert-deftest yogurty-test/insert-rt-ticket-into-org-generic-correct-subject-line ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
     (lambda ()
       (yogurty-insert-rt-ticket-into-org-generic "2346" "eBiz it up a notch" 1)
       (save-buffer)
       (goto-char (point-min))
       (goto-line (yogurty-find-rt-ticket-org-headline-in-buffer "2346"))
       (should (equal (looking-at (rx bol "** RT #2346 -- eBiz it up a notch")) t)))))

(ert-deftest yogurty-test/insert-rt-ticket-into-org-generic-check-new-ticket-insert ()
  "Make sure new ticket gets added."
  (my-org-file-fixture
     (lambda ()
       (yogurty-insert-rt-ticket-into-org-generic "2346" "eBiz it up a notch" 166)
       (save-buffer)
       (should (equal (yogurty-find-rt-ticket-in-org-file "2346") 4)))))

(ert-deftest yogurty-test/insert-rt-ticket-into-org-generic-already-existing-ticket ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
     (lambda ()
       (yogurty-insert-rt-ticket-into-org-generic "2348" "Rewrite Emacs in Go" 166)
       (save-buffer)
       ;; (should (equal (yogurty-find-rt-ticket-in-org-file "2348") 2)))))
       ;; Better test: make sure there's only one occurrence of the headline.
       (goto-char (point-min))
       (should (equal (count-matches (rx bol "** RT #2348 -- Rewrite Emacs in Go")) 1)))))
