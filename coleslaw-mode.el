(defun group (ps n)
  (if (zerop n) (error "zero length"))
  (labels ((rec (source acc)
             (let ((rest (nthcdr n source)))
               (if (consp rest)
                   (rec rest (cons
                               (subseq source 0 n)
                               acc))
                   (nreverse
                     (cons source acc))))))
    (if source (rec source nil) nil)))

(defmacro defkeys (map &rest (key-fn-ps))
  `(dolist ((p (group ',key-fn-ps 2))
	    (define-key (kbd ,(car p)) ',(cadr p)))))

(defvar coleslaw-mode-hook nil)
(defun coleslaw-indent ()
  (interactive)
  (beginning-of-line))
(defun coleslaw-insert-header ()
  (insert ";;;;; 
title: 
url: 
format: 
date: 
;;;;;"))
(defvar coleslaw-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "H-c") 'markdown-preview-eww)
    (define-key map (kbd "M-;") 'coleslaw-insert-header)
    (define-key map (kbd "C-j") 'coleslaw-indent)
    map)
  "Keymap for COLESLAW major mode")
(define-derived-mode coleslaw-mode markdown "COLESLAW" 
  "Mode for editing coleslaw site generation files."
  (interactive)
  (kill-all-local-variables)
  (use-local-map coleslaw-mode-map)
  (add-hook 'coleslaw-mode-hook 'flyspell-mode)
  ;(add-hook 'coleslaw-mode-hook 'markdown-mode)
  (setq minor-mode 'coleslaw-mode)
  (setq mode-name "COLESLAW")
  (run-hooks 'coleslaw-mode-hook))
(add-to-list 'auto-mode-alist '("\\.page\\'" . coleslaw-mode))
(add-to-list 'auto-mode-alist '("\\.post\\'" . coleslaw-mode))
(provide 'coleslaw-mode)
;; Should not to require these in case cl-who or otherwise is wanted, once it is implemented.
(setq browse-url-browser-function 'w3m-goto-url)
(autoload 'markdown-mode "markdown-mode"			       
  "Major mode for editing Markdown files")			       
(autoload 'markdown-preview-eww "view markdown in w3m web browser.") 

