(use-modules (srfi srfi-1))
(use-modules (ice-9 regex))

;; Constructor for list of prefixes and counts

(define footprint-pins-list '())
(define (footprint-pins-prefix . x)
	(set! footprint-pins-list (cons x footprint-pins-list)))

;; search the list

(define (find-footprint-pins attrib)
	(find (lambda (x) (string-prefix? (car x) attrib)) footprint-pins-list))

;; Extract the pin count.
;; If it's attached to the prefix, use that, converted to a string.
;; Otherwise get it from the footprint.
;; This will return #f if the prefix pair is #f,
;; or if the extraction of a number from the footprint fails.

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
(define (get-package-pincount p)
	(or 
		(get-package-attribute-f p "pins") 
		(pins-from-footprint (get-package-attribute-f p "footprint"))
		(number->string (length (gnetlist:get-pins p)))))

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

(footprint-pins-prefix "ALF" 2)
(footprint-pins-prefix "LED" 2)
(footprint-pins-prefix "SOT25" 5)
(footprint-pins-prefix "SOT325" 5)
(footprint-pins-prefix "SOT26" 6)
(footprint-pins-prefix "SOT326" 6)
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
