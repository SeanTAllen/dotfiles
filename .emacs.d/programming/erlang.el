(setq load-path (cons  "/opt/local/lib/erlang/lib/tools-2.6.6.4/emacs" load-path))
(setq erlang-root-dir "/opt/local/lib/erlang/lib/")
(setq exec-path (cons "/opt/local/lib/erlang/lib/bin" exec-path))
(require 'erlang-start)

;; wrangler code refactoring tool
(setq load-path (cons "/opt/share/wrangler/elisp" load-path))
(require 'wrangler)
(load-file "/opt/share/wrangler/elisp/graphviz-dot-mode.el")
