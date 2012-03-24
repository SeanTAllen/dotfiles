;; non-crap window sizing on the macbook.
;; modify to something less specific later
(setq default-frame-alist
      '((width . 245) (height . 72)))

;; fix borked mac paths when not launching from a terminal
;; can't find macports etc installs w/o
(setenv "PATH" (concat "~/bin" ":" 
                       "~/.lein/bin" ":"
                       "~/.gem/ruby/1.8/bin" ":"
                       "/opt/local/bin" ":"
                       "/opt/local/sbin" ":"
                       (getenv "PATH")))
  (push "/opt/local/bin" exec-path)

;; peepopen setup
(require 'textmate)
(require 'peepopen)
(setq ns-pop-up-frames nil)

;; change font to inconsolata
(set-default-font "-apple-Inconsolata-medium-normal-normal-*-14-*-*-*-m-0-iso10646-1")

