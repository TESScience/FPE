;;; gEDA - GPL Electronic Design Automation
;;; censor-fix.scm - plug-in to fix the attribute censorship bug
;;; Copyright (C)  Patrick Bernaud, Peter T. B. Brett, John P. Doty
;;;
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;; Load this file with the -m flag to gnetlist.
;;
;; Checks for consistency when there are multiple attributes attached
;; to a package, instead of yielding the first one. In case of conflict,
;; generates an error message and yields "attribute_conflict" for the
;; attribute value.
;;
;; Requires gnetlist 1.7.0 or later to work properly.
;;
;; Send bug reports to jpd@noqsi.com

;; This function will be called by get-package-attribute to
;; determine the attribute value given a list of values.
;; It ignores #f, which indicates the attribute was missing from
;; a symbol instance. It checks to see if the remaining attribute
;; values are identical.
;;
;; Returns:
;;	#f if no value found
;;	the common value if all values match
;;	"attribute_conflict" if they don't match

(define (unique-attribute refdes name values)
   (let ((v (delq #f values)))
      (if (null? v) #f
         (if (allsame? v) (car v) 
            (attribute-conflict refdes name v)))))


;; Checks that a list contains all same value

(define (allsame? items)
   (every (lambda (item) (equal? item (car items))) items))
	
;; Complain of conflict, yield "attribute_conflict"

(define (attribute-conflict refdes name values)
   (format (current-error-port) "\
Attribute conflict for refdes: ~A
name: ~A
values: ~A
" refdes name values)
   "attribute_conflict")
