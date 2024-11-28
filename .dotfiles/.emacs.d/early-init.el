(visual-line-mode nil)
(setq-default truncate-lines t)
(setq-default blink-cursor-mode nil)
(setq-default inhibit-startup-screen t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq package-quickstart t)

(setq gc-cons-threshold (* 64 1000 1000))
(setq read-process-output-max (* 1024 1024))

(setq scroll-conservatively 101)
(setq echo-keystrokes .1)

(setq make-backup-files nil)
