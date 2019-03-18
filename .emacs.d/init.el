(package-initialize)

(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; clojure settings
(add-hook 'clojure-mode-hook #'paredit-mode)
(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)

;; ui customizations
(menu-bar-mode -1)  ;; hide menu bar
(global-linum-mode) ;; show line numbers

;; themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/themes")
(load-theme 'tomorrow-night-bright t)
