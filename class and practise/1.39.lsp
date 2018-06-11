(define (tan-cf x k)
	(cont-frac (lambda (i) (if (= i 1) x (- 0 (* x x))))
			   (lambda (i) (- (* i 2) 1))
			   k))