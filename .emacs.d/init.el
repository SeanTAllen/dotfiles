;; Load path etc.
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))

;; load elpa packages
(when
    (load
     (expand-file-name (concat dotfiles-dir "elpa/package.el")))
  (package-initialize))

;; add lib directory and some subdirectories to load path
(let ((default-directory (concat dotfiles-dir "lib/")))
  (normal-top-level-add-to-load-path '("." "haskell-mode"))
  (normal-top-level-add-to-load-path '("." "magit-1.0.0")))

;; load global keybindings
(load (concat dotfiles-dir "global-keybindings.el"))

;; appearance altering configuration settings
(load (concat dotfiles-dir "appearance.el"))

;; 'global' coding mode settings
(load (concat dotfiles-dir "programming/hook.el"))

;; shell should deal with ansi colors
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; character encoding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; do something reasonable with backup files
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat dotfiles-dir ".magic/saves")))))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; save last visited location in files
(setq save-place-file (concat dotfiles-dir ".magic/saveplace"))
(setq-default save-place t)
(require 'saveplace)

;; prevent long areas of spaces from being turned into tabs
;; if indent-tabs-mode is off, untabify before saving
(setq-default indent-tabs-mode nil)
(add-hook 'write-file-hooks 
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))))

;; bring in smarttabs to use tabs for indentation and 
;; spaces for alignment. needs to be configured per mode.
;; indent-tabs-mode must be on.
;; see: http://www.emacswiki.org/emacs/SmartTabs
(require 'smarttabs)

;; make sure files always end with a newline
(setq require-final-newline t)

;; transparently open compressed files
(auto-compression-mode t)

;; emacs and my opinions of what is important differ
(defalias 'yes-or-no-p 'y-or-n-p)

;; smart tab setup
;; has tab do an indent-according-to-mode
;(require 'smart-tab)
;(global-smart-tab-mode 1)

;; audible and visible bells are annoying. kill them both.
(setq ring-bell-function (lambda ()))

;; turn on kill ring browsing && searching
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)
(global-set-key "\M-\C-y" 'kill-ring-search)

;; smex
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; Original M-x binding before Smex.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq confirm-nonexistent-file-or-buffer nil)
(setq ido-create-new-buffer 'always)

;; recent files mode
(require 'recentf)
;; get rid of `find-file-read-only' and replace it with something more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(recentf-mode t)
(setq recentf-max-saved-items 50)
 
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

;; load cheat sheets
(load (concat dotfiles-dir "lib/cheat.el"))

;; default to unified diffs
(setq diff-switches "-u -w"
      magit-diff-options "-w")

;; multiple line editing
(require 'multiple-line-edit)

(load (concat dotfiles-dir "programming/lisp.el"))
(load (concat dotfiles-dir "programming/haskell.el"))
(load (concat dotfiles-dir "programming/java.el"))

;; git-blame mode
(autoload 'git-blame-mode "git-blame" "Minor mode for incremental blame for Git." t)

;; markdown mode setup
(autoload 'markdown-mode "markdown-mode" "Autoload markdown-mode" t)
(add-hook 'markdown-mode-hook 'run-programming-hook)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))

;; sass mode setup
(require 'sass-mode)
(add-hook 'sass-mode-hook 'run-programming-hook)
(add-to-list 'auto-mode-alist '("\\.scss$" . sass-mode))

;; smalltalk mode setup
;;(require 'smalltalk-mode)
(autoload 'smalltalk-mode "smalltalk-mode" "Autoload smalltalk-mode" t)
;;(add-hook 'smalltalk-mode-hook 'run-programming-hook)
(add-hook 'smalltalk-mode-hook (setq-default indent-tabs-mode t))
(add-to-list 'auto-mode-alist '("\\.st$" . smalltalk-mode))

;; template toolkit mode setup
;; doesn't have a hook cose it sort of blows.
(autoload 'tt-mode "tt-mode" "Autoload tt-mode" t)
(add-to-list 'auto-mode-alist '("\\.tt2$" . tt-mode))

;; textile mode setup
(autoload 'textile-mode "textile-mode" "Autoload textile-mode" t)
(add-hook 'textile-mode-hook 'run-programming-hook)
(add-to-list 'auto-mode-alist '("\\.textile$" . textile-mode))

;; yaml mode setup
(autoload 'yaml-mode "yaml-mode" "Autoload yaml-mode" t)
(add-hook 'yaml-mode 'run-programming-hook)
(add-to-list 'auto-mode-alist '("\\.yml$" .  yaml-mode))

;; deft
(require 'deft)
(setq deft-directory "~/Dropbox/Notes/")
(setq deft-text-mode 'org-mode)

;; magit
(require 'magit)

;; css mode setup
(require 'css-mode)
(add-hook 'css-mode-hook 'run-programming-hook)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(setq css-indent-offset 2)

;; System specific customizations
(setq system-specific-config (concat dotfiles-dir system-name ".el"))
(if (file-exists-p system-specific-config)
    (load system-specific-config))
