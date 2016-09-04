;;; i3wm-config-mode.el --- Better syntax highlighting for i3wm's config file

;; Copyright (C) 2016 Alexander Miller

;; Author: Alexander Miller <alexanderm@web.de>
;; Package-Requires: ()
;; Homepage: https://github.com/Alexander-Miller/i3wm-Config-Mode
;; Version: 1.0
;; Keywords: i3, config, syntax highlighting, font-lock

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

;;; Code:

(define-derived-mode i3wm-config-mode conf-space-mode "i3wm Config")

(add-hook 'i3wm-config-mode-hook #'i3wm-config-custom-font-locking)

(defun i3wm-config-custom-font-locking ()
  (font-lock-add-keywords
   nil
   `(

     ;; Actions
     ( ,(rx (seq
             symbol-start
             (or
              "set"
              "disable"
              "set_from_resource"
              "back_and_forth"
              "bindsym"
              "to"
              "or"
              "exec"
              "exec_always"
              "kill"
              "nop"
              "move"
              "show"
              "split"
              "focus"
              "toggle"
              "i3-msg"
              "reload"
              "restart"
              "resize"
              "grow"
              "shrink"
              "plus"
              "minus"
              "enable"
              "assign"
              "for_window")
             symbol-end))
       0
       font-lock-function-name-face)

     ;; --modifiers
     ( ,(rx (seq
             symbol-start
             (or "--no-startup-id" "--release")
             symbol-end))
       0
       font-lock-type-face)

     ;; Variables
     ( ,(rx (seq
             symbol-start
             "$"
             (1+ (or "-" "_" word))
             symbol-end))
       0
       font-lock-constant-face)

     ;; numbers
     ( ,(rx (seq
             symbol-start
             (1+ num)))
       0
       font-lock-constant-face)

     ;; value part of `set x y'
     ( ,(rx (seq
             bol
             "set"
             (? "_from_resource")
             (1+ space)
             "$" (1+ (or "_" "-" word))
             (1+ space)
             (group-n 1 symbol-start (1+ (or "-" "_" alnum)) symbol-end)))
       1
       font-lock-variable-name-face
       t)

     ;; Keys used in `bindsym'
     ( ,(rx (or
             (seq "bindsym" (1+ space) (? (seq "--release" (1+ space))))
             "+")
            (group-n 1 (1+ (or word "_"))))
       1
       font-lock-variable-name-face
       )

     ;; units of measurement
     ( ,(rx (seq
             (? (1+ num))
             (group-n 1 (or "px" "ms" "ppt"))
             symbol-end))
       1
       font-lock-type-face)

     ;; `for_window' predicates
     ( ,(rx (or
             "class"
             "title"
             "instance"
             "window_role"
             "window_type"))
       0
       font-lock-builtin-face)

     ;; Command part of an `exec' statement
     ( ,(rx (seq
             "exec"
             (? "_always")
             (1+ space)
             (? "--" (1+ (or "-" word)) (1+ space))
             (group-n 1 (1+ any))
             eol))
       1
       font-lock-builtin-face
       t)

     ;; Action modifiers
     ( ,(rx (seq
             (or
              "tabbed"
              "stacking"
              "left"
              "right"
              "up"
              "down"
              "urgent"
              "sticky"
              "current"
              "global"
              "outer"
              "inner"
              "latest"
              "floating"
              "mode_toggle"
              "all"
              )
             symbol-end))
       0
       font-lock-type-face)

     ;; Keywords
     ( ,(rx (seq
             bow
             (or
              (seq bow (1+ (or "_" alnum)) eow "." bow (1+ (or "_"  alnum)) eow)
              "scratchpad"
              "workspace_auto_back_and_forth"
              "workspace_buttons"
              "workspace"
              "pixel"
              "mode"
              "gaps"
              "output"
              "parent"
              "child"
              "container"
              "layout"
              "height"
              "width"
              "floating_modifier"
              "focus_follows_mouse"
              "smart_borders"
              "mouse_warping"
              "force_display_urgency_hint"
              "new_window"
              "new_float"
              "font"
              "focus_on_window_activation"
              "pango"
              "status_command"
              "i3bar_command"
              "position"
              "tray_padding"
              "tray_output"
              "strip_workspace_numbers"
              "binding_mode_indicator"
              "background"
              "binding_mode"
              "statusline"
              "separator_symbol"
              "separator"
              "focused_workspace"
              "active_workspace"
              "inactive_workspace"
              "urgent_workspace"
              "number"
              "window"
              "fullscreen")
             eow
             ))
       0
       font-lock-keyword-face)

     ;; single letter modifiers
     ( ,(rx (seq
             symbol-start
             (or "h" "x" "v")
             symbol-end))
       0
       font-lock-type-face)

     ;; Constant values
     ( ,(rx (or
             "i3bar"
             "yes"
             "no"
             "none"
             "top"
             "dock"
             "mouse"))
       0
       font-lock-constant-face)

     ;; Values assignments after a `:'
     ( ,(rx (seq
             (1+ nonl)
             ":"
             (group-n 1 (1+ (not (any "\n" "\""))))))
       1
       font-lock-builtin-face
       t)

     ;; + = | ( ) { } [ ] : etc
     ( ,(rx (or "+" "&&" "-" "=" "|" ":" "," ";"))
       0
       font-lock-builtin-face)

     ;; commands with more or less arbitrary values
     ( ,(rx (seq
             (or "tray_output" "status_command" "i3bar_command")
             (1+ space)
             (group-n 1 (1+ any) eol)))
       1
       font-lock-constant-face
       t)

     ;; i3-msg, which needs to overwrite the `exec' highlight
     ( ,(rx (seq symbol-start "i3-msg" symbol-end))
       0
       font-lock-function-name-face
       t)

     ;; enforce strings again
     ( ,(rx (seq
             "\"" (1+ (not (any "\""))) "\""))
       0
       font-lock-string-face
       t)

     ;; enforce commets again
     ( ,(rx (seq
             "#"
             (? (1+ nonl))))
       0
       font-lock-comment-face
       t)

     )))

(provide 'i3wm-config-mode)

;;; i3wm-config-mode.el ends here
