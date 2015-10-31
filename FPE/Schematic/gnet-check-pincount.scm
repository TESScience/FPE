;;; gEDA - GPL Electronic Design Automation
;;; gnet-check-pincount.scm - check that each package in a project has the correct
;;; number of pins.
;;;
;;; Copyright (C)  2015 John P. Doty
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

(use-modules (srfi srfi-1))
(use-modules (ice-9 regex))

(define pincount-port (current-error-port))
(define pincount-error #f)

;; "main" program for use as a back end with -g
;;
(define (check-pincount unused-filename)
	(for-each check-package-pincount packages)
	(format pincount-port "\n")
	(if pincount-error (primitive-exit 1))
)

;; Constructor for list of prefixes and counts
;;
(define footprint-pins-list '())
(define (footprint-pins-prefix . x)
	(set! footprint-pins-list (cons x footprint-pins-list)))

;; search the list
;;
(define (find-footprint-pins attrib)
	(find (lambda (x) (string-prefix? (car x) attrib)) footprint-pins-list))

;; Extract the pin count.
;; If it's attached to the prefix, use that, converted to a string.
;; Otherwise get it from the footprint.
;; This will return #f if the prefix pair is #f,
;; or if the extraction of a number from the footprint fails.
;;
(define (footprint-pin-count prefix attrib)
	(and prefix (if (null? (cdr prefix)) 
		(get-count-from-attrib (car prefix) attrib) 
		(number->string (cadr prefix)))))

;; Extract the pin count from to footprint with the prefix string removed.
(define pin-count-regexp (make-regexp "[0-9]*"))
(define (get-count-from-attrib pre attrib)
	(let ((s (match:substring (regexp-exec pin-count-regexp attrib (string-length pre)))))
		(if (string-null? s) #f s)))

;; Look up the prefix and use it to extract the count.
;; Return #f on failure.
(define (pins-from-footprint f)
	(and f (footprint-pin-count(find-footprint-pins f) f)))

;; Wrap get-package-attribute to return #f rather than "unknown"
(define (get-package-attribute-f p a)
	(let ((v (gnetlist:get-package-attribute p a)))
		(if (string=? v "unknown") #f v)))

;; First try to get the pincount from a pins= attribute.
;; If that fails, try to get it from the footprint.
;; If that fails, resort to counting connections.
;; Not used by check-pincount, but useful if you're loading this
;; code as a tool to get the pincount for other purposes.
(define (get-package-pincount p)
	(or 
		(get-package-attribute-f p "pins") 
		(pins-from-footprint (get-package-attribute-f p "footprint"))
		(number->string (length (gnetlist:get-pins p)))))

(define (check-package-pincount p)
	(let* 	(
			(nu (get-package-attribute-f p "pins-used"))
			(n (get-package-attribute-f p "pins"))
			(fp (get-package-attribute-f p "footprint"))
			(f (pins-from-footprint fp))
			(c (number->string (length (gnetlist:get-pins p))))
		)
		(if nu
			; then pins-used= rules
			(if (not (equal? nu c))
				(pins!=used p nu c)
			)
			(if n
				; then pins= rules
				(if (not (equal? n c))
					(pins!=count p n c)
				)
				; else try using footprint
				(if f 
					; then we have a footprint to use
					(if (not (equal? f c))
						(footprint!=count p f c fp)
					)
				; else have nothing to use
					(pincount-unknown p)
				)
			)
		)
	)
)

(define (pincount-unknown p)
	(format pincount-port "\nCannot determine expected pin count for ~A.\n" p)
	(format pincount-port "Either add a pins= attribute, a pins-used= attribute,")
	(format pincount-port " or use a standard gEDA footprint.\n")
	(set! pincount-error #t)
)

(define (pins!=count p n c)
	(format pincount-port "\n~A has ~A pins, but has attribute pins=~A.\n"
		p c n
	)
	(set! pincount-error #t)
)

(define (pins!=used p n c)
	(format pincount-port "\n~A has ~A pins, but has attribute pins-used=~A.\n"
		p c n
	)
	(set! pincount-error #t)
)

(define (footprint!=count p f c fp)
	(format pincount-port "\n~A has ~A pins, but its footprint ~A has ~A.\n"
		p c fp f
	)
	(set! pincount-error #t)
)

;; Default list of footprint prefixes
;; If only the prefix is given here, the following numeric field
;; in the footprint value will be the expected pin count
;;
(footprint-pins-prefix "DIP")
(footprint-pins-prefix "SDIP")
(footprint-pins-prefix "SIP")
(footprint-pins-prefix "ZIP")
(footprint-pins-prefix "PLCC")
(footprint-pins-prefix "SO")
(footprint-pins-prefix "MSOP")
(footprint-pins-prefix "MSSOP")
(footprint-pins-prefix "SSOP")
(footprint-pins-prefix "TSOP")
(footprint-pins-prefix "TSSOP")
(footprint-pins-prefix "PLCC")
(footprint-pins-prefix "US")
(footprint-pins-prefix "QFP")
(footprint-pins-prefix "LQFP")
(footprint-pins-prefix "TQFP")
(footprint-pins-prefix "QFN")
(footprint-pins-prefix "TQFN")
(footprint-pins-prefix "OSC")
(footprint-pins-prefix "JUMPER")
(footprint-pins-prefix "HEADER")
(footprint-pins-prefix "DIN41651")
(footprint-pins-prefix "DB")
(footprint-pins-prefix "DIN41612")

;; We give the expected pin count explicitly when the numbers following the prefix
;; do not represent a pin count.
;;
(footprint-pins-prefix "ALF" 2)
(footprint-pins-prefix "LED" 2)
(footprint-pins-prefix "SOT25" 5)
(footprint-pins-prefix "SOT325" 5)
(footprint-pins-prefix "SOT26" 6)
(footprint-pins-prefix "SOT326" 6)

;; It's important to get the order right here: later prefixes override earlier.
;; TO39 overrides TO3. TO3 overrides TO.

(footprint-pins-prefix "TO" 3)
(footprint-pins-prefix "TO3" 4)
(footprint-pins-prefix "TO39" 3)
(footprint-pins-prefix "TO66" 4)
(footprint-pins-prefix "TO220" 4)

(footprint-pins-prefix "SOD" 2)
(footprint-pins-prefix "SOT23" 3)
(footprint-pins-prefix "SOT323" 3)
(footprint-pins-prefix "SC90" 3)
(footprint-pins-prefix "SOT89" 4)
(footprint-pins-prefix "SOT143" 3)
(footprint-pins-prefix "SOT223" 3)
(footprint-pins-prefix "ACY" 2)
(footprint-pins-prefix "RCY" 2)
(footprint-pins-prefix "BRE" 2)
(footprint-pins-prefix "HC" 2)
(footprint-pins-prefix "RJ11" 6)
(footprint-pins-prefix "RJ12" 6)
(footprint-pins-prefix "RJ45" 8)
(footprint-pins-prefix "0201" 2)
(footprint-pins-prefix "0402" 2)
(footprint-pins-prefix "0603" 2)
(footprint-pins-prefix "0805" 2)
(footprint-pins-prefix "1206" 2)
(footprint-pins-prefix "1210" 2)
(footprint-pins-prefix "1806" 2)
(footprint-pins-prefix "1812" 2)
(footprint-pins-prefix "1825" 2)
(footprint-pins-prefix "2020" 2)
(footprint-pins-prefix "2706" 2)
(footprint-pins-prefix "EIA" 2)
(footprint-pins-prefix "SME" 2)
