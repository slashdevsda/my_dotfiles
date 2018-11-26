;; Custom emacs settings
;;
;; 2018/11/26
;; tested with emacs 25.3.1, 26.1


;; before anything
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; ensure melpa properly is configured
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;;install requirements if needed
(mapc
 (lambda (package)
   (unless (package-installed-p package)
     (progn (message "installing %s" package)
            (package-refresh-contents)
            (package-install package))))
 '(;; :package list:
   ;;  aesthetics
   solarized-theme
   smart-mode-line smart-mode-line-powerline-theme
   ;;  major modes
   python-mode vue-mode yaml-mode rust-mode clojure-mode plantuml-mode
   ;;  tools
   popwin direx magit multiple-cursors restclient urlenc
   ;;  python
   jedi jedi-direx virtualenvwrapper auto-virtualenv
   ;;  php
   ac-php
   ;;  misc
   markdown-mode
   fireplace lorem-ipsum org-babel-eval-in-repl))


(require 'python-mode)
(require 'popwin)


;; plantuml mode configuration
(setq plantuml-jar-path "/usr/share/plantuml/lib/plantuml.jar")
(setq org-plantuml-jar-path "/usr/share/plantuml/lib/plantuml.jar")

;; input method
;; (allows combination - `C-|` to enable/disable in any buffer),
(setq default-input-method "french-prefix")
(setq set-input-method "french-prefix")


;; global font size
;; uncomment and tweak if you are using
;; some HDPi screen
(set-face-attribute 'default nil :height 105)

;; hide UI if UI
(menu-bar-mode -1)
(tool-bar-mode -1)

;; must-have
(defalias 'yes-or-no-p 'y-or-n-p)


;; multiple cursors settings:
(global-set-key (kbd "C-c M-c") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c <M-right>") 'mc/edit-lines)
(global-set-key (kbd "C-`") 'delete-trailing-whitespace)

;;;;
;;;; Language specific configuration
;;;;

;; Clojure
(add-hook 'clojure-mode-hook
	  (lambda ()
	    ;(add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
	    (eldoc-mode t)
            (auto-complete-mode t)))


;; = Python =

;; directory containing virtualenv(s).
;; change virtual env with `M-x venv-workon`.
;; note that you can use symlinks here.
;;(require 'virtualenvwrapper)
(setq venv-location "~/.virtualenvs/")


;;(autoload 'python-mode "python-mode" "Python Mode." t)
;; jedi (python code completion) setup
(add-hook 'python-mode-hook 'jedi:setup)

;; prevent Eldoc to provide too much documentation when coding,
;; messes up with frames.
(add-hook 'python-mode-hook (lambda () (setq-local eldoc-documentation-function #'ignore)))
(setq jedi:complete-on-dot t)

;; ;; uncoment this block to enable automatic
;; ;; trailing whitespaces deletion upon saving python sources.
;; ;; messes up with version control, use `magit` or `git add -i` to discard
;; ;; impacted chunks.
;; (add-hook 'python-mode-hook (lambda ()
;; 			      (add-hook 'write-file-functions 'delete-trailing-whitespace)))


;; virtualenv support
(venv-initialize-interactive-shells) ;; interactive shell support
(venv-initialize-eshell) ;; eshell support
;; see above for virtualenvs location


;; = JavaScript =
;; indentation (2 spaces)
(setq js-indent-level 2)
(setq-default indent-tabs-mode nil)


;; = PHP =
(require 'cl)
(require 'php-mode)
(add-hook 'php-mode-hook
          '(lambda ()
             (auto-complete-mode t)
             (require 'ac-php)
             (setq ac-sources  '(ac-source-php ) )
             (yas-global-mode 1)
             (ac-php-core-eldoc-setup ) ;; enable eldoc

             (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
             (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back)    ;go back
             ))


;;;;https://stackoverflow.com/questions/5151620/how-do-i-make-this-emacs-frame-keep-its-buffer-and-not-get-resized
(defadvice pop-to-buffer (before cancel-pother-window first)
  (ad-set-arg 1 nil))

(ad-activate 'pop-to-buffer)

;; Toggle window dedication
(defun dedicate-window ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window
                                 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))

;; Press [pause] key in each window you want to "freeze"
(global-set-key [pause] 'dedicate-window)
;;

;; Direx

(defun run-some-commands ()
  "Run `some-command' and `some-other-command' in sequence."
  (interactive)
  (direx-project:jump-to-project-root))
  ;;(direx:jump-to-directory-other-window))

(push '(direx:direx-mode :position left :width 15 :dedicated t)
      popwin:special-display-config)
;;(global-set-key (kbd "C-c j") 'direx:jump-to-directory-other-window)
(global-set-key (kbd "C-c x") 'run-some-commands)


;; temporary & saves
;; backups into /tmp, no more needed to tweak `.gitignore`
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;; lorem ipsum, generate random text
;; on the fly
(require 'lorem-ipsum)
(lorem-ipsum-use-default-bindings)
;; This will setup the folling keybindings:
;; C-c l p: lorem-ipsum-insert-paragraphs
;; C-c l s: lorem-ipsum-insert-sentences
;; C-c l l: lorem-ipsum-insert-list




;; org-babel

(with-eval-after-load "ob"
  (require 'org-babel-eval-in-repl)
  (define-key org-mode-map (kbd "C-<return>") 'ober-eval-in-repl)
  (define-key org-mode-map (kbd "C-c C-c") 'ober-eval-block-in-repl))

;; add plantuml to org-babel
;; supported langages
;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))

;; enable org-babel export
;; to markdown
(eval-after-load "org"
  '(require 'ox-md nil t))

;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(package-selected-packages
   (quote
    (markdown-mode go-mode racket-mode cider cider-decompile org-babel-eval-in-repl lorem-ipsum plantuml-mode auto-virtualenv rust-mode clojure-mode fireplace yaml-mode vue-mode virtualenvwrapper urlenc solarized-theme restclient python-mode powerline magit jedi-direx popwin multiple-cursors))))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :family "Monoid")))))



;; AESTHETICS

;; smart mode line
(smart-mode-line-enable)
(setq sml/theme 'powerline)
(sml/setup)

;; set window tranparency, tweak
;; this if you want a transparent windows
;; (only works with X)
(set-frame-parameter (selected-frame) 'alpha '(92 . 88))
(add-to-list 'default-frame-alist '(alpha . (92 . 88)))
(set-frame-parameter (selected-frame) 'alpha '(100 . 100))

;; prettify-symbols-mode configuration
(global-prettify-symbols-mode +1)

(add-hook 'python-mode-hook
            (lambda ()
              (push '("lambda" . ?λ) prettify-symbols-alist)
              (push '("in" . ?∈) prettify-symbols-alist)
              (push '("not in" . ?∉) prettify-symbols-alist)))

;; from https://gist.github.com/alphapapa/0d38f082e609ed059cc7f2ed9caa7e3d
;; Fira code
;; This works when using emacs --daemon + emacsclient
;;(add-hook 'after-make-frame-functions (lambda (frame) (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol")))
;; This works when using emacs without server/client
(set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol")
;; I haven't found one statement that makes both of the above situations work, so I use both for now
(defconst fira-code-font-lock-keywords-alist
  (mapcar (lambda (regex-char-pair)
            `(,(car regex-char-pair)
              (0 (prog1 ()
                   (compose-region (match-beginning 1)
                                   (match-end 1)
                                   ;; The first argument to concat is a string containing a literal tab
                                   ,(concat "	" (list (decode-char 'ucs (cadr regex-char-pair)))))))))
          '(("\\(www\\)"                   #Xe100)
            ("[^/]\\(\\*\\*\\)[^/]"        #Xe101)
            ("\\(\\*\\*\\*\\)"             #Xe102)
            ("\\(\\*\\*/\\)"               #Xe103)
            ("\\(\\*>\\)"                  #Xe104)
            ("[^*]\\(\\*/\\)"              #Xe105)
            ("\\(\\\\\\\\\\)"              #Xe106)
            ("\\(\\\\\\\\\\\\\\)"          #Xe107)
            ("\\({-\\)"                    #Xe108)
            ;;"\\(\\[\\]\\)"                #Xe109)
            ("\\(::\\)"                    #Xe10a)
            ("\\(:::\\)"                   #Xe10b)
            ("[^=]\\(:=\\)"                #Xe10c)
            ("\\(!!\\)"                    #Xe10d)
            ("\\(!=\\)"                    #Xe10e)
            ("\\(!==\\)"                   #Xe10f)
            ("\\(-}\\)"                    #Xe110)
            ("\\(--\\)"                    #Xe111)
            ("\\(---\\)"                   #Xe112)
            ("\\(-->\\)"                   #Xe113)
            ("[^-]\\(->\\)"                #Xe114)
            ("\\(->>\\)"                   #Xe115)
            ("\\(-<\\)"                    #Xe116)
            ("\\(-<<\\)"                   #Xe117)
            ("\\(-~\\)"                    #Xe118)
            ("\\(#{\\)"                    #Xe119)
            ("\\(#\\[\\)"                  #Xe11a)
            ("\\(##\\)"                    #Xe11b)
            ("\\(###\\)"                   #Xe11c)
            ("\\(####\\)"                  #Xe11d)
            ("\\(#(\\)"                    #Xe11e)
            ("\\(#\\?\\)"                  #Xe11f)
            ("\\(#_\\)"                    #Xe120)
            ("\\(#_(\\)"                   #Xe121)
            ("\\(\\.-\\)"                  #Xe122)
            ("\\(\\.=\\)"                  #Xe123)
            ("\\(\\.\\.\\)"                #Xe124)
            ("\\(\\.\\.<\\)"               #Xe125)
            ("\\(\\.\\.\\.\\)"             #Xe126)
            ("\\(\\?=\\)"                  #Xe127)
            ("\\(\\?\\?\\)"                #Xe128)
            ("\\(;;\\)"                    #Xe129)
            ("\\(/\\*\\)"                  #Xe12a)
            ("\\(/\\*\\*\\)"               #Xe12b)
            ("\\(/=\\)"                    #Xe12c)
            ("\\(/==\\)"                   #Xe12d)
            ("\\(/>\\)"                    #Xe12e)
            ("\\(//\\)"                    #Xe12f)
            ("\\(///\\)"                   #Xe130)
            ("\\(&&\\)"                    #Xe131)
            ("\\(||\\)"                    #Xe132)
            ("\\(||=\\)"                   #Xe133)
            ("[^|]\\(|=\\)"                #Xe134)
            ("\\(|>\\)"                    #Xe135)
            ("\\(\\^=\\)"                  #Xe136)
            ("\\(\\$>\\)"                  #Xe137)
            ("\\(\\+\\+\\)"                #Xe138)
            ("\\(\\+\\+\\+\\)"             #Xe139)
            ("\\(\\+>\\)"                  #Xe13a)
            ("\\(=:=\\)"                   #Xe13b)
            ("[^!/]\\(==\\)[^>]"           #Xe13c)
            ("\\(===\\)"                   #Xe13d)
            ("\\(==>\\)"                   #Xe13e)
            ("[^=]\\(=>\\)"                #Xe13f)
            ("\\(=>>\\)"                   #Xe140)
            ("\\(<=\\)"                    #Xe141)
            ("\\(=<<\\)"                   #Xe142)
            ("\\(=/=\\)"                   #Xe143)
            ("\\(>-\\)"                    #Xe144)
            ("\\(>=\\)"                    #Xe145)
            ("\\(>=>\\)"                   #Xe146)
            ("[^-=]\\(>>\\)"               #Xe147)
            ("\\(>>-\\)"                   #Xe148)
            ("\\(>>=\\)"                   #Xe149)
            ("\\(>>>\\)"                   #Xe14a)
            ("\\(<\\*\\)"                  #Xe14b)
            ("\\(<\\*>\\)"                 #Xe14c)
            ("\\(<|\\)"                    #Xe14d)
            ("\\(<|>\\)"                   #Xe14e)
            ("\\(<\\$\\)"                  #Xe14f)
            ("\\(<\\$>\\)"                 #Xe150)
            ("\\(<!--\\)"                  #Xe151)
            ("\\(<-\\)"                    #Xe152)
            ("\\(<--\\)"                   #Xe153)
            ("\\(<->\\)"                   #Xe154)
            ("\\(<\\+\\)"                  #Xe155)
            ("\\(<\\+>\\)"                 #Xe156)
            ("\\(<=\\)"                    #Xe157)
            ("\\(<==\\)"                   #Xe158)
            ("\\(<=>\\)"                   #Xe159)
            ("\\(<=<\\)"                   #Xe15a)
            ("\\(<>\\)"                    #Xe15b)
            ("[^-=]\\(<<\\)"               #Xe15c)
            ("\\(<<-\\)"                   #Xe15d)
            ("\\(<<=\\)"                   #Xe15e)
            ("\\(<<<\\)"                   #Xe15f)
            ("\\(<~\\)"                    #Xe160)
            ("\\(<~~\\)"                   #Xe161)
            ("\\(</\\)"                    #Xe162)
            ("\\(</>\\)"                   #Xe163)
            ("\\(~@\\)"                    #Xe164)
            ("\\(~-\\)"                    #Xe165)
            ("\\(~=\\)"                    #Xe166)
            ("\\(~>\\)"                    #Xe167)
            ("[^<]\\(~~\\)"                #Xe168)
            ("\\(~~>\\)"                   #Xe169)
            ("\\(%%\\)"                    #Xe16a)
            ;;("\\(x\\)"                     #Xe16b)
            ("[^:=]\\(:\\)[^:=]"           #Xe16c)
            ("[^\\+<>]\\(\\+\\)[^\\+<>]"   #Xe16d)
            ("[^\\*/<>]\\(\\*\\)[^\\*/<>]" #Xe16f))))

(defun add-fira-code-symbol-keywords ()
  (font-lock-add-keywords nil fira-code-font-lock-keywords-alist))

(add-hook 'prog-mode-hook
          #'add-fira-code-symbol-keywords)

;;(sml/apply-theme "light powerline")
;;(global-set-key (kbd "C-c <C-tab>") 'hs-toggle-hiding)

;; misc
;;(global-eldoc-mode -1)
(quietly-read-abbrev-file nil)
(column-number-mode)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
