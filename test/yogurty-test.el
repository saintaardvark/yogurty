(defvar rt-test-string "[rt.example.com #2341] opt-out for google analytics on website")

;; (defun my-fixture (body)
;;   (unwind-protect
;;       (progn [set up]
;; 	     (funcall body))
;;     [tear down]))

;;      (ert-deftest my-test ()
;;        (my-fixture
;;         (lambda ()
;;           [test code])))

(defun my-email-fixture (body)
  (unwind-protect
      (progn
	(with-temp-buffer
	  (insert-string "From: <aardvark@saintaardvarkthecarpeted.com>")
	  (insert-string "To: <rt@example.com>")
	  (insert-string "Subject: [rt.example.com #2341] opt-out for google analytics on website")
	  (goto-char (point-min))
	  (funcall body)))))

;; Ticket that's not in the org-file fixture.
(defun my-email-fixture-new-ticket (body)
  (unwind-protect
      (progn
	(with-temp-buffer
	  (insert-string "From: <aardvark@saintaardvarkthecarpeted.com>")
	  (insert-string "To: <rt@example.com>")
	  (insert-string "Subject: [rt.example.com #2355] /dev/bollocks should not wait on /dev/random")
	  (goto-char (point-min))
	  (funcall body)))))

(defun my-org-fixture (body)
  (unwind-protect
      (progn
	(with-temp-buffer
	  (insert-string "* RT #2341 -- Big cloud my .emacs file\n")
	  (insert-string "** RT #2342 -- opt-out for google analytics on website\n")
	  (insert-string "*** RT #2343 -- Memory foam for my smartphone\n")
	  (goto-char (point-min))
	  (funcall body)))))

;; There's a problem here: the kill-buffer is needed to fully reset
;; the org file in between invocations -- otherwise, we get multiple
;; occurrences of these strings, one set after another.  But when we
;; kill the buffer, org pops up and says "Hey, need to clock out?"
;; (Because at least some functions clock in when we run them.)
;; That's because org.el has this bit:
;;
;; Check for running clock before killing a buffer
;; (org-add-hook 'kill-buffer-hook 'org-check-running-clock nil 'local)
;;
;; So, we use remove-hook to take that out, with a non-nil arg to say
;; that it's just for this buffer.
;;
;; FIXME: Might want to change the name of this test to be a bit
;; clearer that we're fiddling with the hook this way.

(defun my-org-file-fixture (body)
  (unwind-protect
      (progn
	(with-sandbox-org-file
	 (set-buffer (find-file-noselect yogurty-org-file))
	 (remove-hook 'kill-buffer-hook 'org-check-running-clock t)
	 (insert-string "* RT #2347 -- Leverage more synergy\n")
	 (insert-string "** RT #2348 -- Rewrite Emacs in Go\n")
	 (insert-string "*** RT #2349 -- Port node.js to Java\n")
	 (goto-char (point-min))
	 (save-buffer 0)
	 (funcall body)
	 (org-clock-out nil t)
	 (org-save-all-org-buffers)
	 ;; FIXME: This is causing problems for yogurty-test/open-org-file-for-rt-ticket-happy-path below.
	 ;; This is because the defun it's testing, yogurty-open-org-file-for-rt-ticket, does not check to see
	 ;; whether the containing directory for the notes file actually exists.  This is fine in practice, because
	 ;; the user will get prompted to create the directory when saving the file.  If I comment out this
	 ;; save-buffer, then this particular test passes, and all *other* tests pass too.  Given that a) we're
	 ;; about to kill the buffer, b) that I've run org-save-all-org-buffers above mainly c) as a way to
	 ;; have a problematic org file around in case of test failure, I think I'm okay removing this save.
	 ;; (save-buffer 0)
	 (kill-buffer)))))

;; Name for tests: yogurty-test/function-name-short-description-if-necessary






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

(ert-deftest yogurty-test/insert-rt-ticket-commit-comment ()
  "Test return code."
  (my-org-file-fixture
   (lambda ()
     (yogurty-insert-rt-ticket-into-org-generic "2350" "Communitize thought leadership")
     (save-buffer)
     (with-temp-buffer
       (yogurty-insert-rt-ticket-commit-comment)
       (beginning-of-line)
       (should (looking-at "see RT #2350 for details."))))))

;; Wah, there's a lot to test with this one (and doubtless many
;; others):
;; - new ticket gets inserted
;; - already-existing ticket not duplicated
;; - clocking in works
;; - *not* clocking in works.

(ert-deftest yogurty-test/insert-rt-ticket-into-org-from-rt-email-already-existing-ticket ()
  "Make sure ticket ends up in org file."
  (my-org-file-fixture
   (lambda ()
     (my-email-fixture-new-ticket
      (lambda ()
	(yogurty-insert-rt-ticket-into-org-from-rt-email)
	(should (equal (yogurty-find-rt-ticket-in-org-file "2355") 4)))))))

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

;; (ert-deftest yogurty-test/wha-happened ()
;;   "Debugging."
;;   (my-org-file-fixture
;;    (lambda ()
;;      (my-email-fixture-new-ticket		;
;;       (lambda ()
;; 	(message "Hello, world!")
;; 	(message yogurty-org-file))))))


;; (ert-deftest yogurty-test/right-subjectline-for-ticket-inserted-into-org-file ()
;;   "Should find already-existing RT ticket in org buffer."
;;   (my-org-file-fixture
;;      (lambda ()
;;        (yogurty-insert-rt-ticket-into-org-generic "2346" "eBiz it up a notch")
;;        (save-buffer)
;;        (should (equal (org-find-matching-headline-from-in-org-file "2346") "RT 2346 -- eBiz it up a notch")))))
