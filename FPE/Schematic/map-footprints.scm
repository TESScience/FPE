(use-modules (srfi srfi-1))

;; Constructor for list of prefixes and counts

(define footprint-list '())
(define (footprint-name . x)
	(set! footprint-list (cons x footprint-list)))

;; Wrap gnetlist:get-package-attribute

(define footprint-map-wrapped-gpa gnetlist:get-package-attribute)

(define (gnetlist:get-package-attribute refdes attribute)
	(let ((value (footprint-map-wrapped-gpa refdes attribute)))
		(if (equal? attribute "footprint") 
			(map-footprint 
				(footprint-map-wrapped-gpa refdes "device")
				 value)
			 value)))

;; Find the footprint map entry or #f

(define (find-footprint device footprint)
	(find (lambda (x) 
		(and (equal? device (car x)) (equal? footprint (cadr x))))
	footprint-list))

;; Extract the mapped footprint name from the entry or not

(define (map-footprint device footprint)
	(let ((f (find-footprint device footprint)))
		(if f (caddr f) footprint)))