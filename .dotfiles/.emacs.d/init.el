(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(recentf-mode 1)
(global-set key "\C-xf" 'recentf-open-files)

(electric-pair-mode)

(setq-default global-display-line-numbers-mode t)
(setq-default display-line-numbers 'relative)

(auto-revert-mode 1)
