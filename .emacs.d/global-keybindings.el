;; Completion that uses many different methods to find options.
(global-set-key (kbd "M-/") 'hippie-expand)
                
;; quick hop to commonly used magit status
(global-set-key (kbd "C-x m") 'magit-status)

(global-set-key (kbd "C-x g") 'goto-line)

;; Previous window
(global-set-key (kbd "C-x p")
                (lambda ()
                  (interactive)
                  (other-window -1)))

;; use meta and arrow keys to move amongst windows
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)
