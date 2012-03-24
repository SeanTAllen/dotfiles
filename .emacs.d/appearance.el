;; color themeing
(add-to-list 'load-path (concat dotfiles-dir "lib/color-theme-6.6.0"))
(require 'color-theme)
(load (concat dotfiles-dir "lib/color-theme-sanityinc-solarized.el"))
(load (concat dotfiles-dir "lib/color-theme-solarized.el"))
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-sanityinc-solarized-dark)))

;; turn off toolbar
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

;; turn off annoying startup screen
(setq inhibit-startup-message t)
