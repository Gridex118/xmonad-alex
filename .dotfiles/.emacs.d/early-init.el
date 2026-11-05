;; -*- lexical-binding: t; -*-

(setq-default fill-column 110)
(setq-default truncate-lines t)
(setq-default blink-cursor-mode nil)
(setq-default inhibit-startup-screen t)
(visual-line-mode -1)
(tool-bar-mode    -1)
(menu-bar-mode    -1)
(scroll-bar-mode  -1)

(setq package-quickstart t)

(setq gc-cons-threshold (* 256 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 32 1024 1024))))
(setq read-process-output-max (* 1024 1024))

(setq scroll-conservatively 101)
(setq echo-keystrokes .1)

(setq make-backup-files nil
      native-comp-async-report-warnings-errors 'silent
      byte-compile-warnings '(not docstrings))

(setq text-mode-ispell-word-completion nil)

(use-package warnings
  :config
  (add-to-list 'warning-suppress-log-types
               '(org-element org-element-parser)))

(setenv "LSP_USE_PLISTS" "true")

(setq-default tab-width 4)
