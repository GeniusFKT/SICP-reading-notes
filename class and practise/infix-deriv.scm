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
		  (else (list a1 '+ a2))))
				   
(define (make-product a1 a2)
	(cond ((or (=number? a1 0) (=number? a2 0)) 0)
		  ((=number? a1 1) a2)
		  ((=number? a2 1) a1)
		  ((and (number? a1) (number? a2)) (* a1 a2))
		  (else (list a1 '* a2))))
	
(define (addend e)
	(car e))
	
(define (augend e)
	(caddr e))

(define (multiplier e)
	(car e))
	
(define (multiplicand e)
	(caddr e))
	
(define (sum? e)
	(and (pair? e) (same-variable? (cadr e) '+)))
	
(define (product? e)
	(and (pair? e) (same-variable? (cadr e) '*)))