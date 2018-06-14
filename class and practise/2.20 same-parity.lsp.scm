(define (connect item num)
	(reverse (cons num (reverse item))))




(define (same-parity u . w)
	(define (iter item result)
		(cond ((null? item) result)
			  ((even? (- (car item) u)) (iter (cdr item) (connect result (car item))))
			  (else (iter (cdr item) result))))
	(iter w (list u)))