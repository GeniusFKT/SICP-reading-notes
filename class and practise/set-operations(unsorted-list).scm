; 集合操作
; 集合内元素不重复
; 判断元素x是否在set内
(define (element-of-set? x set)
	(cond ((null? set) #f)
		  ((equal? (car set) x) #t)               ; 保证元素可以为表
		  (else (element-of-set? x (cdr set)))))

; 将x加入set内（如果没有的话）		  
(define (adjoin-set x set)
	(if (element-of-set? x set)
		set
		(cons x set)))

; 交集
(define (intersection-set set1 set2)
	(cond ((or (null? set1) (null? set2)) '())
		  ((element-of-set? (car set2) set1) 
		   (cons (car set2) (intersection-set set1 (cdr set2))))
		  (else (intersection-set set1 (cdr set2)))))
		  
; 并集
(define (union-set set1 set2)
	(cond ((null? set1) set2)
		  ((null? set2) set1)
		  ((element-of-set? (car set2) set1)
		   (union-set set1 (cdr set2)))
		  (else (cons (car set2) (union-set set1 (cdr set2))))))


		  
; 以下的过程处理集合内允许有重复的元素

(define (element-of-set? x set)
	(cond ((null? set) #f)
		  ((equal? (car set) x) #t)              
		  (else (element-of-set? x (cdr set)))))
	
(define (adjoin-set x set)
	(cons x set))

(define (union-set set1 set2)
	(append set1 set2))

; 出去set中所有为x的元素
(define (remove-x-from-set x set)
	(define (iter result set)
		(cond ((null? set) result)
			  ((equal? x (car set)) (iter result (cdr set)))
			  (else (iter (cons (car set) result) (cdr set)))))
	(iter '() set))

(define (intersection-set set1 set2)
	(cond ((or (null? set1) (null? set2)) '())
		  ((element-of-set? (car set2) set1)
		   (cons (car set2) (intersection-set (remove-x-from-set (car set2) set1) (cdr set2))))
		  (else (intersection-set set1 (cdr set2)))))
	
	
	
	
	
	