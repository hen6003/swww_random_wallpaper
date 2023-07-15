#! /usr/bin/csi -script
(import (chicken random)
        (chicken file)
        (chicken file posix)
        (posix-utils)
        (chicken process)
        (chicken process-context)
        (optimism))

;; Functions
(define (random-wallpaper wallpapers)
  (list-ref wallpapers
            (pseudo-random-integer (length wallpapers))))

(define (set-wallpaper wallpaper)
  (process-run "swww" (list "img" wallpaper)))

(define (get-option-or-default options get_option default)
  (if (eq? (caar options) get_option)
    (cdar options)
    (if (not (eq? (cdr options) '()))
      (get-option-or-default (cdr options) get_option default)
      default)))

(define (option-exists? options get_option)
  (if (eq? (caar options) get_option)
    #t
    (if (not (eq? (cdr options) '()))
      (option-exists? (cdr options) get_option)
      #f)))

(define (directory-recurse dir)
  (define (check-list files)
    (define file (string-append dir "/" (car files)))

    (define new_files (if (directory? file)
      (directory-recurse file)
      (list file)))

    (if (not (eq? (cdr files) '()))
      (append new_files (check-list (cdr files)))
      new_files))

  (check-list (directory dir)))


;; Defaults
(define wallpaper_path_default
  (string-append (get-shell-variable "HOME") "/Pictures/Wallpapers"))
(define delay_default "30")

;; Get options
(define options (parse-command-line
         `((-help)
           (-h)
           (-wallpapers . path)
           (-delay . string->number))))

(if (or (option-exists? options '-help) (option-exists? options '-h))
  ;; Show help
  (print "usage: " (program-name) " [options]\n"
         "\n"
         "  -help, -h\t\tShow this help\n"
         "  -wallpapers path\tWallpaper path, default: " 
           wallpaper_path_default "\n"
         "  -delay minutes\tDelay before setting new wallpaper, default"
           delay_default)
  ;; Or begin program
  (begin
    ;; Set variables
    (set! wallpaper_path
      (get-option-or-default options '-wallpapers wallpaper_path_default))

    (set! delay_time (* 60
                   (string->number 
                     (get-option-or-default options '-delay delay_default))))

    (do () (#f)
      ;; Get list of wallpapers in path
      (set! wallpapers (directory-recurse wallpaper_path))

      (set! new_wallpaper (random-wallpaper wallpapers))
      (set-wallpaper new_wallpaper)

      (print "Set wallpaper: " new_wallpaper)

      (process-sleep delay_time))))
