(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(recentf-mode 1)
(global-set-key "\C-xf" 'recentf-open-files)

(global-set-key "\C-xwb" 'switch-to-buffer-other-window)

(electric-pair-mode)
(setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)

(add-hook 'prog-mode-hook
          (lambda()
            (setq display-line-numbers-type 'relative)
            (display-line-numbers-mode)))
(setq column-number-mode t)

(auto-revert-mode 1)

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case    t)

(use-package vterm
  :ensure t
  :defer  t)

(use-package pdf-tools
  :ensure t
  :hook   (doc-view-mode . pdf-tools-install))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t
        evil-want-keybinding  nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(dolist (p '((prog-mode                . normal)
             (minibuffer-mode          . emacs)
             (minibuffer-inactive-mode . emacs)
             (haskell-mode             . emacs)
             (help-mode                . emacs)
             (emacs-lisp-mode          . emacs)
             (dired-mode               . emacs)
             (vterm-mode               . emacs)
             (fundamental-mode         . emacs)))
  (evil-set-initial-state (car p) (cdr p)))

(use-package vertico
  :ensure t
  :defer  t
  :init
  (vertico-mode))

(use-package marginalia
  :ensure t
  :bind
  (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package corfu
  :ensure t
  :defer  t
  :custom
  (corfu-cycle t)
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t))

(use-package yasnippet
  :ensure t
  :hook ((prog-mode . yas-minor-mode)
         (org-mode  . yas-minor-mode))
  :config
  (yas-reload-all))

(use-package lsp-mode
  :ensure t
  :hook
  (c-mode       . lsp-deferred)
  (c-ts-mode    . lsp-deferred)
  (haskell-mode . lsp-deferred)
  (c++-mode     . lsp-deferred)
  (c++-ts-mode  . lsp-deferred)
  (lua-mode     . lsp-deferred)
  (python-mode  . lsp-deferred))

(use-package lsp-ui
  :ensure t
  :after  lsp-mode)

(use-package lsp-pyright
  :ensure t
  :defer  t)

(use-package magit
  :ensure t
  :defer  t)

(use-package rainbow-delimiters
  :ensure t
  :hook prog-mode)
(use-package rainbow-identifiers
  :ensure t
  :hook emacs-lisp-mode)

(add-to-list 'auto-mode-alist '("\\.latex\\'" . latex-mode))

(setq auth-source-save-behavior nil)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold   t
        doom-themes-enable-italic t)
  (set-face-italic 'font-lock-comment-face t)
  (load-theme 'doom-city-lights t)
  (doom-themes-org-config))

(custom-set-faces
 '(default ((t (:family "JetBrains Mono" :foundry "JB" :slant normal :weight regular :height 143 :width normal)))))

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1))
(use-package all-the-icons
  :ensure t
  :after  doom-modeline)

(add-hook 'org-mode-hook
          (lambda() (setq jit-lock-defer-time 0.15)))

(add-hook 'org-mode-hook
          (lambda()
            (setq org-latex-src-block-backend 'listings
                  org-latex-listings-options  '(("numbers" "left")
                                                ("breaklines" "true")
                                                ("upquote" "true")
                                                ("autogobble" "true")
                                                ("showstringspaces" "false")
                                                ("basicstyle" "\\ttfamily")))))

(add-hook 'org-mode-hook
          (lambda()
            (setq org-preview-latex-default-process 'dvipng
                  org-startup-with-latex-preview     t
                  org-format-latex-options           (plist-put org-format-latex-options :scale 2.0))))

(add-hook 'org-mode-hook
          (lambda()
            (org-babel-do-load-languages
             'org-babel-load-languages '((emacs-lisp . t)
                                         (C . t)
                                         (shell . t)
                                         (lua . t)))))

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

(add-hook 'org-mode-hook
          (lambda()
            (setq org-startup-indented  t)))

(use-package olivetti
  :config
  (setq-default olivetti-body-width 120)
  :hook org-mode)

(add-hook 'org-mode-hook
          (lambda()
            (setq-local electric-pair-inhibit-predicate
                        `(lambda(c)
                           (if (char-equal c ?<) t
                             (,electric-pair-inhibit-predicate c))))))

(use-package lua-mode
  :ensure t
  :defer  t)

(use-package haskell-mode
  :ensure t
  :defer  t)

(use-package portage-modes
  :ensure t
  :defer  t)

(add-hook 'prog-mode-hook
          (lambda()
            (setq c-indentation-style 'k&r
                  c-basic-offset       4)))

(use-package elpy
  :ensure t
  :hook (python-mode . elpy-enable)
  :config
  (setenv "WORKON_HOME" "~/.venvs"))

(add-hook 'prog-mode-hook
          (lambda()
            (setq treesit-font-lock-level 4
                  c-ts-mode-indent-style 'k&r
                  c-ts-mode-indent-offset 4)))

(setq treesit-language-source-alist
      '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (bash "https://github.com/tree-sitter/tree-sitter-bash")
        (java "https://github.com/tree-sitter/tree-sitter-java")))

(setq major-mode-remap-alist
      '((c-mode    . c-ts-mode)
        (c++-mode  . c++-ts-mode)
        (bash-mode . bash-ts-mode)
        (java-mode . java-ts-mode)))
