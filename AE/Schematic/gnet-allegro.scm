;;; gEDA - GPL Electronic Design Automation
;;; gnetlist - gEDA Netlist
;;; Copyright (C) 1998-2010 Ales Hvezda
;;; Copyright (C) 1998-2010 gEDA Contributors (see ChangeLog for details)
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
;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
;;; MA 02111-1301 USA.


;; Allegro netlist format

(load-from-path "footprint-pins.scm")

;; Constructor for list of classes by prefix

(define footprint-class-list '())
(define (footprint-class . x)
	(set! footprint-class-list (cons x footprint-class-list)))

;; search the list
;; default to "DISCRETE"

(define (find-footprint-class attrib)
	(let ((c (find (lambda (x) (string-prefix? (car x) attrib)) footprint-class-list)))
		(if c (cadr c) "DISCRETE")))

(define (get-package-class p)
	(or 
		(get-package-attribute-f p "class") 
		(find-footprint-class (gnetlist:get-package-attribute p "footprint"))))


(footprint-class "DIP" "IC")
(footprint-class "SDIP" "IC")
(footprint-class "SIP" "IC")
(footprint-class "ZIP" "IC")
(footprint-class "PLCC" "IC")
(footprint-class "SO" "IC")
(footprint-class "MSSOP" "IC")
(footprint-class "MSOP" "IC")
(footprint-class "SSOP" "IC")
(footprint-class "TSOP" "IC")
(footprint-class "TSSOP" "IC")
(footprint-class "PLCC" "IC")
(footprint-class "US" "IC")
(footprint-class "QFP" "IC")
(footprint-class "LQFP" "IC")
(footprint-class "TQFP" "IC")
(footprint-class "QFN" "IC")
(footprint-class "TQFN" "IC")
(footprint-class "OSC" "IC")
(footprint-class "JUMPER" "IO")
(footprint-class "HEADER" "IO")
(footprint-class "DIN41651" "IO")
(footprint-class "DB" "IO")
(footprint-class "DIN41612" "IO")
(footprint-class "ALF" "DISCRETE")
(footprint-class "LED" "DISCRETE")
(footprint-class "SOT25" "IC")
(footprint-class "SOT325" "IC")
(footprint-class "SOT26" "IC")
(footprint-class "SOT326" "IC")
(footprint-class "TO" "DISCRETE")
(footprint-class "TO3" "DISCRETE")
(footprint-class "TO66" "DISCRETE")
(footprint-class "TO220" "DISCRETE")
(footprint-class "SOD" "DISCRETE")
(footprint-class "SOT23" "DISCRETE")
(footprint-class "SOT323" "DISCRETE")
(footprint-class "SC90" "DISCRETE")
(footprint-class "SOT89" "DISCRETE")
(footprint-class "SOT143" "DISCRETE")
(footprint-class "SOT223" "DISCRETE")
(footprint-class "ACY" "DISCRETE")
(footprint-class "RCY" "DISCRETE")
(footprint-class "BRE" "DISCRETE")
(footprint-class "HC" "DISCRETE")
(footprint-class "RJ11" "IO")
(footprint-class "RJ12" "IO")
(footprint-class "RJ45" "IO")
(footprint-class "0201" "DISCRETE")
(footprint-class "0402" "DISCRETE")
(footprint-class "0603" "DISCRETE")
(footprint-class "0805" "DISCRETE")
(footprint-class "1206" "DISCRETE")
(footprint-class "1210" "DISCRETE")
(footprint-class "1806" "DISCRETE")
(footprint-class "1812" "DISCRETE")
(footprint-class "1825" "DISCRETE")
(footprint-class "2020" "DISCRETE")
(footprint-class "2706" "DISCRETE")
(footprint-class "EIA" "DISCRETE")
(footprint-class "SME" "DISCRETE")


(define allegro:write-device-files
   (lambda (packages done stdout)
      (if (not (null? packages))
         (let ((device (get-device (car packages))))
            (if (contains? done device)
               (allegro:write-device-files (cdr packages) done stdout)
               (begin
                  (if stdout
                    (allegro:output-netlist (car packages))
                    (begin
                      (set-current-output-port
                        (open-output-file
                          (allegro:check-and-get-filename device (car packages))))
                      (allegro:output-netlist (car packages))
                      (close-output-port (current-output-port))))
                  (allegro:write-device-files (cdr packages) (cons device done) stdout)))))))

(define allegro:check-and-get-filename
   (lambda (device package)

      (let ((filename (string-downcase! (string-append "devfiles/" (string-append device ".txt")))))
       (begin
         ;; Check if the 'devfiles' directory exist.
         (if (not (access? "devfiles" F_OK))
           (if (access? "." W_OK)
              ;; If the 'devfiles' directory doesn't exist, and
              ;; we have write access to the current directory, then create it.
              (mkdir "devfiles")
              ;; If we don't have write access to the current directory,
              ;; end with an error message.
              (begin
                (error (string-append
                        "the device files are expected to be in the 'devfiles' directory.\n"
                        "       However, can't create it!.\n"
                        "       Check write permissions of the current directory.\n"))))
           ;; If 'devfiles' exist, check if it is a directory.
           (if (not (eq? (stat:type (stat "devfiles")) 'directory))
               (begin
                 ;; 'devfiles' exists, but it is not a directory.
                 ;; End with an error message.
                 (error (string-append
                         "the device files are expected to be in the 'devfiles' directory.\n"
                         "       However, 'devfiles' exists and it is not a directory!.\n"))
                 )))
         ;; 'devfiles' should exist now. Check if we have write access.
         (if (not (access? "devfiles" W_OK))
             ;; We don't have write access to 'devfiles'.
             ;; End with an error message
             (error (string-append
                     "the device files are expected to be in the 'devfiles' directory.\n"
                     "       However, can't access it for writing!.\n"
                     "       Check write permissions of the 'devfiles' directory.\n"))))

         filename)))

(define (allegro:output-netlist package)
         (display "(Device File generated by gEDA Allegro Netlister)\n")
         (display "PACKAGE ")
         (display (gnetlist:get-package-attribute package "footprint" ))
         (newline)
         (display "CLASS ")
         (display (get-package-class package ))
         (newline)
         (display "PINCOUNT ")
         (display (get-package-pincount package ))
         (newline)
		 (let ((f (get-package-attribute-f package "allegro-options")))
		 	(if f (begin
		 		(display f)
				(newline))))
         (let ((altfoot (gnetlist:get-package-attribute package "alt_foot")))
            (if (not (string=? altfoot "unknown"))
               (begin
                  (display "PACKAGEPROP   ALT_SYMBOLS\n")
                  (display "'(")
                  (display altfoot)
                  (display ")'\n"))))
         (display "END\n"))

(define allegro:components
   (lambda (packages)
      (if (not (null? packages))
         (begin
            (let ((footprint (gnetlist:get-package-attribute (car packages)
                                                           "footprint"))
                  (package (car packages)))
               (if (not (string=? footprint "unknown"))
                  (display footprint))
               (display "! ")
               (display (gnetlist:get-package-attribute package "device"))
               (display "! ")
               (display (get-component-text package))
               (display "; " )
               (display package)
               (newline))
            (allegro:components (cdr packages))))))

(define allegro:display-connections
   (lambda (nets)
      (if (not (null? nets))
         (begin
            (write-char #\space)
            (display (car (car nets)))
            (write-char #\.)
            (display (car (cdr (car nets))))
            (if (null? (cdr nets))
               (newline)
               (begin
                  (write-char #\,)
                  (newline)
                  (allegro:display-connections (cdr nets))
                ))))))

(define allegro:write-net
   (lambda (netnames)
      (if (not (null? netnames))
         (let ((netname (car netnames)))
            (display netname)
            (display ";")
            (allegro:display-connections (gnetlist:get-all-connections netname))
            (allegro:write-net (cdr netnames))))))

(define (allegro output-filename)
  (begin
    (set-current-output-port (gnetlist:output-port output-filename))
    (display "(Allegro netlister by M. Ettus and J. P. Doty)\n")
    (display "$PACKAGES\n")
    (allegro:components packages)
    (display "$NETS\n")
    (allegro:write-net (gnetlist:get-all-unique-nets "dummy"))
    (display "$END\n")
    (if (not (gnetlist:stdout? output-filename))
       (close-output-port (current-output-port)))
    (allegro:write-device-files packages '() (gnetlist:stdout? output-filename))))
