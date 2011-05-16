#lang racket
(require redex)
(require "lang.rkt" "test.rkt" "step.rkt" "annotate.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Trace and stepper

(define-syntax-rule (trace-it R P)
  (traces (R (all-but-last P))
          (last P)
          #:pred (colorize (all-but-last P))))

(define ((colorize Ms) x)
  (define opaques (filter-map (λ (M) (match M
                                       [`(module ,n ,c ☁) n]
                                       [_ #f]))
                              Ms))
  (cond [(redex-match λc~ V x) "green"]
        [(redex-match λc~ B x)
         (redex-let λc~
                    ([(blame ℓ ℓ_0 V C V_0) x])
                    (cond [(equal? (term ℓ) '★) "pink"]
                          [(member (term ℓ) opaques) "pink"]
                          [else "red"]))]
        [else #t]))

(define-syntax-rule (step-it R P)
  (stepper (R (all-but-last P))
           (last P)))

(trace-it -->_vcc~Δ fit-example)
(trace-it -->_vcc~Δ fit-example-rsa-7)
(trace-it -->_vcc~Δ fit-example-keygen-string)
(trace-it -->_vcc~Δ example-8)
(trace-it -->_vcc~Δ example-8-opaque)
(trace-it -->_vcc~Δ list-id-example)
(trace-it -->_vcc~Δ (term (ann ,cons/c-example-raw)))
;(step-it -->_vcc~Δ fit-example)



