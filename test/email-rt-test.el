(ert-deftest yogurty-test/email-rt-verify-to ()
  "Test email formatting, To: header."
  (my-blank-email-fixture
   (lambda ()
    (yogurty-email-rt nil 1234)
    (beginning-of-buffer)
    ;; (message (buffer-string))
    (search-forward "To:")
    (beginning-of-line)
    (should (looking-at "To: rtc")))))

(ert-deftest yogurty-test/email-rt-verify-subject ()
  "Test email formatting, Subject: header"
  (my-blank-email-fixture
   (lambda ()
    (yogurty-email-rt nil 1234)
    (beginning-of-buffer)
    ;; (message (buffer-string))
    (search-forward "Subject:")
    (beginning-of-line)
    (should (looking-at "Subject: \\[rt.chibi.ubc.ca #1234\\]")))))

(ert-deftest yogurty-test/email-rt-verify-bcc ()
  "Test email formatting, Bcc: header"
  (my-blank-email-fixture
   (lambda ()
    (yogurty-email-rt 1 1234)
    (beginning-of-buffer)
    ;; (message (buffer-string))
    (search-forward "Bcc:")
    (beginning-of-line)
    (should (looking-at "Bcc: rtc")))))

(ert-deftest yogurty-test/email-rt-verify-bcc-no-to ()
  "Test email formatting, Bcc: header"
  (my-blank-email-fixture
   (lambda ()
    (yogurty-email-rt 1 1234)
    (beginning-of-buffer)
    (message (buffer-string))
    (search-forward "To:")
    (beginning-of-line)
    (should (looking-at "To:\n")))))
