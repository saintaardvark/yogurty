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

(defun my-fixture (body)
  (unwind-protect
      (progn
	(with-temp-buffer
	  (insert-string "From: <aardvark@saintaardvarkthecarpeted.com>")
	  (insert-string "To: <rt@example.com>")
	  (insert-string "Subject: [rt.example.com #2341] opt-out for google analytics on website")
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

(defun my-org-file-fixture (body)
  (unwind-protect
      (progn
	(with-sandbox-org-file
	 (set-buffer (find-file-noselect yogurty-org-file))
	 (insert-string "* RT #2341 -- Big cloud my .emacs file\n")
	 (insert-string "** RT #2342 -- opt-out for google analytics on website\n")
	 (insert-string "*** RT #2343 -- Memory foam for my smartphone\n")
	 (goto-char (point-min))
	 (save-buffer 0)
	 (funcall body)))))

; (my-fixture (lambda () (message (yogurty-find-rt-ticket-subject-from-rt-email))))

(ert-deftest yogurty/find-ticket-number-from-string ()
  "Should find ticket subject from string."
  (should (equal (yogurty-find-rt-ticket-number-from-string rt-test-string) "2341")))

(ert-deftest yogurty/find-ticket-subject-from-string ()
  "Should find ticket subject from string."
  (should (equal (yogurty-find-rt-ticket-subject-from-string rt-test-string) "opt-out for google analytics on website")))

(ert-deftest yogurty/find-rt-ticket-subject-from-email ()
  "Should find ticket subject from email."
  (my-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-subject-from-rt-email) "opt-out for google analytics on website")))))

(ert-deftest yogurty/find-rt-ticket-number-from-email ()
  "Should find ticket subject from email."
  (my-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-number-from-rt-email) "2341")))))

(ert-deftest yogurty/find-already-existing-rt-ticket-in-buffer-level-1-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-org-headline-in-buffer "2341") 1)))))

(ert-deftest yogurty/find-already-existing-rt-ticket-in-buffer-level-2-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-org-headline-in-buffer "2342") 2)))))

(ert-deftest yogurty/find-already-existing-rt-ticket-in-buffer-level-3-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-org-headline-in-buffer "2343") 3)))))

(ert-deftest yogurty/find-already-existing-rt-ticket-in-org-file-level-1-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-in-org-file "2341") 1)))))

(ert-deftest yogurty/find-already-existing-rt-ticket-in-org-file-level-2-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-in-org-file "2342") 2)))))

(ert-deftest yogurty/find-already-existing-rt-ticket-in-org-file-level-3-headline ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
   (lambda () (should (equal (yogurty-find-rt-ticket-in-org-file "2343") 3)))))

;; FIXME: This test is passing, and it shouldn't be!
(ert-deftest yogurty/insert-rt-ticket-in-org-file ()
  "Should find already-existing RT ticket in org buffer."
  (my-org-file-fixture
   (progn
     (yogurty-insert-rt-ticket-into-org-generic "2346" "eBiz it up a notch")
     (lambda () (should (equal (yogurty-find-rt-ticket-in-org-file "2346") "4"))))))
