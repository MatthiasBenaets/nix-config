;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Matthias Benaets"
      user-mail-address "matthias.benaets@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; General settings
(blink-cursor-mode 1)
(setq undo-limit 100000000
      evil-want-fine-undo t
      auto-save-default t)
(setq-default initial-major-mode 'org-mode)
(map! "<escape>" #'keyboard-escape-quit)

;; Scroll
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't
      scroll-preserve-screen-position 'always
      scroll-conservatively 101
      scroll-margin 8
      scroll-step 1)

;; Scaling
(map! "C-+"     #'text-scale-adjust
      "C--"     #'text-scale-adjust
      "C-0"     #'text-scale-adjust)

;; Editing
(map! "M-/"     #'evilnc-comment-operator
      "M-["     #'er/contract-region
      "M-]"     #'er/expand-region)

;; Frame Size
(add-to-list 'default-frame-alist '(height . 24))
(add-to-list 'default-frame-alist '(width . 80))

;; Set height of headers
(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.20))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.15))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.12))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.08))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.05))))
  '(org-document-title ((t (:height 2.5))))
)

;; Bullet UTF-8 icons for org documents
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; Org customization
(defun mb/set-org-vars ()
  (setq org-ellipsis " ▼"
        org-hide-emphasis-markers nil
        org-src-fontify-natively t
        org-fontify-quote-and-verse-blocks t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-src-preserve-indentation t
        org-hide-block-startup nil
        org-startup-folded 'showeverything
        org-startup-with-inline-images t
        org-cycle-separator-lines 2))
(add-hook 'org-mode-hook 'mb/set-org-vars)

(defun mb/org-mode-visual-fill ()
  (setq visual-fill-column-width 110
        visual-fill-column-center-text t)
        (visual-fill-column-mode 1))
(add-hook 'org-mode-hook 'mb/org-mode-visual-fill)

(defun mb/load-prettify-symbols ()
  (interactive)
  (setq prettify-symbols-alist
        (mapcan (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
                '(("(lamda" . ?λ)
                  ("|>" . ?▷)
                  ("<|" . ?◁)
                  ("->>" . ?↠)
                  ("->" . ?→)
                  ("<-" . ?←)
                  ("=>" . ?⇒)
                  ("<=" . ?≤)
                  (">=" . ?≥))))
        (prettify-symbols-mode 1))
(add-hook 'org-mode-hook 'mb/load-prettify-symbols)

;; Org-babel-tangle languages
(add-hook 'org-mode-hook #'org-babel-do-load-languages)
(setq org-confirm-babel-evaluate nil)

;; Windows
(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))
(map! "M-SPC"           #'other-window
      "M-q"             #'delete-window)
(map! :map evil-window-map ;;SPC-w-...
      "SPC"             #'rotate-layout
      ;; Swapping windows
      "C-<left>"        #'+evil/window-move-left
      "C-<down>"        #'+evil/window-move-down
      "C-<up>"          #'+evil/window-move-up
      "C-<right>"       #'+evil/window-move-right)
(map! :leader ;;SPC
      "r"               #'rotate-layout
      "<left>"          #'evil-window-left
      "<down>"          #'evil-window-down
      "<up>"            #'evil-window-up
      "<right>"         #'evil-window-right)

;; Completion
(map! "C-s"             #'consult-line
      "C-f"             #'consult-buffer-other-window
      "C-M-l"           #'consult-imenu)
(map! :leader
      :desc "search"                    "s" #'consult-line
      :desc "kill-buffer"               "k" #'kill-buffer
      (:prefix-map ("b" . "buffer")
        :desc "buffer"                  "b" #'consult-buffer
        :desc "buffer-other-window"     "." #'consult-buffer-other-window)
      (:prefix-map ("f" . "file")
        :desc "find-file-other-window"  "." #'find-file-other-window)
      (:prefix-map ("e" . "eval")
        :desc "eval-region"             "r" #'eval-region
        :desc "eval-buffer"             "b" #'eval-buffer
        :desc "doom/reload"             "d" #'doom/reload))
(define-key! :keymaps +default-minibuffer-maps
             "M-s"      #'consult-history)

;; Disable lazy load which-key
(use-package! which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

;; Ispell and Flyspell
(setq ispell-alternate-dictionary "en_GB,nl_BE")

;; Custom one kye bindings on dashboard
(defun +doom-dashboard-setup-modified-keymap ()
  (setq +doom-dashboard-mode-map (make-sparse-keymap))
  (map! :map +doom-dashboard-mode-map
        :desc "Find file" :ng "f" #'find-file
        :desc "Recent files" :ng "r" #'consult-recent-file
        :desc "Switch buffer" :ng "b" #'consult-buffer
        :desc "Quit" :ng "q" #'save-buffers-kill-emacs
        :desc "Show keybindings" :ng "h" (cmd! (which-key-show-keymap '+doom-dashboard-mode-map))))
(add-transient-hook! #'+doom-dashboard-mode (+doom-dashboard-setup-modified-keymap))
(add-transient-hook! #'+doom-dashboard-mode :append (+doom-dashboard-setup-modified-keymap))
(add-hook! 'doom-init-ui-hook :append (+doom-dashboard-setup-modified-keymap))
;; Open dashboard
(map! :leader :desc "Dashboard" "d" #'+doom-dashboard/open)

;; Dashboard Widgets
(setq +doom-dashboard-functions
      '(doom-dashboard-widget-banner
        ;;doom-dashboard-widget-shortmenu
        doom-dashboard-widget-loaded
        doom-dashboard-widget-footer))
(setq doom-modeline-major-mode-icon t)

;; YASnippets
(setq yas-triggers-in-field t)

;; Python
(setq python-shell-completion-native-disabled-interpreters '("python3")
      python-shell-completion-native-enable nil
      python-shell-interpreter-args "-i"
      python-shell-prompt-detect-failure-warning nil)

;; (map! :after python
;;       :map python-mode-map
;;       :prefix "C-c"
;;       :desc "run-python" :ng "C-p" #'run-python
;;       :desc "python-shell-send-buffer" :ng "C-c" (lambda () (interactive) (run-python) (python-shell-send-buffer)))

(after! python
  (elpy-enable))

(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

(add-hook 'python-mode-hook #'lsp-deferred) ;; Should fix problems with envrc
(after! lsp-python-ms
  (setq lsp-python-ms-executable (executable-find "python-language-server"))
  (set-lsp-priority! 'mspyls 1))

      ;; '(("\\*e?shell\\*\\|*[Pp]ython\\*"
(setq display-buffer-alist
      '(("\\*\\(e?shell\\|terminal\\|[Pp]ython\\)\\*"
         (display-buffer-in-side-window)
         (window-hight . 0.33)
         (side . bottom)
         (slot . -1))
        ("\\*[Cc]ompil.*\\*"
         (display-buffer-in-side-window)
         (window-hight . 0.33)
         (side . bottom)
         (slot . 0))
        ("\\*\\([Hh]elp.*\\|Messages\\|Warnings\\)\\*"
         (display-buffer-in-side-window)
         (window-hight . 0.33)
         (side . bottom)
         (slot . 1))))


;; Load dashboard instead of scratchpad. Only needs to be enable when using nix-community/nix-doom-emacs modules is used
;;(add-hook! 'emacs-startup-hook #'doom-init-ui-h)
