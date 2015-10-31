(use-modules (srfi srfi-1))

;; Run the stuff below and issue a diagnostic if any duplicates are found.
;; This exits gnetlist with a status of 1 if it has detected an error.
;; The only output is to (current-error-port).
;;
(define (check-duplicates unused-filename)
	(let 
		(
			(dups (find-duplicates (every-connection)))
		)
		(if (not (null? dups))
			(begin
				(format (current-error-port) 
					"Duplicate refdes-pin combinations:\n    ~A\n"
					dups
				)
				(primitive-exit 1)
			)
		)
	)
)

;; Make a sorted list of every connection to non-graphical symbols in the design.
;; The connections are coded as text in the form refdes-pin.
;;
(define (every-connection)
	
	(sort
		(map refdes-pin
			(apply append
				(map pins-on-package
					(gnetlist:get-packages "dummy")
				)
			)
		)
		string<
	)
)

;; Make a list of (refdes pin) for each pin on the "package" identified by refdes.
;; Utilizes the fact that (gnetlist:get-pins-nets) does not remove duplicates.
;;
(define (pins-on-package refdes)

	(map 
		(lambda (pn)
			(list refdes (car pn))
		)
		(gnetlist:get-pins-nets refdes)
	)
)

;; Make a refdes-pin string from a (refdes pin) list.
;; 
(define (refdes-pin rp)

	(string-append (car rp) "-" (cadr rp))
)

;; Make a list of duplicates from a sorted list
;; This works by zipping a list with itself with the first object dropped,
;; creating a list of pairs of neighbors.
;; It filters that list to find pairs of (equal?) objects.
;; It does not remove duplicated duplicates from the result.
;;
(define (find-duplicates l)

	(if 
		(null? l)
		; then do nothing gracefully
		'()
		; else 
		(unzip1
			(filter 
				(lambda (x)
					(apply equal? x)
				)
				(zip l (cdr l))
			)
		)
	)
)
