;;; package.use-mode.el --- Emacs mode for editing Gentoo package.use files -*- lexical-binding: t; -*-
;; Copyright (C) 2020 C-xC-c

;; Author: C-xC-c <boku@plum.moe>
;; Created: July 2020
;; Package-Version: 1.3.0
;; Keywords: languages, gentoo
;; URL: https://words.plum.moe/package.use-mode.html
;; Package-Requires: ((emacs "24.1"))

;; This file is not part of GNU Emacs

;;; License:
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Emacs mode for Gentoo package.use
;;
;; Thanks to nginx-mode where I stole most of this.

;;; Code:
(defvar package.use-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "< b" table)
    (modify-syntax-entry ?\n "> b" table)
    table)
  "Syntax table for `package.use-mode'.")

(defvar package.use--version-bit
  (rx line-start (? (or "=" ">" "<" ">=" "<="))))

(defconst package.use--characters
  `(1+ (any alnum "_" "." "+" "*" "-"))
  "The characters allowed in a package.use catagory or name bit.")

(defvar package.use--catagory-bit
  (rx (eval package.use--characters) "/"))

(defvar package.use--name-bit
  (rx (group (eval package.use--characters))))

(defvar package.use-font-lock-keywords
  (list
   ;; >=www-servers/
   ;; www-servers/
   `(,(concat package.use--version-bit package.use--catagory-bit)
     0 font-lock-function-name-face)
   ;; >=nginx-1.19.1
   ;; nginx
   `(,(concat package.use--version-bit package.use--name-bit)
     0 font-lock-keyword-face)
   ;; >=www-servers/nginx-1.19.1
   ;; www-servers/nginx
   `(,(concat package.use--version-bit package.use--catagory-bit package.use--name-bit)
     (1 font-lock-variable-name-face t))
   ;; dev-langs/python:3.7
   `(,(rx ":" (1+ (any digit ".")))
     0 font-lock-type-face t)
   ;; www-servers/nginx NGINX_MODULES_HTTP:
   `(,(rx (1+ whitespace) (1+ (any alnum "_" "-")) ":")
     0 font-lock-constant-face t)))

;;;###autoload
(define-derived-mode package.use-mode prog-mode "package.use"
  :syntax-table package.use-mode-syntax-table
  :keymap nil
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+ *")
  (setq-local comment-end "")
  (setq-local comment-auto-fill-only-comments t)
  (setq-local require-final-newline t)
  (setq-local font-lock-defaults
              '(package.use-font-lock-keywords nil)))

;;;###autoload
(add-to-list 'auto-mode-alist `(,(rx "package." (or "use" "accept_keywords" "mask" "unmask" "license") (or eol "/")) . package.use-mode))

(provide 'package.use-mode)
;;; package.use-mode.el ends here
