(defvar tide-packages
  '(company
    tide
    typescript-mode
    tss)
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar tide-excluded-packages '()
  "List of packages to exclude.")

(defun tide/init-typescript-mode ()
  (interactive)
  (setq compilation-read-command nil)
  ;; Create make command for single file.
  (let ((tsc "tsc"))
    (set (make-local-variable 'compile-command)
         (progn
           (format "%s --target es5 %s"
                   tsc
                   (buffer-file-name))))
    (message compile-command)))

(defun tide/init-tide-mode ()
  (tide-setup)
  (flycheck-mode 1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode 1)
  (setq company-tooltip-align-annotations t)
  (company-mode-on))

;; Don't think that this is still needed here, but not sure.
(defun tide/init-tss ()
  (use-package tss
    :defer t
    :mode ("\\.ts\\'" . typescript-mode)
    :bind ("C-c C-c" . compile)
    :init (progn
            (add-hook 'typescript-mode-hook 'tide/init-typescript-mode))))

(defun tide/init-tide ()
  (use-package tide
    :defer t
    :mode ("\\.ts\\'" . tide-mode)
    :init (progn
            (push '(company-tide :with company-yasnippet)
                  company-backends-typescript-mode)
            (add-hook 'typescript-mode-hook 'tide/init-tide-mode))
    :config (evil-leader/set-key-for-mode 'typescript-mode
              "mgg" 'tide-jump-to-definition
              "mgb" 'tide-jump-back
              "mhd" 'tide-documentation-at-point
              "mhr" 'tide-references
              "mgn" 'tide-find-next-reference
              "mgp" 'tide-find-previous-reference
              "msr" 'tide-restart-server
              "mrs" 'tide-rename-symbol)))

(when (configuration-layer/layer-usedp 'auto-completion)
  (defun tide/post-init-company ()
    (spacemacs|add-company-hook typescript-mode)))


