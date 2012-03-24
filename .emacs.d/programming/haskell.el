;; haskell-mode. right now, just for xmonad config editing
;; someday, someday perhaps something more...
(autoload 'haskell-mode "haskell-mode" "Autoload haskell-mode" t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'run-programming-hook)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
