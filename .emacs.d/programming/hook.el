;;; Setup a hook that we can use to add funtionality that
;;; we want to load into any programming mode

(defvar programming-hook nil
  "Hook that gets run on activation of any programming mode.")

;; highlight matching parentheses when the point is on them.
(defun turn-on-show-paren ()
  (show-paren-mode 1))

(add-hook 'programming-hook 'turn-on-show-paren)

;; the dirty details
(defun run-programming-hook ()
  "Enable things that are convenient across all programming buffers."
  (run-hooks 'programming-hook))

