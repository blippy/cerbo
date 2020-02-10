#lang racket
(require macro-debugger/expand)
;(require swindle)
;(require racket/stream)
;(define ns (make-base-namespace))
;(define ns (current-namespace))
;(define (ev x) (eval x (scheme-report-environment 5)))
;(define (ev x) (eval x (null-environment 5)))
;(define (ev x) (eval x))
;(define (ev x) (eval x ns))
;(define (ev x) (apply x '()))


(define desc "
.SYNTAX PROGRAM
ST = .ID .LABEL * '=' EX1 '.,' .,
PROGRAM = '.SYNTAX' .ID $ ST .END .,
.END
")

(define-syntax-rule (each var lst  body ...)
  (for-each (lambda (var) body ...) lst))

;(each x '(12 13 14)  (display x) (display x) (newline))

   
(define (displays . lst)   (each x lst (display x) (display " ")))
 
#|
  (if (empty? lst)
      (newline)
      (begin
        (display (car lst))
        (displays (cdr lst)))))
  |#           


(define pin void)
(define (pin! str) (set! pin (open-input-string str)))
(define (pc) (peek-char pin))
(define (rc) (read-char pin))

(define (crange? c lo hi) (and (char? c ) (char>=? c lo) (char<=? c hi)))
(define (letter? c) (or (crange? c #\a #\z) (crange? c #\A #\Z)))
(define (digit? c) (crange? c #\0 #\9))
(define (l-or-d? c) (or (digit? c) (letter? c)))
(define (white? c) (member c '(#\tab #\space #\newline)))
(define (non-white? c) (not (white? c)))

(define (accum pred)
  (list->string
   (reverse
    (let loop ((res '()))
      (if (pred (pc))
          (loop (cons (rc) res))
          res)))))

;(define (eat-white) (accum white?))
;(define (accum-1 pred) (eat-white) (accum pred))
(define (get-string)
  (rc)
  (define res (accum (lambda (c) (not (char=? c #\')))))
  (rc)
  res)


(define (-yylex)
  (accum white?) ; eat white-space
  (cond
    [ (char=? #\' (pc)) (list 'str (get-string))]
    [(digit? (pc)) (list 'number (accum digit?))]
    [(letter? (pc)) (list 'id (accum non-white?))]
    [(non-white? (pc)) (list 'lit (accum non-white?))]  
    [else 'dunno]))

(define yytype void)
(define yytext void)
(define (yytype? target) (eq? yytype target))

(define (yylex)
  (define yy (-yylex))
  (set! yytype (car yy))
  (set! yytext (cadr yy)))

(define (out lst)
  (unless (empty? lst)
    (for-each (lambda (x)
                (cond
                  [(eq? x '*) (display yytext)]
                  [else (display x)])
                #t)
              lst)
    (newline)))

(pin! "23  24")

(define (seq . lst) (each pat lst (pat)))

(define ($) (raise "TODO $"))

(define (str s)
  (raise "TODO str"))


(define (.NUMBER . lst)
  (if (yytype? 'number)
      (begin
        (each out lst
              ;(displays "out is" out)
              (cond
                [(string? out) (displays  out " ")]
                [(eq? * out) (displays  yytext)]))
        (newline)
        #t)
      #f))
 
;(define (.NUMBER lst) (raise "TDO"))


(define prog '(seq (.NUMBER "LD " *)
               $ (seq (str "+") (.NUMBER "LD " * "\nADD") )
               ))

(define (prog1) (seq (.NUMBER "LD " *)))




(yylex)
(prog1)