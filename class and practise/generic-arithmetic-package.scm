(define (attcah-tag type-tag contents)
	(if (number? contents)
		contents
		(cons type-tag contents)))

(define (type-tag datum)
	(cond ((number? datum) 'scheme-number)
		  ((pair? datum) (car datum))
		  (else (error "Bad tagged datum -- TYPE-TAG" datum))))
		
(define (contents datum)
	(cond ((number? datum) datum)
		  ((pair? datum) (cdr datum))
		  (else (error "Bad tagged datum -- CONTENTS" datum))))

; 二元含强制类型转换通用操作		  
(define (apply-generic op . args)
	(let ((type-tags (map type-tag args)))
		 (let ((proc (get op type-tags)))
			  (if proc
				  (apply proc (map contents args))
				  (if (= (length args) 2)
					  (let ((type1 (car type-tags))
							(type2 (cdr type-tags))
							(a1 (car args))
							(a2 (cadr args)))
						   (let ((t1->t2 (get-coercion type1 type2))
								 (t2->t1 (get-coercion type2 type1)))
								(cond ((t1->t2) (apply-generic op (t1->t2 a1) a2))
									  ((t2->t1) (apply-generic op a1 (t2->t1 a2)))
									  (else (error "No method for these types"
												   (list op type-tags))))))
					  (error "No method for these types"
							 (list op type-tags)))))))
									   
					
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (equ? x y) (apply-generic 'equ? x y))
(define (=zero? x) (apply-generic '=zero? x))

; 常规数的包
(define (install-scheme-number-package)

	(define (tag x) 
		(attach-tag 'scheme-number x))
	(put 'add '(scheme-number scheme-number)
		(lambda (x y) (tag (+ x y))))
	(put 'sub '(scheme-number scheme-number)
		(lambda (x y) (tag (- x y))))
	(put 'mul '(scheme-number scheme-number)
		(lambda (x y) (tag (* x y))))
	(put 'div '(scheme-number scheme-number)
		(lambda (x y) (tag (/ x y))))
	(put 'equ? '(scheme-number scheme-number)
		(lambda (x y) (tag (= x y))))
	(put '=zero? '(scheme-number)
		(lambda (x) (tag (= x 0))))
		
	(put 'make 'scheme-number
		(lambda (x) (tag x)))
		
	'done)

; 创建带标志的常规数
(define (make-scheme-number n)
	((get 'make 'scheme-number) n))
	
; 有理数包
(define (install-rational-package)
	
	; internal procedures
	(define (numer x) (car x))
	(define (denom x) (cdr x))
	(define (make-rat n d) 
		(let ((g (gcd n d)))
			(cons (/ n g) (/ d g))))
			
	(define (add-rat x y)
		(make-rat (+ (* (numer x) (denom y))
					 (* (numer y) (denom x)))
				  (* (denom x) (denom y))))
	(define (sub-rat x y)
		(make-rat (- (* (numer x) (denom y))
					 (* (numer y) (denom x)))
				  (* (denom x) (denom y))))			  
	(define (mul-rat x y)
		(make-rat (* (numer x) (numer y))
				  (* (denom x) (denom y))))
	(define (div-rat x y)
		(make-rat (* (numer x) (denom y))
				  (* (denom x) (numer y))))				  
	(define (equ?-rat x y)
		(= (* (numer x) (denom y))
		   (* (denom x) (numer y))))
	(define (=zero?-rat x)
		(and (= (numer x) 0) (not (= (denom x) 0))))
	
	; interface to rest of the system
	
	(define (tag x) (attach-tag 'rational x))
	(put 'add '(rational rational)
		(lambda (x y) (tag (add-rat x y))))
	(put 'sub '(rational rational)
		(lambda (x y) (tag (sub-rat x y))))
	(put 'mul '(rational rational)
		(lambda (x y) (tag (mul-rat x y))))
	(put 'div '(rational rational)
		(lambda (x y) (tag (div-rat x y))))
	(put 'equ? '(rational rational)
		equ?-rat)
	(put '=zero? '(rational)
		=zero?-rat)
		
	(put 'make 'rational
		(lambda (n d) (tag (make-rat n d))))
	
	'done)
	
(define (make-rational n d)
	((get 'make 'rational) n d))


(define (install-rectangular-package)
	
	; internal procedures (same as previous procedures)
	(define (make-from-real-imag x y)
		(cons x y))
	(define (real-part z)
		(car z))
	(define (imag-part z)
		(cdr z))
	(define (make-from-magn-angl r a)
		(cons (* r (cos a)) (* r (sin a))))
	(define (magnitude z)
		(sqrt (+ (square (real-part z)) (square (imag-part z)))))
	(define (angle z)
		(atan (imag-part z) (real-part z)))
	
	; interface to the rest of the system
	(define (tag x) (attcah-tag 'rectangular x))
	(put 'real-part '(rectangular) real-part)			; 采用表以便允许某些带有多个参数
	(put 'imag-part '(rectangular) imag-part)			; 而且这些参数又并非是同一类型的操作
	(put 'magnitude '(rectangular) magnitude)
	(put 'angle '(rectangular) angle)
	(put 'make-from-real-imag 'rectangular (lambda (x y) (tag (make-from-real-imag x y))))
	(put 'make-from-magn-angl 'rectangular (lambda (r a) (tag (make-from-magn-angl r a))))
														
	'done)	
	
	
(define (install-polar-package)
	
	; internal procedures (same as previous procedures)
	(define (make-from-magn-angl r a)
		(cons r a))
	(define (magnitude z)
		(car z))
	(define (angle z)
		(cdr z))
	(define (make-from-real-imag x y)
		(cons (sqrt (+ (square x) (square y)))
			  (atan y x)))
	(define (real-part z)
		(* (magnitude z) (cos (angle z))))
	(define (imag-part z)
		(* (magnitude z) (sin (angle z))))
	
	; interface to the rest of the system
	(define (tag x) (attcah-tag 'polar x))
	(put 'real-part '(polar) real-part)			; 采用表以便允许某些带有多个参数
	(put 'imag-part '(polar) imag-part)			; 而且这些参数又并非是同一类型的操作
	(put 'magnitude '(polar) magnitude)
	(put 'angle '(polar) angle)
	(put 'make-from-real-imag 'polar (lambda (x y) (tag (make-from-real-imag x y))))
	(put 'make-from-magn-angl 'polar (lambda (r a) (tag (make-from-magn-angl r a))))
												
	'done)


(define (real-part z)
	(apply-generic 'real-part z))
	
(define (imag-part z)
	(apply-generic 'imag-part z))
	
(define (magnitude z)
	(apply-generic 'magnitude z))
	
(define (angle z)
	(apply-generic 'angle z))
	

(define (install-complex-package)
	
	; imported procedures from rectangular and polar packages
	
	(define (make-from-real-imag x y)
		((get 'make-from-real-imag 'rectangular) x y))
	(define (make-from-mag-ang r a)
		((get 'make-from-mag-ang 'polar) r a))
		
	; internal procedures
	
	(define (add-complex z1 z2)
		(make-from-real-imag (+ (real-part z1) (real-part z2))
							 (+ (imag-part z1) (imag-part z2))))
	(define (sub-complex z1 z2)
		(make-from-real-imag (- (real-part z1) (real-part z2))
							 (- (imag-part z1) (imag-part z2))))
	(define (mul-complex z1 z2)
		(make-from-mag-ang (* (magnitude z1) (magnitude z2))
						   (+ (angle z1) (angle z2))))
	(define (div-complex z1 z2)
		(make-from-mag-ang (/ (magnitude z1) (magnitude z2))
						   (- (angle z1) (angle z2))))
	(define (equ?-complex z1 z2)
		(and (= (real-part z1) (real-part z2))
			 (= (imag-part z1) (imag-part z2))))
	(define (=zero?-complex z)
		(and (= (real-part z) 0)
			 (= (imag-part z) 0)))
	
	; interface to the rest of the system
	
	(define (tag z) (attach-tag 'complex z))
	(put 'add '(complex complex)
		(lambda (z1 z2) (tag (add-complex z1 z2))))
	(put 'sub '(complex complex)
		(lambda (z1 z2) (tag (sub-complex z1 z2))))
	(put 'mul '(complex complex)
		(lambda (z1 z2) (tag (mul-complex z1 z2))))
	(put 'div '(complex complex)
		(lambda (z1 z2) (tag (div-complex z1 z2))))
	(put 'equ? '(complex complex) equ?-complex)
	(put '=zero? '(complex) =zero?-complex)
		
	(put 'make-from-real-imag 'complex
		(lambda (x y) (tag (make-from-real-imag x y))))
	(put 'make-from-mag-ang 'complex
		(lambda (r a) (tag (make-from-mag-ang r a))))
		
	(put 'real-part '(complex) real-part)
	(put 'imag-part '(complex) imag-part)
	(put 'magnitude '(complex) magnitude)
	(put 'angle '(complex) angle)
		
	'done)
	
(define (make-from-real-imag x y)
	((get 'make-from-real-imag 'complex) x y))
(define (make-from-mag-ang r a)
	((get 'make-from-mag-ang 'complex) r a))
	
						   
						   
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
