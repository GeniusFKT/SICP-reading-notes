(define (make-leaf symbol weight)
	(list 'leaf symbol weight))

(define (leaf? object)
	(eq? (car object) 'leaf))

(define (symbol-leaf x)
	(cadr x))

(define (weight-leaf x)
	(caddr x))
	
(define (make-code-tree left right)
	(list left
		  right
		  (append (symbol-tree left)
				  (symbol-tree right))
		  (+ (weight-tree left) (weight-tree right))))

(define (left-branch tree)
	(car tree))
	
(define (right-branch tree)
	(cadr tree))
	
(define (symbol-tree tree)
	(if (leaf? tree)
		(list (symbol-leaf tree))
		(caddr tree)))
	
(define (weight-tree tree)
	(if (leaf? tree)
		(weight-leaf tree)
		(cadddr tree)))

(define (choose-branch bit branch)
	(cond ((= bit 0) (left-branch branch))
		  ((= bit 1) (right-branch branch))
		  (else (error "bad bit -- CHOOSE-BRANCH" bit))))

; 解码		  
(define (decode bits tree)			; bits为0/1的表，tree为Huffman Tree
	(define (decode-1 bits current-branch)
		(if (null? bits)
			'()
			(let ((next-branch (choose-branch (car bits) current-branch)))
				 (if (leaf? next-branch)
					 (cons (symbol-leaf next-branch) 
						   (decode-1 (cdr bits) tree))
					 (decode-1 (cdr bits) next-branch)))))
	(decode-1 bits tree))
		
(define (adjoin-set x set)		; 按照权重将x加入set中
	(cond ((null? set) (list x))
		  ((< (weight-tree x) (weight-tree (car set))) (cons x set))
		  (else (cons (car set) (adjoin-set x (cdr set))))))

; 将对偶表变换为叶的有序集		  
(define (make-leaf-set pairs)	; 以一个符号-权重对偶的表为参数，构造出树叶的初始排序集合，以便Huffman算法去做归并
	(if (null? pairs)			; 如((A 4) (B 2) (C 1) (D 1))
		'()
		(let ((pair (car pairs)))
			 (adjoin-set (make-leaf (car pair)
									(cadr pair))
						 (make-leaf-set (cdr pairs))))))

; 判断x是否在set中
(define (element-of-set? x set)
	(cond ((null? set) #f)
		  ((equal? (car set) x) #t)               ; 保证元素可以为表
		  (else (element-of-set? x (cdr set)))))
					
; 编码单个字符					
(define (encode-symbol symbol tree)
	(cond ((leaf? tree) '())
		  ((element-of-set? symbol (symbol-tree (left-branch tree))) 
		   (cons 0 (encode-symbol symbol (left-branch tree))))
		  ((element-of-set? symbol (symbol-tree (right-branch tree))) 
		   (cons 1 (encode-symbol symbol (right-branch tree))))
		  (else (error "bad bit -- ENCODE-SYMBOL" symbol))))

; 编码整条信息		  
(define (encode message tree)
	(if (null? message)
		'()
		(append (encode-symbol (car message) tree)
				(encode (cdr message) tree))))

; 归并排序后的前两个元素
(define (merged-set set)
	(cons (make-code-tree (car set) (cadr set)) (cddr set)))

; 将归并后的表进行排序	
(define (sort set)
	(cond ((= 1 (length set)) set)
		  ((<= (weight-tree (car set)) (weight-tree (cadr set))) set)
		  (else (cons (cadr set) (sort (cons (car set) (cddr set)))))))

; 归并整个表		  
(define (successive-merge set)
	(cond ((= 1 (length set)) set)
		  ((= 2 (length set)) (make-code-tree (car set) (cadr set)))
		  (else (let ((sorted-set (sort set)))
					 (successive-merge (merged-set sorted-set))))))

; 生成Huffman Tree					 
(define (generate-huffman-tree pairs)		; pairs为符号-频度（权重）对偶表，生成一棵Huffman Tree
	(successive-merge (make-leaf-set pairs)))
		


		