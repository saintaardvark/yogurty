;; This file contains your project specific step definitions. All
;; files in this directory whose names end with "-steps.el" will be
;; loaded automatically by Ecukes.

;; Stolen from http://tuxicity.se/emacs/testing/cask/ecukes/2013/10/20/integration-testing-in-emacs.html
(Given "^I bind key \"\\([^\"]+\\)\" to \"\\([^\"]+\\)\"$"
  (lambda (key fn-name)
    (global-set-key (kbd key) (intern fn-name))))

(When "^I go to the beginning of the buffer$"
  (lambda ()
    (call-interactively 'beginning-of-buffer)))

(Given "^I have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))

(When "^I have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))

(Then "^I should have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))

(And "^I have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))

(But "^I should not have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))
