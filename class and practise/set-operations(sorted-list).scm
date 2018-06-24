; 对已排序的集合的操作

; 判断x是否在set内
(define (element-of-set? x set)
	(cond ((null? set) #f)
		  ((= x (car set)) #t)
		  ((< x (car set)) #f)
		  (else (element-of-set? x (cdr set)))))
		  
; 交集
(define (intersection-set set1 set2)
	(cond ((or (null? set1) (null? set2)) '())
		  ((> (car set1) (car set2)) (intersection-set set1 (cdr set2)))
		  ((< (car set1) (car set2)) (intersection-set (cdr set1) set2))
		  (else (cons (car set1) (intersection-set (cdr set1) (cdr set2))))))
; 将x加入set中		  
(define (adjoin-set x set)
	(if (null? set) 
		(list x)
		(cond ((> x (car set)) (cons (car set) (adjoin-set x (cdr set))))
			  ((< x (car set)) (cons x set))
			  (else set))))
		
; 并集		
(define (union-set set1 set2)
	(cond ((null? set1) set2)
		  ((null? set2) set1)
		  ((> (car set1) (car set2)) (cons (car set2) (union-set set1 (cdr set2))))
		  ((< (car set1) (car set2)) (cons (car set1) (union-set (cdr set1) set2)))
		  (else (cons (car set1) (union-set (cdr set1) (cdr set2))))))
		
		  