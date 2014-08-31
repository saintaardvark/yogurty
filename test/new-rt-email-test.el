(ert-deftest yogurty-test/new-rt-email ()
  "Test email formatting, To: header."
  (with-temp-buffer
    (insert "From:\n")
    (insert "Bcc:\n")
    (insert "To:\n")
    (insert "Subject:\n")
    (yogurty-new-rt-email)
    (beginning-of-buffer)
    ;; (message (buffer-string))
    (search-forward "To:")
    (beginning-of-line)
    (should (looking-at "To: help@chibi.ubc.ca"))))
