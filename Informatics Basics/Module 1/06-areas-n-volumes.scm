(define pi (acos -1))
(define (area-and-volume figure . args)  
  (cond ((equal? figure 'cube) 
         (list (* 6 (car args) (car args))
               (* (car args) (car args) (car args))))
        ((equal? figure 'ball) 
         (list (* 4 pi (car args) (car args))
               (* (/ 4 3) pi (car args) (car args) (car args))))
        ((equal? figure 'cylinder) 
         (list (+ (* 2 pi (car args) (car args)) (* 2 pi (car args) (cadr args)))
                  (* pi (car args) (car args) (cadr args))))
        ((equal? figure 'cone) 
         (list (* pi (car args) (+ (car args) (sqrt (+ (* (car args) (car args)) (* (cadr args) (cadr args))))))
                  (* (/ 1 3) pi (car args) (car args) (cadr args))))
        (else (list))))
