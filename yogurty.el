;;; yogurty.el ---
;;
;; Filename: yogurty.el
;; Description:
;; Author: Saint Aardvark the Carpeted
;; Maintainer:
;; Created: Sat May 10 13:32:03 2014 (-0700)
;; Version: 0.0.1
;; Package-Requires: ()
;; Last-Updated:
;;           By:
;;     Update #: 0
;; URL:
;; Doc URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;; FIXME: Should be defcustom
(defvar yogurty-rt-server "localhost" "Hostname of the RT server -- where to point rt.")
(defvar yogurty-rt-subjectline "rt.example.com" "The RT subject line -- ie, rt.example.com.")
(defvar yogurty-org-file "all.org" "Filename of the org file.")
(defvar yogurty-rt-notes-dir "/home/hugh/git" "What directory to keep RT notes files in.")

;; FIXME: These two functions should be one that takes an arg.
;; Tested.
(defun yogurty-find-rt-ticket-subject-from-string (string)
  "Find a ticket subject from a string."
  (if (string-match (format "\\[%s #\\([0-9]+\\)\\] \\(.*\\)$" yogurty-rt-subjectline) string)
      (match-string 2 string)))

;; Tested.
(defun yogurty-find-rt-ticket-number-from-string (string)
  "Find a ticket number from a string."
  (if (string-match (format "\\[%s #\\([0-9]+\\)\\] \\(.*\\)$" yogurty-rt-subjectline) string)
      (match-string 1 string)))

;; FIXME: These two functions should be one that takes an arg.
;; Tested.
(defun yogurty-find-rt-ticket-subject-from-rt-email ()
  "Find a ticket subject from rt-email.

Used in a few different places; time to break it out."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (search-forward "Subject: ")
	(yogurty-find-rt-ticket-subject-from-string (thing-at-point 'line))
      (nil))))

;; Tested.
(defun yogurty-find-rt-ticket-number-from-rt-email ()
  "Find a ticket subject from rt-email.

Used in a few different places; time to break it out."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (search-forward "Subject: ")
	(yogurty-find-rt-ticket-number-from-string (thing-at-point 'line))
      (nil))))

;; Tested
(defun yogurty-find-rt-ticket-in-org-file (ticket)
  "Search for Org headline with RT ticket.

Returns position of headline, or nil if not found."
  (interactive "s")
  (save-excursion
   (set-buffer (find-file-noselect yogurty-org-file))
   (yogurty-find-rt-ticket-org-headline-in-buffer ticket)))

;; Tested.
(defun yogurty-find-rt-ticket-org-headline-in-buffer (ticket)
  "Search for Org headline with RT ticket in buffer.

Returns position of headline, or nil if not found."
  (interactive "s")
  (save-excursion
   (goto-char (point-min))
   (if (re-search-forward (format "^\\*\\** .*RT #%s .*$" ticket) (point-max) t)
       (line-number-at-pos)
     nil)))

;; Next test
;; FIXME: We're not testing to see if we should clock in.
(defun yogurty-insert-rt-ticket-into-org-from-rt-email (&optional arg)
  "Insert an RT ticket into Org and clock in while editing a reply to that email.
Faster than waiting for rt-browser to update.

If argument provided, do NOT clock in.
"
  (interactive "P")
  (let ((id (yogurty-find-rt-ticket-number-from-rt-email))
	(subject (yogurty-find-rt-ticket-subject-from-rt-email)))
    (yogurty-insert-rt-ticket-into-org-generic id subject arg)))

;; FIXME: The check for an already-existing ticket is duplicated in a
;; number of places; Should be using
;; yogurty-find-rt-ticket-org-headline-in-buffer.

;; Tested.
(defun yogurty-insert-rt-ticket-into-org-generic (id subject &optional arg)
  "Generic way of inserting an org entry for an RT ticket (if necessary).

If arg provided, do NOT clock in.
"
  (interactive "P")
  (save-excursion
    (set-buffer (find-file-noselect yogurty-org-file))
    ;; FIXME: I'll bet you CASH MONEY there's a much better way to do
    ;; this.
    (let ((pos (yogurty-find-rt-ticket-in-org-file id)))
      (if (not (eq pos nil))
	  (progn
	    (message "Already in org!")
	    (goto-line pos))
	(goto-char (point-max))
	(unless (bolp)
	  (insert "\n"))
	(insert (format "** RT #%s -- %s\n" id subject))))
    (unless arg
      (org-clock-in))))

(defun yogurty-insert-rt-ticket-into-org-from-rt-browser (&optional point arg)
  "Insert an RT ticket into Org from rt-liberation ticket browser.

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
      (set-buffer (find-file-noselect yogurty-org-file))
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

(defun yogurty-clocked-into-rt-ticket ()
  "A Small but Useful(tm) function to see if I'm clocked into an RT ticket.

Depends on regular expressions, which of course puts me in a state of sin."
  (interactive)
  (if (equal nil org-clock-current-task)
      ()
    (when (string-match "\\(RT #[0-9]+\\)" org-clock-current-task)
     (eval (format "%s" (match-string 1 org-clock-current-task))))))

;; Tested.
(defun yogurty-clocked-into-rt-ticket-number-only ()
  "A Small but Useful(tm) function to see if I'm clocked into an RT ticket.

Depends on regular expressions, which of course puts me in a state of sin."
  (interactive)
  (if (equal nil org-clock-current-task)
      ()
    (if (string-match "RT #\\([0-9]+\\)" org-clock-current-task)
	(format "%s" (match-string 1 org-clock-current-task))
      ())))

;; Tested PARTLY.  Need test for dir existence.
(defun yogurty-open-org-file-for-rt-ticket ()
  "A Small but Useful(tm) function to open the notes file for a ticket."
  (interactive)
  (let ((number (yogurty-clocked-into-rt-ticket-number-only)))
    (when (not (equal nil number))
      (find-file (format "%s/rt_%s/notes.org" yogurty-rt-notes-dir number)))))

;; Tested.
(defun yogurty-insert-rt-ticket-commit-comment ()
  "A Small but Useful(tm) function to insert a comment referencing an RT ticket.

Uses the currently-clocked in task as default."
  (interactive)
  (insert-string (format "see %s for details." (yogurty-clocked-into-rt-ticket))))

(defun yogurty-schedule-rt-ticket-for-today-from-rt-email (&optional arg)
  "Schedule an RT ticket for today while editing that email.  Optional arg sets prio to A.

Can be called from Mutt as well."
  (interactive "P")
  (yogurty-insert-rt-ticket-into-org-from-rt-email)
  (let ((id (yogurty-find-rt-ticket-number-from-rt-email))
	(subject (yogurty-find-rt-ticket-subject-from-rt-email)))
	(yogurty-schedule-rt-ticket-for-today-generic id subject arg)))

(defun yogurty-schedule-rt-ticket-for-today-generic (id subject &optional arg)
  "Generic way to schedule an RT ticket for today.  Optional arg sets prio to A."
  (interactive "P")
 (save-excursion
   (set-buffer (find-file-noselect yogurty-org-file))
   (goto-char (point-min))
   (if (search-forward-regexp  (format "^\\*\\* .*RT #%s.*$" id) (point-max) t)
       (progn
	 (org-schedule 1 ".")))
   (if arg
       (org-priority-up))))

(defun yogurty-resolve-rt-ticket-after-org-rt-done ()
  "Resolve an RT ticket after the org entry is marked done.

Meant to be called from org-after-todo-state-change-hook:

    (add-hook 'org-after-todo-state-change-hook 'yogurty-resolve-rt-ticket-after-org-rt-done)

Originally I had used yogurty-clocked-into-rt-ticket-number-only
to try and figure out the ticket number, but I'd forgotten that
a) by the time this hook runs, we're no longer clocked into
anything (if we were before), and b) I might want to run this
while not clocked into anything. So I duplicate the extraction of
ticket number that's in yogurty-clocked, which FIXME."
  (interactive)
  (when (string-equal org-state "DONE")
    ; yogurty-clocked-into-rt-ticket-number-only -- not quite, but close.
    (when (looking-at ".*RT #\\([0-9]+\\)")
      (message "I'm gonna try to close this ticket!")
	(yogurty-rt-resolve-without-mercy-noninteractive (format "%s" (match-string 1 org-clock-current-task))))))

(defun yogurty-email-rt (&optional arg ticket)
  "A Small but Useful(tm) function to email RT about a particular ticket. Universal argument to make it Bcc."
  (interactive "P\nnTicket: ")
  (save-excursion
    (goto-char (point-min))
    (if arg
	(search-forward "Bcc:")
      (search-forward "To:"))
    (insert-string " rtc")
    (search-forward "Subject:")
    (insert-string (format " [rt.chibi.ubc.ca #%d] " ticket))))

(defun yogurty-new-rt-email ()
  "A Small but Useful(tm) function to send an email to RT for a new ticket."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (search-forward "To:")
    (insert-string " help@chibi.ubc.ca")))

(defun yogurty-email-rt-dwim (&optional arg)
  "A Small but Useful(tm) function to email RT about a particular ticket. Universal argument to send to rt instead of rt-comment.

  Will do its best to figure out the ticket number on its own, and prompt if needed; and will send a Bcc: if it looks like there's already a To: address."
  (interactive "P\n")
  (if arg
      (setq sendto "rt")
    (setq sendto "rtc"))
  (save-excursion
    (goto-char (point-min))
    (search-forward "To:")
    (if (search-forward-regexp "\\w" (line-end-position) t)
	(progn
	  (search-forward "Bcc:")
	  (insert-string (format " %s" sendto)))
      (insert-string  (format " %s" sendto)))
    (search-forward "Subject:")
    (if (search-forward "[rt.chibi.ubc.ca #" (line-end-position) t)
	()
      (insert-string
       (format " [rt.chibi.ubc.ca #%s] "
	       (read-string "Ticket: " nil nil (format "%s" (yogurty-clocked-into-rt-ticket-number-only))))))))

;; FIXME: Is this a duplicate of yogurty-insert-rt-ticket-into-org-generic?
(defun yogurty-insert-rt-ticket-into-org (&optional point arg)
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
      (set-buffer yogurty-org-file)
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

(defun yogurty-get-rt-ticket-subject ()
  "Get RT ticket subject."
  (interactive)
  (setq point (point))
  (let ((subject (cdr (assoc "Subject" (get-text-property point 'rt-ticket)))))
    (message "RT #666 -- %s" subject)))

(defun yogurty-rt-resolve-without-mercy-interactive (ticket)
  "Resolve an RT ticket without hesitation.

Do it, monkey boy!"
  (interactive "sTicket: ")
  (start-process "nomercy" "rt-resolve-without-mercy" "/home/hugh/bin/rt-resolve-without-mercy.sh" ticket))

;; FIXME: Too stupid right now to figure out how to do the right
;; thing: only prompting if there's no ticket supplied.
(defun yogurty-rt-resolve-without-mercy-noninteractive (ticket)
  "Resolve an RT ticket without hesitation.

Do it, monkey boy!"
  (start-process "nomercy" "rt-resolve-without-mercy" "/home/hugh/bin/rt-resolve-without-mercy.sh" ticket))

(defun yogurty-rt-get-already-existing-ticket-subject (ticket)
  "Get the subject from an already-existing ticket."
  (interactive "sTicket: ")
  (insert (shell-command-to-string (format "/home/hugh/bin/rt-get-ticket-subjectline.sh %s" ticket))))

;; FIXME: This should be in org.
;; FIXME: This is a duplicate of yogurty-rt-get-already-existing-ticket-subject.
(defun yogurty-org-autofill-rt-entry (ticket)
  "Autofill Org RT entry from an already-existing ticket."
  (interactive "sTicket: ")
  (insert (format "RT #%s -- %s" ticket (shell-command-to-string (format "/home/hugh/bin/rt-get-ticket-subjectline.sh %s" ticket)))))

(provide 'yogurty)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; yogurty.el ends here
