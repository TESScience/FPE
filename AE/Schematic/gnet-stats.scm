;; gnetlist back end for extracting design statistics
;;
;; Legal boilerplate here as needed

(define (stats filename)
        (set-current-output-port (open-output-file filename))
		(display-stats)
)

;; Collect and output the statistics

(define (display-stats)
        (format-line "pins:      " (apply + (map length all-pins)))
        (format-line "packages:  " (length packages))
        (format-line "nets:      " (length all-unique-nets))
		(format-line "area cm^2: " (apply + 
			(map (lambda (x) (find-area (gnetlist:get-package-attribute x "footprint"))) packages)))
)

;; Simple output format

(define (format-line name value)
        (display name)
        (display value)
        (newline)
)

;; Constructor for list of package areas

(define area-list '())
(define (area . x)
	(set! area-list (cons x area-list)))

;; search the list

(define (find-area attrib)
	(let ((c (find (lambda (x) (string=? (car x) attrib)) area-list)))
		(if c (cadr c) (error (string-append "Unknown footprint: " attrib)))))


;; Areas of various packages in square cm

(area "0505" 0.016129)
(area "0603" 0.0116129)
(area "0805" 0.0258064)
(area "1206" 0.0464515)
(area "1812" 0.139355)
(area "2512" 0.193548)
(area "2711" 0.191613)
(area "2915" 0.280645)
(area "2225" 0.354838)
(area "747467-1" 7.55663)
(area "BGA484" 5.29)
(area "CDPH4D19F" 0.2401)
(area "CFP16" 1.54838)
(area "DO213AA" 0.0629)
(area "FP14" 5.16128)
(area "FX2CA-68P-1P27DSA" 7.4522)
(area "FX2CA-68S-1P27DSA" 7.4522)
(area "RC422-200-101-3000" 19.144)
(area "RC422-200-201-3900" 19.144)
(area "RC422-200-201-39FT" 19.144)
(area "HEADER14SMT2MM" 1.04895)
(area "HEADER16" 2.06451)
(area "IHLP5050" 1.7028)
(area "MDM25pads" 6.08)
(area "MDM9S" 5.52248)
(area "MSOP10" 0.147)
(area "NK-2M2-051" 3.3387)
(area "SC70" 0.0324)
(area "SC70-6" 0.0324)
(area "SO16" 1.0815)
(area "SO16N" 0.594)
(area "SO8" 0.245)
(area "SOT23" 0.069)
(area "TO252AA" 0.6435)
(area "TO39" 1.32952)
(area "TSSOP16" 0.325)
(area "UB" 0.069)
(area "none" 0.0)
(area "unknown" 0.0)
(area "MDM31P" 5.337)