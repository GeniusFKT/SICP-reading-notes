(define (make-mobile left right)
	(list left right))
	
(define (left-branch mobile)
	(car mobile))
	
(define (right-branch mobile)
	(cadr mobile))
	
(define (make-branch length structure)
	(list length structure))

(define (branch-length branch)
	(car branch))
	
(define (branch-structure branch)
	(cadr branch))
	
(define (total-weight mobile) 
    (cond ((null? mobile) 0) 
		  ((not (pair? mobile)) mobile) 
          (else (+ (total-weight (branch-structure (left-branch mobile))) 
                   (total-weight (branch-structure (right-branch mobile))))))) 
				  
(define (balance? mobile)
	(cond ((not (pair? mobile)) #t)
		  (else (and (balance? (branch-structure (left-branch mobile)))
					 (balance? (branch-structure (right-branch mobile)))
					 (= (* (branch-length (left-branch mobile)) 
					       (total-weight (branch-structure (left-branch mobile))))
						(* (branch-length (right-branch mobile)) 
					       (total-weight (branch-structure (right-branch mobile)))))))))
; above is defined by list
; the code next is defined by cons

(define (make-mobile left right)
	(cons left right))
	
(define (left-branch mobile)
	(car mobile))
	
(define (right-branch mobile)
	(cdr mobile))
	
(define (make-branch length structure)
	(cons length structure))

(define (branch-length branch)
	(car branch))
	
(define (branch-structure branch)
	(cdr branch))
	
(define (total-weight mobile) 
    (cond ((null? mobile) 0) 
		  ((not (pair? mobile)) mobile) 
          (else (+ (total-weight (branch-structure (left-branch mobile))) 
                   (total-weight (branch-structure (right-branch mobile))))))) 
				  
(define (balance? mobile)
	(cond ((not (pair? mobile)) #t)
		  (else (and (balance? (branch-structure (left-branch mobile)))
					 (balance? (branch-structure (right-branch mobile)))
					 (= (* (branch-length (left-branch mobile)) 
					       (total-weight (branch-structure (left-branch mobile))))
						(* (branch-length (right-branch mobile)) 
					       (total-weight (branch-structure (right-branch mobile)))))))))

; the last two functions are just as the same as the original version
; the change only happens in cadr to cdr
						   
						   
						   