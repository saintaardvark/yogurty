;; Stolen from http://tuxicity.se/emacs/testing/cask/ert-runner/2013/09/26/unit-testing-in-emacs.html
(require 'f)

(defvar root-test-path
  (f-dirname (f-this-file)))

(defvar root-code-path
  (f-parent root-test-path))

(defvar root-sandbox-path
  (f-expand "sandbox" root-test-path))

(require 'yogurty (f-expand "yogurty.el" root-code-path))

(defmacro with-sandbox (&rest body)
  "Evaluate BODY in an empty temporary directory."
  `(let ((default-directory root-sandbox-path))
     (when (f-dir? root-sandbox-path)
       (f-delete root-sandbox-path :force))
     (f-mkdir root-sandbox-path)
     ,@body))

(defmacro with-sandbox-org-file (&rest body)
  "Evaluate BODY using sandbox org file."
  `(let ((default-directory root-sandbox-path)
	 (yogurty-org-file (f-join root-sandbox-path "test.org")))
     (when (f-dir? root-sandbox-path)
       (f-delete root-sandbox-path :force))
     (f-mkdir root-sandbox-path)
     (when (f-file? yogurty-org-file)
       (f-delete yogurty-org-file :force))
     ,@body))

(defmacro with-sandbox-rt-notes (&rest body)
  "Evaluate BODY using sandbox directory for RT notes."
  `(let ((default-directory root-sandbox-path)
	 (yogurty-rt-directory root-sandbox-path))
     (when (f-dir? root-sandbox-path)
       (f-delete root-sandbox-path :force))
     (f-mkdir root-sandbox-path)
     ,@body))
