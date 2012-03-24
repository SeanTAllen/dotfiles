;; java mode
(add-hook 'java-mode-hook 'run-programming-hook)
(defun java-mode-setup ()
  "Hook for running java file..."
  (message " Loading java-mode-setup...")
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'statement-case-open 0)
  (c-set-offset 'case-label '+)
  (setq 
   indent-tabs-mode nil
   tab-width 2
   c-basic-offset 2
   tempo-interactive t
   ))
(add-hook 'java-mode-hook 'java-mode-setup)
