(defun fwoar/clojure-hook ()
  (message "clojure-hook")
  (flycheck-mode 1)
  (rainbow-delimiters-mode 1)
  (evil-smartparens-mode 1)
  (smartparens-strict-mode 1))

(defun fwoar/cider-hook-base ()
  (helm-cider-mode 1)
  (cider-company-enable-fuzzy-completion))
(defun fwoar/cider-hook ()
  (fwoar/cider-hook-base)
  (aggressive-indent-mode 1))
(defun fwoar/cider-repl-hook ()
  (fwoar/cider-hook-base)
  (aggressive-indent-mode 0))

(defun fwoar/cider-eval-expression-at-point-in-repl ()
  (interactive)
  (let ((form (cider-defun-at-point)))
    ;; Strip excess whitespace
    (while (string-match "\\`\s+\\|\n+\\'" form)
      (setq form (replace-match "" t t form)))
    (with-current-buffer (cider-current-repl nil t)
      (let ((fw/window (get-buffer-window)))
        (with-selected-window fw/window
          (goto-char (point-max))
          (insert form)
          (cider-repl-return)
          (goto-char (point-max)))))))

(use-package cider
  :ensure t
  :config
  (require 'cider-selector)
  (evil-define-key 'normal clojure-mode-map " t" 'cider-test-run-ns-tests)
  (evil-define-key 'normal clojure-mode-map " '" 'helm-cider-apropos)
  (evil-define-key 'normal clojure-mode-map (kbd "SPC") 'evil-send-leader)

  (def-cider-selector-method ?S "find clojure project file"
    (fwoar--find-system))

  (add-hook 'clojure-mode-hook 'fwoar/clojure-hook)
  (add-hook 'cider-mode-hook 'fwoar/cider-hook)
  (add-hook 'cider-repl-mode-hook 'fwoar/cider-repl-hook)

  (modify-syntax-entry ?: "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?_ "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?- "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?~ "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?. "w" clojure-mode-syntax-table)

  (define-key cider-repl-mode-map (kbd "C-c M-o") 'cider-repl-clear-buffer)
  (define-key cider-repl-mode-map (kbd "C-c C-o") 'cider-repl-clear-output)
  (define-key cider-mode-map (kbd "C-c ~") 'cider-repl-set-ns)
  (setq cider-save-file-on-load t
        cider-repl-history-file "~/.emacs.d/cider-history.clj")

  (define-key cider-mode-map
    (kbd "C-c C-j") 'fwoar/cider-eval-expression-at-point-in-repl))

(use-package clj-refactor
  :after cider
  :ensure t
  :config
  (evil-define-key 'normal clojure-mode-map (kbd "<leader> r") 'hydra-cljr-help-menu/body))


(use-package helm-cider
  :after cider helm
  :ensure t)

(use-package flycheck-clj-kondo
  :after flycheck
  :ensure t)


(defun find-clojure-project-file ()
  (let ((systems (directory-files
                  (locate-dominating-file default-directory
                                          (lambda (n)
                                            (or (directory-files n nil "project.clj")
                                                (directory-files n nil "build.boot")
                                                (directory-files n nil "deps.edn")
                                                (directory-files n nil "shadow-cljs.edn"))))
                  t "^\\(project.clj\\|build.boot\\|deps.edn\\|shadow-cljs.edn\\)$")))
    (find-file (if (not (null (cdr systems)))
                   (helm-comp-read "system:" systems)
                 (car systems)))))

(cl-defmethod fwoar/find-system (&context (major-mode (derived-mode clojure-mode)))
  (find-clojure-project-file))
(cl-defmethod fwoar/find-system (&context (projectile-project-type (eql clojure-mode)))
  (find-clojure-project-file))
(cl-defmethod fwoar/find-system (&context (major-mode (derived-mode cider-repl-mode)))
  (find-clojure-project-file))

(cl-defmethod fwoar--pl-selector (&context (major-mode clojure-mode))
  (cider-selector))
(cl-defmethod fwoar--pl-selector (&context (projectile-project-type (eql :clojure)))
  (cider-selector))
(cl-defmethod fwoar--pl-selector (&context (major-mode cider-repl-mode))
  (cider-selector))
