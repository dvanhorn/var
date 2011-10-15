#lang racket
(require redex/reduction-semantics)
(require "lang.rkt" "step.rkt" "examples.rkt" "util.rkt")
(provide (except-out (all-defined-out) test))
(test-suite test eval)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evaluation functions

(define (eval_vcΔ P)
  (apply-reduction-relation* (-->_vcΔ (program-modules P))
                             (last P)))

(define (eval_vcc~Δ P)
  (apply-reduction-relation* (-->_vcc~Δ (program-modules P))
                             (last P)))

(test
 (test-predicate (redex-match λc 
                              [(in-hole 𝓔 (blame h g (-- #f) (pred (λ (x) x) g) (-- #f)))])
                 (eval_vcΔ example-8)))