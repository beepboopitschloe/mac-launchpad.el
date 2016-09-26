;;; mac-launchpad.el --- open Mac apps from Emacs                     -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Noah Muth

;; Author: Noah Muth <noahmuth@gmail.com>
;; Keywords: macos launchpad
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides an interface for opening OS X apps from inside emacs,
;; with autocompletion. The intention is to provide similar functionality to the
;; native "launchpad" application.
;;
;; TODO:
;; - mac-launchpad doesn't find .apps inside folders, such as Adobe Photoshop
;; - configure applications directory
;; - allow multiple applications directories
;; - add option to show app icons in minibuffer?

;;; Code:
(defun mac-launchpad/string-ends-with (s ending)
  "Return non-nil if string S ends with ENDING."
  (cond ((>= (length s) (length ending))
         (let ((elength (length ending)))
           (string= (substring s (- 0 elength)) ending)))
        (t nil)))

(defun mac-launchpad/find-mac-apps (folder)
  (let* ((files (directory-files folder))
         (without-dots (delete-if (lambda (f) (or (string= "." f) (string= ".." f))) files))
         (all-files (mapcar (lambda (f) (file-name-as-directory (concat (file-name-as-directory folder) f))) without-dots))
         (result (delete-if-not (lambda (s) (mac-launchpad/string-ends-with s ".app/")) all-files)))
    result))

(defun mac-launchpad ()
  (interactive)
  (let* ((apps (mac-launchpad/find-mac-apps "/Applications"))
         (to-launch (completing-read "launch: " apps)))
    (shell-command (format "open %s" to-launch))))

(global-set-key (kbd "C-c C-l") 'mac-launchpad)

(provide 'mac-launchpad)
;;; mac-launchpad.el ends here
