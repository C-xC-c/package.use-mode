;;; package.use-mode.el --- Emacs mode for editing Gentoo package.use files -*- lexical-binding: t; -*-
;; Copyright (C) 2020 C-xC-c

;; Author: C-xC-c <boku@plum.moe
;; Created: July 2020
;; Package-Version: 1.0.0
;; Keywords: gentoo, package.use 
;; URL: https://words.plum.moe/package.use-mode.html

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
;;Thanks to nginx-mode where I stole most of this.

;;; Code:

(defvar package.use-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "< b" table)
    (modify-syntax-entry ?\n "> b" table)
    table)
  "Syntax table for `package.use-mode'.")

(setq package.use--repos
      '("acct-group/" "acct-user/" "app-accessibility/" "app-admin/" "app-antivirus/"
        "app-arch/" "app-backup/" "app-benchmarks/" "app-cdr/" "app-crypt/"
        "app-dicts/" "app-doc/" "app-editors/" "app-emacs/" "app-emulation/"
        "app-eselect/" "app-forensics/" "app-i18n/" "app-laptop/" "app-leechcraft/"
        "app-metrics/" "app-misc/" "app-mobilephone/" "app-office/" "app-officeext/"
        "app-pda/" "app-portage/" "app-shells/" "app-text/" "app-vim/" "app-xemacs/"
        "dev-ada/" "dev-cpp/" "dev-db/" "dev-dotnet/" "dev-embedded/" "dev-erlang/"
        "dev-games/" "dev-go/" "dev-haskell/" "dev-java/" "dev-lang/" "dev-libs/"
        "dev-lisp/" "dev-lua/" "dev-ml/" "dev-perl/" "dev-php/" "dev-python/"
        "dev-qt/" "dev-ros/" "dev-ruby/" "dev-scheme/" "dev-tcltk/" "dev-tex/"
        "dev-texlive/" "dev-util/" "dev-vcs/" "eclass/" "games-action/"
        "games-arcade/" "games-board/" "games-emulation/" "games-engines/"
        "games-fps/" "games-kids/" "games-misc/" "games-mud/" "games-puzzle/"
        "games-roguelike/" "games-rpg/" "games-server/" "games-simulation/"
        "games-sports/" "games-strategy/" "games-util/" "gnome-base/" "gnome-extra/"
        "gnustep-apps/" "gnustep-base/" "gnustep-libs/" "gui-apps/" "gui-libs/"
        "gui-wm/" "java-virtuals/" "kde-apps/" "kde-frameworks/" "kde-misc/"
        "kde-plasma/" "licenses/" "lxde-base/" "lxqt-base/" "mail-client/"
        "mail-filter/" "mail-mta/" "mate-base/" "mate-extra/" "media-fonts/"
        "media-gfx/" "media-libs/" "media-plugins/" "media-radio/" "media-sound/"
        "media-tv/" "media-video/" "metadata/" "net-analyzer/" "net-dialup/"
        "net-dns/" "net-firewall/" "net-fs/" "net-ftp/" "net-im/" "net-irc/"
        "net-libs/" "net-mail/" "net-misc/" "net-nds/" "net-news/" "net-nntp/"
        "net-p2p/" "net-print/" "net-proxy/" "net-voip/" "net-vpn/" "net-wireless/"
        "perl-core/" "profiles/" "ros-meta/" "sci-astronomy/" "sci-biology/"
        "sci-calculators/" "sci-chemistry/" "sci-electronics/" "sci-geosciences/"
        "sci-libs/" "sci-mathematics/" "sci-misc/" "sci-physics/" "sci-visualization/"
        "scripts/" "sec-policy/" "sys-apps/" "sys-auth/" "sys-block/" "sys-boot/"
        "sys-cluster/" "sys-devel/" "sys-fabric/" "sys-firmware/" "sys-fs/"
        "sys-kernel/" "sys-libs/" "sys-power/" "sys-process/" "virtual/" "www-apache/"
        "www-apps/" "www-client/" "www-misc/" "www-plugins/" "www-servers/"
        "x11-apps/" "x11-base/" "x11-drivers/" "x11-libs/" "x11-misc/" "x11-plugins/"
        "x11-terms/" "x11-themes/" "x11-wm/" "xfce-base/" "xfce-extra/" "*/"))

(setq package.use--repos-joined (concat "\\(" (string-join package.use--repos "\\|") "\\)"))
(defvar package.use--version-bit "^\\([=<>]*\\)?")
(setq package.use--name-bit "\\([A-Za-z0-9_\\*-]+\\)")

(setq package.use-font-lock-keywords
      (list `(,(concat package.use--version-bit package.use--repos-joined package.use--name-bit)
              (0 font-lock-function-name-face)
              (3 font-lock-variable-name-face t))
            `(,(concat package.use--version-bit package.use--name-bit) . font-lock-keyword-face)
            '(":[0-9]+" 0 font-lock-builtin-face t)
            '("[ \\t]+[A-Za-z09_-]+:" 0 font-lock-constant-face t)))

(define-derived-mode package.use-mode prog-mode "package.use"
  :syntax-table nginx-mode-syntax-table
  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-start-skip) "#+ *")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-auto-fill-only-comments) t)

  (set (make-local-variable 'require-final-newline) t)
  
  (set (make-local-variable 'font-lock-defaults)
       '(package.use-font-lock-keywords nil)))

;;;###autoload
(add-to-list 'auto-mode-alist '("package\\.use'"  . package.use-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("/package\\.use/" . package.use-mode))

(provide 'package.use-mode)
;;; package.use-mode.el ends here
