;; clojure mode setup
(require 'clojure-mode)
(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))

;; emacs lisp mode setup
(defun my-emacs-lisp-mode-hook ()
  (setq emacs-lisp-indent-level 2))
(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'run-programming-hook)

;; paredit mode setup
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)

(defvar electrify-return-match
  "[\]}\)\"]"
  "If this regexp matches the text after the cursor, do an \"electric\"
  return.")

(defun electrify-return-if-match (arg)
  "If the text after the cursor matches `electrify-return-match' then
  open and indent an empty line between the cursor and the text.  Move the
  cursor to the new line."
  (interactive "P")
  (let ((case-fold-search nil))
    (if (looking-at electrify-return-match)
        (save-excursion (newline-and-indent)))
    (newline arg)
    (indent-according-to-mode)))
  
(defun standard-paredit-setup ()
  (paredit-mode t)
  (turn-on-eldoc-mode)
  (eldoc-add-command
   'paredit-backward-delete
   'paredit-close-round)
  (local-set-key (kbd "RET") 'electrify-return-if-match)
  (eldoc-add-command 'electrify-return-if-match)
  (show-paren-mode t))

(dolist (x '(clojure emacs-lisp lisp lisp-interactive scheme))
  (add-hook
   (intern (concat (symbol-name x) "-mode-hook")) 'standard-paredit-setup)
  (add-hook
   (intern (concat (symbol-name x) "-mode-hook")) 'run-programming-hook))

(add-hook 'emacs-lisp-mode-hook       'standard-paredit-setup)
(add-hook 'lisp-mode-hook             'standard-paredit-setup)
(add-hook 'lisp-interaction-mode-hook 'standard-paredit-setup)
(add-hook 'clojure-mode-hook          'standard-paredit-setup)
;; prevent SLIME reply from grabbing DEL
(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))
(add-hook 'slime-reply-mode-hook 'override-slime-repl-bindings-with-paredit)

;; lein swank runner
(setq slime-port 4005)
(defun lein-swank ()
  (interactive)
  (let ((root (locate-dominating-file default-directory "project.clj")))
    (when (not root)
      (error "Not in a Leiningen project."))
    ;; you can customize slime-port using .dir-locals.el
    (shell-command (format "cd %s && lein swank %s &" root slime-port)
                   "*lein-swank*")
    (set-process-filter (get-buffer-process "*lein-swank*")
                        (lambda (process output)
                          (when (string-match "Connection opened on" output)
                            (slime-connect "localhost" slime-port)
                            (set-process-filter process nil))))
    (message "Starting swank  server...")))
