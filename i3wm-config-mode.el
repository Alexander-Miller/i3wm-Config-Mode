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

(defface i3wm-action-face
  '((t :inherit font-lock-function-name-face))
  "Face for actions or verbs like 'set', 'bindsym', 'move' etc.")

(defface i3wm-modifiers-face
  '((t :inherit font-lock-type-face))
  "Face for modifiers like '--release' and '--no-startup-id'.")

(defface i3wm-numbers-face
  '((t :inherit font-lock-constant-face))
  "Face for numbers.")

(defface i3wm-value-assign-face
  '((t :inherit font-lock-variable-name-face))
  "Face value assignments - e.g. the 'y' in 'set x y'.")

(defface i3wm-bindsym-key-face
  '((t :inherit font-lock-variable-name-face))
  "Face for the keys used in bindsym assignments.")

(defface i3wm-variable-face
  '((t :inherit font-lock-constant-face))
  "Face for $variables.")

(defface i3wm-unit-face
  '((t :inherit font-lock-type-face))
  "Face for units like 'px', 'ms', 'ppt'.")

(defface i3wm-for-window-predictate-face
  '((t :inherit font-lock-builtin-face))
  "Face for the predicates in for_window assignments -
the 'x' in 'for_window [x=y]'.")

(defface i3wm-exec-face
  '((t :inherit font-lock-builtin-face))
  "Face for the text inside an exec statement.")

(defface i3wm-modifier-face
  '((t :inherit font-lock-type-face))
  "Face for action modifiers like 'floating', 'tabbed', 'sticky' or 'current'.")

(defface i3wm-keyword-face
  '((t :inherit font-lock-keyword-face))
  "Face for fixed keywords like 'workspace', 'mode', 'position' or 'fullscreen'.")

(defface i3wm-constant-face
  '((t :inherit font-lock-constant-face))
  "Face for constant values like 'top', 'invisble', 'yes' or 'no'.")

(defface i3wm-block-opener-face
  '((t :inherit font-lock-type-face))
  "Face for the names of items denoting blocks like 'bar {}' and 'colors {}'.")

(defface i3wm-string-face
  '((t :inherit font-lock-string-face))
  "Face for text enclosed in quotes.")

(defface i3wm-comment-face
  '((t :inherit font-lock-comment-face))
  "Face for comments.")

(defface i3wm-operator-face
  '((t :inherit font-lock-builtin-face))
  "Face for various operators like '&&', '+', and '|'.")

;;;###autoload
(define-derived-mode i3wm-config-mode conf-space-mode "i3wm Config")

(font-lock-add-keywords
 'i3wm-config-mode
 `(

   ;; Actions
   ( ,(rx
       (seq
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
     'i3wm-action-face)

   ;; --modifiers
   ( ,(rx (seq
           symbol-start
           (or "--no-startup-id" "--release")
           symbol-end))
     0
     'i3wm-modifiers-face)

   ;; numbers
   ( ,(rx (seq
           symbol-start
           (? (or "-" "+"))
           (group-n 1 (1+ num))))
     1
     'i3wm-numbers-face)

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
     'i3wm-value-assign-face
     t)

   ;; Keys used in `bindsym'
   ( ,(rx (or
           (seq "bindsym" (1+ space) (? (seq "--release" (1+ space))))
           "+")
          (group-n 1 (1+ (or word "_")))
          )
     1
     'i3wm-bindsym-key-face
     t)

   ;; Variables
   ( ,(rx (seq
           symbol-start
           "$"
           (1+ (or "-" "_" word))))
     0
     'i3wm-variable-face
     t)

   ;; units of measurement
   ( ,(rx (seq
           (? (1+ num))
           (group-n 1 (or "px" "pixel" "ms" "ppt"))
           symbol-end))
     1
     'i3wm-unit-face)

   ;; `for_window' predicates
   ( ,(rx (or
           "class"
           "title"
           "instance"
           "window_role"
           "window_type"))
     0
     'i3wm-for-window-predictate-face)

   ;; Command part of an `exec' statement
   ( ,(rx (seq
           "exec"
           (? "_always")
           (1+ space)
           (? "--" (1+ (or "-" word)) (1+ space))
           (group-n 1 (1+ any))
           eol))
     1
     'i3wm-exec-face
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
     'i3wm-modifier-face)

   ;; Keywords
   ( ,(rx (seq
           bow
           (or
            "scratchpad"
            "workspace_auto_back_and_forth"
            "workspace_buttons"
            "workspace"
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
            "smart_gaps"
            "mouse_warping"
            "force_display_urgency_hint"
            "new_window"
            "new_float"
            "font"
            "focus_on_window_activation"
            "pango"
            "status_command"
            "i3bar_command"
            "border"
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
     'i3wm-keyword-face)

   ;; single letter modifiers
   ( ,(rx (seq
           symbol-start
           (or "h" "x" "v")
           symbol-end))
     0
     'i3wm-unit-face)

   ;; Constant values
   ( ,(rx (or
           "i3bar"
           "yes"
           "no"
           "on"
           "none"
           "top"
           "invisible"
           "hidden"
           "dock"
           "mouse"))
     0
     'i3wm-constant-face)

   ;; Values assignments after a `:'
   ( ,(rx (seq
           (1+ nonl)
           ":"
           (group-n 1 (1+ (not (any "\n" "\""))))))
     1
     'i3wm-value-assign-face
     t)

   ;; Block openers
   ( ,(rx (seq
           symbol-start
           (group-n 1 (1+ (or "_" "-" word)))
           symbol-end
           (1+ space)
           "{"))
     1
     'i3wm-block-opener-face)

   ;; + = | : etc
   ( ,(rx (or "+" "&&" "-" "=" "|" ":" "," ";"))
     0
     'i3wm-operator-face)

   ;; commands with more or less arbitrary values
   ( ,(rx (seq
           (or "tray_output" "status_command" "i3bar_command")
           (1+ space)
           (group-n 1 (1+ any) eol)))
     1
     'i3wm-value-assign-face
     t)

   ;; i3-msg, which needs to overwrite the `exec' highlight
   ( ,(rx (seq
           symbol-start
           "i3-msg"
           symbol-end))
     0
     'i3wm-action-face
     t)

   ;; client.*color* assigments
   ( ,(rx (seq
           symbol-start
           (1+ (or "_" word))
           "."
           (1+ (or "_"  word))
           symbol-end))
     0
     'i3wm-keyword-face
     t)

   ;; enforce strings again
   ( ,(rx (seq
           "\"" (1+ (not (any "\""))) "\""))
     0
     'i3wm-string-face
     t)

   ;; enforce commets again
   ( ,(rx (seq
           "#"
           (? (1+ nonl))))
     0
     'i3wm-comment-face
     t)

   ))

(provide 'i3wm-config-mode)

;;; i3wm-config-mode.el ends here
