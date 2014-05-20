(require 'f)

(defvar yogurty-support-path
  (f-dirname load-file-name))

(defvar yogurty-features-path
  (f-parent yogurty-support-path))

(defvar yogurty-root-path
  (f-parent yogurty-features-path))

(add-to-list 'load-path yogurty-root-path)

(require 'yogurty)
(require 'espuds)
(require 'ert)

(Setup
 ;; Before anything has run
 )

(Before
 ;; Before each scenario is run
 )

(After
 ;; After each scenario is run
 )

(Teardown
 ;; After when everything has been run
 )
