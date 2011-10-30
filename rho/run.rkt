#lang racket
(require redex/reduction-semantics)
(require "lang.rkt" "step.rkt" "util.rkt")
(provide (except-out (all-defined-out) test))
(test-suite test run)

(provide -->_vcme)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Step 

(define-syntax-rule (step-it R P)
  (stepper (R (program-modules P))
           `(clos ,(last P) ())))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eval

(define (eval-it R P)
  (apply-reduction-relation* (R (program-modules P))
                             `(clos ,(last P) ())))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Trace 

(define-syntax-rule (trace-it R P . rest)
  (traces (R (program-modules P))
          `(clos ,(last P) ())
          #:pred (colorize (program-modules P))
          . rest))

(define ((colorize Ms) x node)
  (define opaques 
    (filter-map (λ (M) 
                  (match M
                    [(list 'module n lang (list 'define _ •) ... prov) n]
                    [_ #f]))
                Ms))
  (cond [(redex-match λcρ V x) "green"]
        [(redex-match λcρ BLAME x)
         (redex-let λcρ
                    ([(blame LAB any_0 V any_1 V_0) x])
                    (cond [(equal? (term LAB) '★) "pink"]
                          [(member (term LAB) opaques) "pink"]
                          [else "red"]))]
        [(null? (term-node-children node)) "blue"]
        [else #t]))

