(define (make-rat n d) 
	(let (g (gcd n d)))
	(cons (/ n g) (/ d g)))
;有理数类的构造函数，其中n，d为实数，g为化约用的最大公约数

(define (make-rat n d)
	(let ((g ((if (< d 0) - +) (abs (gcd n d)))))
		(cons (/ n g) (/ d g))))
;构造函数改进版，考虑了n与d取负值的情况，且考虑gcd算法的局限性，使化约后的有理数
;分子分母同正或只有分子为负
;分析：1.分子分母同正，与第一种算法相同
;	   2.分子正分母负，if取负号，g为负，生成分子为负，分母为正
;	   3.分子负分母正，if取正号，g为正，生成分子为负，分母为正
;	   4.分子负分母负，if取负号，g为负，生成分子为正，分母为正
;符合要求

(define (abs x)
	(if (< x 0) (- 0 x) x))
;绝对值函数

(define (gcd a b)
	(if (= b 0)
		a
		(gcd b (remainder a b))))
;构造函数中所用的最大公约数欧几里得算法，n、d为负数时，生成的gcd可能为负

(define (numer x) (car x))
(define (denom x) (cdr x))
;有理数类的选择函数，其中x为有理数类

(define (print-rat x)
	(newline)
	(display (numer x))
	(display "/")
	(display (denom x)))
;打印有理数

(define (add-rat x y)
	(make-rat (+ (* (numer x) (denom y))
				 (* (numer y) (denom x)))
			  (* (denom x) (denom y))))
;有理数类加法

(define (sub-rat x y)
	(make-rat (- (* (numer x) (denom y))
				 (* (numer y) (denom x)))
			  (* (denom x) (denom y))))			  
;有理数类减法	

(define (mul-rat x y)
	(make-rat (* (numer x) (numer y))
			  (* (denom x) (denom y))))
;有理数类乘法

(define (div-rat x y)
	(make-rat (* (numer x) (denom y))
			  (* (denom x) (numer y))))
;有理数类除法

(define (equal-rat? x y)
	(= (* (numer x) (denom y)) 
	   (* (numer y) (denom x))))
;判断相等






	