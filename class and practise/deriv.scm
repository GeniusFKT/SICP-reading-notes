(define (deriv expression var)
	(cond ((number? expression) 0)
		  ((variable? expression)
		   (if (same-variable? expression var) 1 0))
		  ((sum? expression)
		   (make-sum (deriv (addend expression) var)
					 (deriv (augend expression) var)))
		  ((product? expression)
		   (make-sum (make-product (multiplier expression)
								   (deriv (multiplicand expression) var))
					 (make-product (multiplicand expression)
								   (deriv (multiplier expression) var))))
		  ((exponentiation? expression)
		   (make-product (exponent expression)
						 (make-product (make-exponentiation (base expression)
															(make-sum (exponent expression) -1))
									   (deriv (base expression) var))))
		  (else (error "unknown expression type -- DERIV" expression))))

		  
(define (variable? e)
	(symbol? e))

(define (same-variable? v1 v2)
	(and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? expression num)
	(and (number? expression) (= expression num)))

(define (make-sum a1 a2)
	(cond ((=number? a1 0) a2)
		  ((=number? a2 0) a1)
		  ((and (number? a1) (number? a2)) (+ a1 a2))
		  (else (list '+ a1 a2))))
				   
(define (make-product a1 a2)
	(cond ((or (=number? a1 0) (=number? a2 0)) 0)
		  ((=number? a1 1) a2)
		  ((=number? a2 1) a1)
		  ((and (number? a1) (number? a2)) (* a1 a2))
		  (else (list '* a1 a2))))
	
(define (addend e)
	(cadr e))
	
(define (augend e)
	(if (> (length (cddr e)) 1)
		(cons '+ (cons (caddr e) (cdddr e)))
		(caddr e)))
	
(define (multiplier e)
	(cadr e))
	
(define (multiplicand e)
	(if (> (length (cddr e)) 1)
		(cons '* (cons (caddr e) (cdddr e)))
		(caddr e)))
	
(define (sum? e)
	(and (pair? e) (same-variable? (car e) '+)))
	
(define (product? e)
	(and (pair? e) (same-variable? (car e) '*)))

(define (exponentiation? e)
	(and (pair? e) (same-variable? (car e) '**)))

(define (base e)
	(cadr e))
	
(define (exponent e)
	(caddr e))
	
(define (make-exponentiation v1 v2)
	(cond ((=number? v2 0) 1)
		  ((=number? v2 1) v1)
		  (else (list '** v1 v2))))


	
	
	
	
	
	
	
	
	
	
	