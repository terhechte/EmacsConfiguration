Add this package to your load path and add an autoload for `emr-show-refactor-menu`.
Bind the `emr-show-refactor-menu` command to something convenient.

(autoload 'emr-show-refactor-menu "emr")
(add-hook 'prog-mode-hook
          (lambda () (local-set-key (kbd "M-RET") 'emr-show-refactor-menu)))

See README.md for more information.
