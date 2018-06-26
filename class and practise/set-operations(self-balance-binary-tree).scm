; 二叉树表示集合

; 节点的数据项
(define (entry tree)
	(car tree))

; 左子树	
(define (left-branch tree)
	(cadr tree))
	
; 右子树
(define (right-branch tree)
	(caddr tree))
	
; ----------------------选择函数
; ------------------------------

; 构造二叉树	
(define (make-tree entry left right)
	(list entry left right))
	
; ----------------------构造函数
; ------------------------------

; 查找x是否在set中
(define (element-of-set? x set)
	(cond ((null? set) #f)
		  ((= x (entry set)) #t)
		  ((< x (entry set)) (element-of-set? x (left-branch set)))
		  ((> x (entry set)) (element-of-set? x (right-branch set)))))

; 将x加入set中		  
(define (adjoin-set x set)
	(cond ((null? set) (make-tree x '() '()))
		  ((= x (entry set)) set)
		  ((< x (entry set)) (make-tree (entry set) (adjoin-set x (left-branch set)) (right-branch set)))
		  ((> x (entry set)) (make-tree (entry set) (left-branch set) (adjoin-set x (right-branch set))))))

; 将平衡二叉树树转换成表		  
(define (tree->list tree)
	(define (copy-to-list tree result-list)
		(if (null? tree) 
			result-list
			(copy-to-list (left-branch tree)
						  (cons (entry tree)
							    (copy-to-list (right-branch tree) result-list)))))
	(copy-to-list tree '()))

; 将表转换成平衡二叉树	
(define (list->tree elements)
	(car (partial-tree elements (length elements))))

	
; partial-tree以整数n和一个至少包含n个元素构成的表为参数
; 构造出一棵包含这个表的前n个元素的平衡树
; 由partial-tree返回的结果是一个序对（用cons构造）,其car是构造出的树，其cdr是没有包含在树中那些元素的表
(define (partial-tree elts n)
	(if (= n 0)															; 如果n为0
		(cons '() elts)													; 返回空表及其余元素组成的表
		(let ((left-size (quotient (- n 1) 2)))							; 否则让左子树的大小为(n-1)/2
			 (let ((left-result (partial-tree elts left-size)))			; 左结果为左半边的平衡二叉树与剩余的元素
				  (let ((left-tree (car left-result))					; 让左树为左结果的平衡二叉树
					    (non-left-elts (cdr left-result))				; 让不是左边的元素为左结果剩余的元素
					    (right-size (- n (+ left-size 1))))				; 让右子树大小为(n - (1 + left-size))
					   (let ((this-entry (car non-left-elts))						; 让本棵树的储存数据为剩余元素的首个
						     (right-result (partial-tree (cdr non-left-elts)		; 右结果为剩余元素余下的表组成平衡二叉树
													     right-size)))				; 及剩余的元素
						    (let ((right-tree (car right-result))					; 让右树为右结果中的平衡二叉树
							      (remaining-elts (cdr right-result)))				; 剩余的东西为右结果的右部
							     (cons (make-tree this-entry left-tree right-tree)  ; 将前述的东西都组合起来
								       remaining-elts))))))))
				
(define (union-set tree1 tree2) 
	(list->tree (union-set-list (tree->list tree1) 
								(tree->list tree2)))) 
  
(define (intersection-set tree1 tree2) 
	(list->tree (intersection-set-list (tree->list tree1) 
									   (tree->list tree2))))   
; 其中所用的函数为有序表交并集的函数	

(define (intersection-set-list set1 set2)
	(cond ((or (null? set1) (null? set2)) '())
		  ((> (car set1) (car set2)) (intersection-set-list set1 (cdr set2)))
		  ((< (car set1) (car set2)) (intersection-set-list (cdr set1) set2))
		  (else (cons (car set1) (intersection-set-list (cdr set1) (cdr set2))))))
	
(define (union-set-list set1 set2)
	(cond ((null? set1) set2)
		  ((null? set2) set1)
		  ((> (car set1) (car set2)) (cons (car set2) (union-set-list set1 (cdr set2))))
		  ((< (car set1) (car set2)) (cons (car set1) (union-set-list (cdr set1) set2)))
		  (else (cons (car set1) (union-set-list (cdr set1) (cdr set2))))))
	
	
	
	
	