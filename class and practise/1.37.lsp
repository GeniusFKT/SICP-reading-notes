(define (cont-frac n d k)
	(define (rec i)
		(if (> i k) 0
			(/ (n i) (+ (d i) (rec (+ i 1))))))
	(rec 1))
	
	
(define (cont-frac n d k)
	(define (iter i res)
		(if (= i 0) res
			(iter (- i 1) (/ (n i) (+ (d i) res)))))
	(iter k 0.0))