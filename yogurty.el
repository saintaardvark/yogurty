;; FIXME: Should be defcustom
(defvar yogurty-rt-server "localhost" "Hostname of the RT server -- where to point rt.")
(defvar yogurty-rt-subjectline "rt.example.com" "The RT subject line -- ie, rt.example.com.")

(defun x-hugh-find-rt-ticket-number-from-rt-email ()
  "Find a ticket number from rt-email.

Used in a few different places; time to break it out."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (search-forward "Subject: ")
    (if (search-forward-regexp (format "\\[%s #\\([0-9]+\\)\\]\\(.*\\)$" yogurty-rt-subjectline) (line-end-position) t)
	(match-string 1))))

(defun x-hugh-find-rt-ticket-subject-from-rt-email ()
  "Find a ticket subject from rt-email.

Used in a few different places; time to break it out."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (search-forward "Subject: ")
    (if (search-forward-regexp (format "\\[%s #\\([0-9]+\\)\\]\\(.*\\)$" yogurty-rt-subjectlin) (line-end-position) t)
	(match-string 2))))

(defun x-hugh-insert-rt-ticket-into-org-from-rt-email (&optional arg)
  "Insert an RT ticket into Org and clock in while editing a reply to that email.
Faster than waiting for rt-browser to update.

If argument provided, do NOT clock in.
"
  (interactive "P")
  (let ((id (x-hugh-find-rt-ticket-number-from-rt-email))
	(subject (x-hugh-find-rt-ticket-subject-from-rt-email)))
	(x-hugh-insert-rt-ticket-into-org-generic id subject arg)
	    (org-clock-in)))

(defun x-hugh-insert-rt-ticket-into-org-generic (id subject &optional arg)
  "Generic way of inserting an org entry for an RT ticket (if necessary).

If arg provided, do NOT clock in.
"
 (interactive "P")
 (save-excursion
   (set-buffer (find-file-noselect "/home/hugh/chibi/all.org"))
   (goto-char (point-min))
   (if (search-forward-regexp  (format "^\\*\\* .*RT #%s.*$" id) (point-max) t)
       (message "Already in org!")
     (progn
       (goto-char (point-max))
       (if (bolp)
	   ()
	 (insert "\n"))
       (insert (format "** RT #%s --%s\n" id subject))))
   (unless arg
     (org-clock-in))))

(defun x-hugh-insert-rt-ticket-into-org (&optional point arg)
  "A Small but Useful(tm) function to insert an RT ticket into Org.

If POINT is nil then called on (point).  If called with arg, check in as well."
  (interactive "P")
  (when (not point)
    (setq point (point)))
  ;; (let ((id (rt-liber-browser-ticket-id-at-point)))
  (setq point (point))
  (let ((ticket (get-text-property point 'rt-ticket)))
    (setq subject (cdr (assoc "Subject" ticket)))
    (setq id (rt-liber-browser-ticket-id-at-point))
    (save-excursion
      (set-buffer (find-file-noselect "/home/hugh/chibi/all.org"))
      (goto-char (point-min))
      (if (search-forward-regexp  (format "^\\*\\* .*RT #%s.*$" id) (point-max) t)
	  (message "Already in org!")
	(progn
	  (goto-char (point-max))
	  (if (bolp)
	      ()
	    (insert "\n"))
	  (insert (format "** RT #%s -- %s\n" id subject))))
      (if arg
	  (org-clock-in)))))

(defun x-hugh-clocked-into-rt-ticket ()
  "A Small but Useful(tm) function to see if I'm clocked into an RT ticket.

Depends on regular expressions, which of course puts me in a state of sin."
  (interactive)
  (if (equal nil org-clock-current-task)
      ()
    (when (string-match "\\(RT #[0-9]+\\)" org-clock-current-task)
     (eval (format "%s" (match-string 1 org-clock-current-task))))))

(defun x-hugh-clocked-into-rt-ticket-number-only ()
  "A Small but Useful(tm) function to see if I'm clocked into an RT ticket.

Depends on regular expressions, which of course puts me in a state of sin."
  (interactive)
  (if (equal nil org-clock-current-task)
      ()
    (if (string-match "RT #\\([0-9]+\\)" org-clock-current-task)
	(format "%s" (match-string 1 org-clock-current-task))
      ())))

(defun x-hugh-open-org-file-for-rt-ticket ()
  "A Small but Useful(tm) function to open the notes file for a ticket."
  (interactive)
  (find-file (format "/home/hugh/git/rt_%s/notes.org" (x-hugh-clocked-into-rt-ticket-number-only))))

(defun x-hugh-insert-rt-ticket-commit-comment ()
  "A Small but Useful(tm) function to insert a comment referencing an RT ticket.

Uses the currently-clocked in task as default."
  (interactive)
  (insert-string (format "see %s for details." (x-hugh-clocked-into-rt-ticket))))

(defun x-hugh-schedule-rt-ticket-for-today-from-rt-email (&optional arg)
  "Schedule an RT ticket for today while editing that email.  Optional arg sets prio to A.

Can be called from Mutt as well."
  (interactive "P")
  (x-hugh-insert-rt-ticket-into-org-from-rt-email)
  (let ((id (x-hugh-find-rt-ticket-number-from-rt-email))
	(subject (x-hugh-find-rt-ticket-subject-from-rt-email)))
	(x-hugh-schedule-rt-ticket-for-today-generic id subject arg)))

(defun x-hugh-schedule-rt-ticket-for-today-generic (id subject &optional arg)
  "Generic way to schedule an RT ticket for today.  Optional arg sets prio to A."
  (interactive "P")
 (save-excursion
   (set-buffer (find-file-noselect "/home/hugh/chibi/all.org"))
   (goto-char (point-min))
   (if (search-forward-regexp  (format "^\\*\\* .*RT #%s.*$" id) (point-max) t)
       (progn
	 (org-schedule 1 ".")))
   (if arg
       (org-priority-up))))

(defun x-hugh-resolve-rt-ticket-after-org-rt-done ()
  "Resolve an RT ticket after the org entry is marked done.

Meant to be called from org-after-todo-state-change-hook:

    (add-hook 'org-after-todo-state-change-hook 'x-hugh-resolve-rt-ticket-after-org-rt-done)

Originally I had used x-hugh-clocked-into-rt-ticket-number-only
to try and figure out the ticket number, but I'd forgotten that
a) by the time this hook runs, we're no longer clocked into
anything (if we were before), and b) I might want to run this
while not clocked into anything. So I duplicate the extraction of
ticket number that's in x-hugh-clocked, which FIXME."
  (interactive)
  (when (string-equal org-state "DONE")
    ; x-hugh-clocked-into-rt-ticket-number-only -- not quite, but close.
    (when (looking-at ".*RT #\\([0-9]+\\)")
      (message "I'm gonna try to close this ticket!")
	(x-hugh-rt-resolve-without-mercy-noninteractive (format "%s" (match-string 1 org-clock-current-task))))))


(provide 'yogurty)
