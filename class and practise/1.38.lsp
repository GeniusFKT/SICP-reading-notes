(define (cal-e n)
	(if (= 2 (remainder n 3)) 
		(/ (* 2 (+ n 1)) 3)
		1))
		
(+ 2 (cont-frac (lambda (i) 1.0) cal-e 1.0))