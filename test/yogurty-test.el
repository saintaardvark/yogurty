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

; (my-fixture (lambda () (message (yogurty-find-rt-ticket-subject-from-rt-email))))

(ert-deftest yogurty/find-ticket-number-from-string ()
  "Should find ticket subject from string."
  (should (equal (yogurty-find-rt-ticket-number-from-string rt-test-string) "2341")))

(ert-deftest yogurty/find-ticket-subject-from-string ()
  "Should find ticket subject from string."
  (should (equal (yogurty-find-rt-ticket-subject-from-string rt-test-string) "opt-out for google analytics on website")))
