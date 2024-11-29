(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(recentf-mode 1)
(global-set key "\C-xf" 'recentf-open-files)

(electric-pair-mode)
(setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)

(setq-default global-display-line-numbers-mode t)
(setq-default display-line-numbers 'relative)

(auto-revert-mode 1)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))
(add-hook 'org-mode-hook
          (lambda() (setq jit-lock-defer-time 0.15)))

(add-hook 'org-mode-hook
          (lambda()
            (setq org-latex-src-block-backend 'listing
                  org-lagex-listings-options  '(("numbers" "left")
                                                ("breaklines" "true")
                                                ("upquote" "true")
                                                ("autogobble" "true")
                                                ("showstringspaces" "false")
                                                ("basicstyle" "\\ttfamily")))))

(add-hook 'org-mode-hook
          (lambda()
            (setq org-preview-latex-default-process 'dvipng
                  org-startup-with-latex-preview     t)))

(add-hook 'org-mode-hook
          (lambda()
            (org-babel-do-load-languages
             'org-babel-load-languages '((emacs-lisp . t)
                                         (C . t)
                                         (shell . t)
                                         (lua . t))))

(add-hook 'org-mode-hook
          (lambda()
            (display-line-numbers-mode -1)
            (setq org-startup-indented t)))

(add-hook 'org-mode-hook
          (lambda()
            (setq-local electric-pair-inhibit-predicate
                        `(lambda(c)
                           (if (char-equal c ?<) t
                             (,electric-pair-inhibit-predicate c))))))

(add-hook 'prog-mode-hook
          (lambda()
            (setq c-indentation-style 'k&r
                  c-basic-offset       4)))

(add-hook 'prog-mode-hook
          (lambda()
            (setq treesit-font-lock-level 4
                  c-ts-mode-indent-style 'k&r
                  c-ts-mode-indent-offset 4)))

(setq treesit-language-source-alist
      '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (bash "https://github.com/tree-sitter/tree-sitter-bash")))
