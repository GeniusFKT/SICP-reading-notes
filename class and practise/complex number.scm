
(define (add-complex z1 z2)
	(make-from-real-imag (+ (real-part z1) (real-part z2))
						 (+ (imag-part z1) (imag-part z2))))
	
(define (sub-complex z1 z2)
	(make-from-real-imag (- (real-part z1) (real-part z2))
						 (- (imag-part z1) (imag-part z2))))
						
(define (mul-complex z1 z2)
	(make-from-magn-angl (* (magnitude z1) (magnitude z2))
						 (+ (angle z1) (angle z2))))
	
(define (div-complex z1 z2)
	(make-from-magn-angl (/ (magnitude z1) (magnitude z2))
						 (- (angle z1) (angle z2))))
						 
; constructer and selectors in real-imag

(define (make-from-real-imag x y)
	(cons x y))

(define (real-part z)
	(car z))

(define (imag-part z)
	(cdr z))
	
(define (make-from-magn-angl r a)
	(cons (* r (cos a)) (* r (sin a))))
	
(define (square x)
	(* x x))
	
(define (magnitude z)
	(sqrt (+ (square (real-part z)) (square (imag-part z)))))
	
(define (angle z)
	(atan (imag-part z) (real-part z)))

; 反正切函数atan接收两个参数y,x返回正切是y/x的角度，参数的符号取决于角度所在的象限

; constructer and selectors in magn-angl

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


;;;;;;;;;;;;;;;;;;;;;;;;;
	
(define (attcah-tag type-tag contents)
	(cons type-tag contents))
	
(define (type-tag datum)
	(if (pair? datum)
		(car datum)
		(error "Bad tagged datum -- TYPE-TAG" datum)))
		
(define (contents datum)
	(if (pair? datum)
		(cdr datum)
		(error "Bad tagged datum -- CONTENTS" datum)))
		
(define (rectangular? z)
	(eq? (type-tag z) 'rectangular))
	
(define (polar? z)
	(eq? (type-tag z) 'polar))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;improved version with tag

	
(define (make-from-real-imag-rectangular x y)
	(attcah-tag 'rectangular (cons x y)))

(define (real-part-rectangular z)
	(car z))

(define (imag-part-rectangular z)
	(cdr z))
	
(define (make-from-magn-angl-rectangular r a)
	(attcah-tag 'rectangular (cons (* r (cos a)) (* r (sin a)))))
	
(define (magnitude-rectangular z)
	(sqrt (+ (square (real-part-rectangular z)) (square (imag-part-rectangular z)))))
	
(define (angle-rectangular z)
	(atan (imag-part-rectangular z) (real-part-rectangular z)))

; constructer and selectors in magn-angl

(define (make-from-magn-angl-polar r a)
	(attcah-tag 'polar (cons r a)))
	
(define (magnitude-polar z)
	(car z))
	
(define (angle-polar z)
	(cdr z))
	
(define (make-from-real-imag-polar x y)
	(attcah-tag 'polar (cons (sqrt (+ (square x) (square y)))
							 (atan y x))))
		  
(define (real-part-polar z)
	(* (magnitude-polar z) (cos (angle-polar z))))
	
(define (imag-part-polar z)
	(* (magnitude-polar z) (sin (angle-polar z))))

; generic selectors
	
(define (real-part z)
	(cond ((rectangular? z)
		   (real-part-rectangular (contents z)))
		  ((polar? z)
		   (real-part-polar (contents z)))
		  (else (error "Unknown type -- REAL-PART" z))))
		  
(define (imag-part z)
	(cond ((rectangular? z)
		   (imag-part-rectangular (contents z)))
		  ((polar? z)
		   (imag-part-polar (contents z)))
		  (else (error "Unknown type -- IMAG-PART" z))))		
	
(define (magnitude z)
	(cond ((rectangular? z)
		   (magnitude-rectangular (contents z)))
		  ((polar? z)
		   (magnitude-polar (contents z)))
		  (else (error "Unknown type -- MAGNITUDE" z))))
	
(define (angle z)
	(cond ((rectangular? z)
		   (angl-rectangular (contents z)))
		  ((polar? z)
		   (angl-polar (contents z)))
		  (else (error "Unknown type -- ANGLE" z))))
		  
(define (make-from-real-imag x y)
	(make-from-real-imag-rectangular x y))
	
(define (make-from-magn-angl r a)
	(make-from-magn-angl-polar r a))
	
; rectangular package

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
														; 构造函数不用表因为每个构造函数总是
	'done)												; 只用于做出某个特定类型的对象
	
	; put(<op> <type> <item>) 将项item加入表格中，以op和type作为这个表的索引
	
; polar package
	
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
												; 构造函数不用表因为每个构造函数总是
	'done)
	
; 访问有关表格，将通用型操作应用于一些参数
; apply-generic在表格中用操作名和参数类型查找，如果找到，就去应用查找中得到的过程

(define (apply-generic op . args)							; op为用户想要的操作的名字，args为带标签的变量
	(let ((type-tags (map type-tag args)))					; 令type-tags是所有参数类型组成的表
		 (let ((proc (get op type-tags)))					; 让proc为op和type-tags所对应的过程（如无返回#f）
			  (if proc
				  (apply proc (map contents args))			; 若该过程存在则将其应用在args的内容上
				  (error
					"No method for these types -- APPLY-GENERIC"
					(list op type-tags))))))
	
; (get <op> <type>) : 在表中查找op与type的对应项，如果找到就返回找到的项，否则就返回假
; 基本过程apply，这一过程需要两个参数，一个过程和一个表。apply将应用这一过程，用表的元
; 素作为其参数。例如(apply + (list 1 2 3 4))的结果是10

; 可以利用apply-generic定义各种通用性选择函数

(define (real-part z)
	(apply-generic 'real-part z))
	
(define (imag-part z)
	(apply-generic 'imag-part z))
	
(define (magnitude z)
	(apply-generic 'magnitude z))
	
(define (angle z)
	(apply-generic 'angle z))
	
; 也同样可以提取出两个特殊的构造函数

(define (make-from-real-imag x y)
	((get 'make-from-real-imag 'rectangular) x y))
	
(define (make-from-magn-angl r a)
	((get 'make-from-magn-angl 'polar) r a))
	
	
	
	
	
	
	
	
	
	

							
							