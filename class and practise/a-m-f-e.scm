(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence) (accumulate op initial (cdr sequence))))) 
		
; 累积器
		
(define (filter predicate sequence)
	(cond ((null? sequence) (list))
		  ((predicate (car sequence)) (cons (car sequence) (filter predicate (cdr sequence))))
		  (else (filter predicate (cdr sequence)))))
		  
; 过滤器，返回满足条件的按原顺序排列的表

; 映射用map过程实现

; 以下是两类枚举过程

(define (enum-interval low high)
	(if (> low high)
		(list)
		(cons low (enum-interval (+ low 1) high))))
; 枚举出区间内的所有整数（闭）

(define (enum-tree tree)
	(cond ((null? tree) (list))
		  ((not (pair? tree)) (list tree))  
		  ((= (length tree) 2) (append (enum-tree (car tree)) (enum-tree (cadr tree))))
		  (else (append (enum-tree (car tree)) (enum-tree (cdr tree))))))	

; 枚举出一棵树的所有树叶并列成一个表		  
; 等同于前述的fringe过程

(define (square x) (* x x))

(define (sum-odd-square-tree tree)
	(accumulate +									; 积累
				0									
				(map square							; 映射	
					 (filter odd?					; 过滤
							 (enum-tree tree)))))	; 枚举

(define (fib n)
	(define (iter i a b)
		(if (= i 0)
			a
			(iter (- i 1) b (+ a b))))
	(iter n 0 1))
							 
							 
(define (even-fibs n)
	(accumulate cons
				(list)
				(filter even? 
						(map fib					; 先映射再过滤（取偶的斐波那契数）
							 (enum-interval 0 n)))))

(define (flatmap proc seq)
	(accumulate append (list) (map proc seq)))


(define (unique-pairs n)
	(flatmap (lambda (x)  
		             (map (lambda (p) (list x p))   
			              (enum-interval 1 (- x 1))))
		     (enum-interval 1 n)))
;生成序对(i，j)，i > j

(define (unique-triples n)
	(flatmap (lambda (x)
					 (map (lambda (p) (cons x p))
						  (unique-pairs (- x 1))))
		     (enum-interval 1 n)))
;同上，生成序对(i, j, k), i > j > k
			 
(define (sum-equal-to-s s)
	(define (sum-equal? seq)
		(= s (+ (car seq) (cadr seq) (caddr seq))))
	(filter sum-equal? (unique-triples s)))
; 取得等于s的所有序对
		
		