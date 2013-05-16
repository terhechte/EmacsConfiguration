;; Load the marmelade repository (mainly for evil)
(require 'package)
(add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;(add-to-list 'package-archives 
;;                 '("marmalade" .
;;                         "http://marmalade-repo.org/packages/"))
(package-initialize)

;; No tabs, only 4 spaces, as default
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; Disable splash screen
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;; Hide the ugly toolbar
(tool-bar-mode -1)

;; Hide the ugly scrollbars
(scroll-bar-mode -1)

;; Highlight matching parenthess
(show-paren-mode 1)

;; Highlight current line
(global-hl-line-mode 1)

(global-linum-mode 1) ; display line numbers in margin. Emacs 23 only.

(setq make-backup-files nil) ; stop creating those backup~ files
(setq auto-save-default nil) ; stop creating those #autosave# files

(recentf-mode 1) ; keep a list of recently opened files

(setq-default line-spacing 0.2) ; add 0.5 height between lines

;; Load evil
(setq evil-want-C-u-scroll t)
;(add-to-list 'load-path "~/.emacs.d/elpa/evil-1.0.1")
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; Load the KeyChord library, to be able to use jj in evil
(add-to-list 'load-path "~/.emacs.d/elpa/key-chord-0.5.20080915/")
(require 'key-chord)
(key-chord-mode 1)

;; http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
;; I want c-n / c-p to work like in emacs
(defun evil-undefine ()
 (interactive)
 (let (evil-mode-map-alist)
   (call-interactively (key-binding (this-command-keys)))))

(define-key evil-insert-state-map "\C-n" 'evil-undefine)
(define-key evil-insert-state-map "\C-p" 'evil-undefine)

(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

;;; esc quits
;;;
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; Org Mode Evil
;; http://stackoverflow.com/questions/8483182/emacs-evil-mode-best-practice
(mapcar (lambda (state)
    (evil-declare-key state org-mode-map
      (kbd "M-l") 'org-metaright
      (kbd "M-h") 'org-metaleft
      (kbd "M-k") 'org-metaup
      (kbd "M-j") 'org-metadown
      (kbd "M-L") 'org-shiftmetaright
      (kbd "M-H") 'org-shiftmetaleft
      (kbd "M-K") 'org-shiftmetaup
      (kbd "M-J") 'org-shiftmetadown))
  '(normal insert))

;; Run emacs in server mode, so that we can connect from commandline
(server-start)

;; Cycle between the last open buffers
(defun switch-to-previous-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))
(define-key evil-normal-state-map "\C-e" 'switch-to-previous-buffer)

;; Autocomplete
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4/")
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete-config)
(ac-config-default)

(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)

;; Enable flycheck for all supported files
(add-to-list 'load-path "~/.emacs.d/elpa/flycheck-20130411.45")
(require 'flycheck)
;(add-hook 'after-init-hook #'global-flycheck-modes)

;; Make sure the option key is mea
(setf mac-option-modifier 'meta)

(require 'yasnippet)

;; Load auto-complete for objc
(add-to-list 'load-path "~/.emacs.d/emacs-clang-complete-async/")
(require 'auto-complete-clang-async)

(defun ac-cc-mode-setup ()
    (setq ac-clang-complete-executable "~/.emacs.d/clang-complete")
      (setq ac-sources '(ac-source-clang-async))
        (ac-clang-launch-completion-process)
        )

(defun my-ac-config ()
    (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
      (add-hook 'auto-complete-mode-hook 'ac-common-setup)
        (global-auto-complete-mode t))

(my-ac-config)

; http://www.emacswiki.org/emacs/GenericMode
; Try adding my own minor mode for taskpaper, that really just offers syntax highlighting
(require 'generic-x)
(define-generic-mode
    'task-mode ;name of the mode
  '("---") ;how comments are defined in mode
  '("@done" "@later" "@testing" "@important" "@non-happen") ;keywords
  nil ;operators
  '("\\.txt$", "\\.taskpaper$", "\\.todo$", "\\.tasks$") ;filenames to activate this mode for
  (list (lambda () (highlight-lines-matching-regexp "\\@done" "hi-green-b")) ;my line colors
        (lambda () (highlight-lines-matching-regexp "\\@later" "hi-blue-b"))
        (lambda () (highlight-lines-matching-regexp "\\@testing" "hi-yellow-b"))
        (lambda () (highlight-lines-matching-regexp "\\@important" "hi-red-b"))
        (lambda () (highlight-lines-matching-regexp "\\@non-happen" "hi-gray-b")))
  "A mode for task files")
  


;; http://stackoverflow.com/questions/6344474/how-can-i-make-emacs-highlight-lines-that-go-over-80-chars
;; free of trailing whitespace and to use 80-column width, standard indentation
(setq whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab)
      whitespace-line-column 80)

;; Keybonds
(global-set-key [(hyper a)] 'mark-whole-buffer)
(global-set-key [(hyper v)] 'yank)
(global-set-key [(hyper c)] 'kill-ring-save)
(global-set-key [(hyper s)] 'save-buffer)
(global-set-key [(hyper l)] 'goto-line)
(global-set-key [(hyper w)]
                (lambda () (interactive) (delete-window)))
(global-set-key [(hyper z)] 'undo)
 
;; mac switch meta key
(defun mac-switch-meta nil 
  "switch meta between Option and Command"
  (interactive)
  (if (eq mac-option-modifier nil)
      (progn
	(setq mac-option-modifier 'meta)
	(setq mac-command-modifier 'hyper)
	)
    (progn 
      (setq mac-option-modifier nil)
      (setq mac-command-modifier 'meta)
      )
    )
  )

