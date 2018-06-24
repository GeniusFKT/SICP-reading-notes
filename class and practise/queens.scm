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

(define (enum-interval low high)
	(if (> low high)
		(list)
		(cons low (enum-interval (+ low 1) high))))
		
(define (flatmap proc seq)
	(accumulate append (list) (map proc seq)))

	
; 八皇后问题 
; 按一个方向处理棋盘，每次在每一列里放一个皇后
; 如果现在已经放好了k-1个皇后，第k个皇后就必须放在不会被攻击的位置上
; 我们可以递归地描述这一过程：
; 假定我们已经生成了在棋盘的前k-1列中放置k-1个皇后的所有可能方式
; 现在需要的就是对于其中的每种方式
; 生成出将下一个皇后放在第k列中每一行的扩充集合，而后过滤它们

(define (queens boardsize)
	(define (queen-cols k)
		(if (= k 0)												; 如果递归到第0列
			(list empty-board)									; 返回一个空的格局
			(filter (lambda (positions) (safe? k positions))	; 对新加入的格局进行安全性的筛选
					(flatmap 									; 将所有新的格局联结成一个表，操作为以下四行，参数为前k-1个格局（第五行）
						(lambda (rest-of-queens)				; 将所有格局内每一个格局，与1至k的新的行组合，再进行上面的筛选
								(map (lambda (new-row)
											 (adjoin-position new-row k rest-of-queens))
									 (enum-interval 1 boardsize)))
						(queen-cols (- k 1))))))
	(queen-cols boardsize))

; rest-of-queens：在前k-1列中放置k-1个皇后的一种方式
; new-row：在第k列放置所考虑的行编号
; adjoin-position：将一个新的行列格局加入一个格局集合
; empty-board：表示空的格局集合
; safe?：确定新放置的皇后是否安全

(define empty-board '())

(define (last-of-list seq)
	(if (null? (cdr seq)) (car seq)
						  (last-of-list (cdr seq))))
						 
(define (safe? k positions)
	(let ((last (last-of-list positions)))
		 (cond ((= 1 (length positions)) #t)
			   ((or (= (cadar positions) (cadr last))
				    (= (abs (- (caar positions) (car last))) 
				   	   (abs (- (cadar positions) (cadr last)))))
				 #f)
			   (else (safe? k (cdr positions))))))
			 
(define (adjoin-position new-row k rest-of-queens)
	(append rest-of-queens (list (list k new-row))))
	




