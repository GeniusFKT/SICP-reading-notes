;我自己写的牛顿迭代法求根过程
(define delta-x 0.000001)

(define (derivative f x)
	(/ (- (f (+ x delta-x))
		  (f x))
	   delta-x))
	   
(define (newton-method f)
	(define (newton-iter f x n)
		(if (< n 0) x
			(newton-iter f
			(- x (/ (f x) (derivative f x)))
			(- n 1))))
	(newton-method f 1 100))

;SICP中用不动点迭代所使用的方法
(define (fixed-point f first-guess)
    (define (close-enough? a b)
        (< (abs (- a b)) 0.000001))
	(define (try guess)
        (let ((next (f guess)))
			(cond ((close-enough? guess next) next)
                  (else (display next)
				        (newline)
					    (try next)))))
    (try first-guess))

(define (newton-transform g)
	(lambda (x) (- x (/ (g x) ((derivative g) x))))) ;书中的derivative函数返回一个过程
	
(define (newton-method g guess)
	(fixed-point (newton-transform g) guess))
	
	
(define (fixed-point-of-transform g transform guess)
        (fixed-point (transform g) guess))