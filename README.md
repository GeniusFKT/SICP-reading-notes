# SICP-reading-notes

# 1 构造过程抽象
## 1.1 程序设计的基本元素

每种语言都提供了三种机制

* **基本表达形式** 用于表示语言所关心的最简单的个体
* **组合的方法** 通过它们可以从较简单的东西出发构造出复合的元素
* **抽象的方法** 通过它们可以对复合对象命名，并将它们当做单元去操作

程序设计中需要处理的两类要素：**过程和数据**（实际上并不是这样严格去分离的）

### 1.1.1 表达式
形式：**前缀表示**

表里最左的元素称为**运算符**，其他元素称为**运算对象**。

例如：

`（+ 137 349）`  
`486`

这样的表达式称为**组合式**

**美观打印**格式规则：其中的各个运算对象垂直对齐

### 1.1.2 命名和环境
给事物命名通过`define`的方式完成  

`(define <name> value or operation)`  
`(define pi 3.14159)`  
`(define radius 10)`  
`(define circumference (* 2 pi radius))`

我们可以将值与符号关联，意味着解释器必须维护某种储存能力，一边保持有关的名字-值对偶过程。这种储存被称为**环境**（更精确地说，是**全局环境**）

### 1.1.3 组合式的求值
* 要求值一个组合式，要做下面的事情
* 1） 求值该组合式的各个子表达式
* 2） 将作为最左子表达式（运算符）的值的那个过程运用于相应的实际参数，所谓实际参数也就是其他子表达式（运算对象）的值。

在性质上，这一求值过程是**递归**的，也就是说，它在自己的工作步骤中，包含着调用这个规则本身的需要。

* 环境所扮演的角色就是用于确定表达式中各个符号的意义

### 1.1.4 复合过程
**过程定义**：可以为复合操作提供名字，而后可以将这样的操作作为一个单元使用(过程体也可以是一系列的表达式)  

`(define (<name> <formal parameters>) <body>)`  
`(define (square x) (* x x))`

### 1.1.5 过程应用的代换模型
* 代换的作用只是帮助我们领会过程调用中的情况，实际中，解释器一般采用提供形式参数的局部环境的方式，产生“代换的效果”

**应用序与正则序**  
* **正则序求值：** “完全展开而后归约”的求值模型  
* **应用序求值：** “先求值参数而后应用”的方式  
* Lisp采用应用序求值

### 1.1.6 条件表达式和谓词
在Lisp里有针对分情况分析的特殊形式，称为`cond`，使用形式如下

`(cond (<p1> <e1>)`  
　　　`(<p2> <e2>)`  
　　　`...`  
　　　`(<pn> <en>))`

第一个表达式是一个**谓词**，也就是说，它的值被解释成真或者假（在Scheme里用常量`#t`和`#f`表示）
求值方式如下：首先求值谓词`<p1>`，如果它的值是`false`，那么就继续求值`<p2>`，以此类推，知道发现某个谓词的值为真为止。返回其对应的**序列表达式**`<e>`的值，若无法找到，`cond`的值就没有定义。

* 也可以把`cond`的最后的条件换成`else`
* 当分析的情况只有两种时，可以采用特殊形式`if`，如：

`(if <predicate> <consequent> <alternative>)`

* 解释器先判断`predicate`的真假，再进行后两者的选择与计算，而不是三者同时进行计算再判断
* `cond`子句的`<e>`部分可以是一个表达式的序列，而`if`中的`<consequent>`和`<alternative>`只能是单个表达式

### 1.1.7 实例：采用牛顿法求平方根

* 原理：如果对x的平方根有了一个猜测y，只需求出y和x/y的平均值，便可获得一个比y更好的猜测
* 代码实现：  

`(define (sqrt-iter guess x)`  
　　`(if (good-enough? guess x)`  
　　　　`guess`  
　　　　`(sqrt-iter (improve guess x)`  
　　　　　　　　　　`x)))`

`(define (improve guess x)`  
　　`(average guess (/ x guess))`  

`(define (average x y)`  
　　`(/ (+ x y) 2)`

`(define (good-enough? guess x)`  
　　`(< (abs(- square(guess) x) 0.001 ))`

* 上式使用误差为0.001的情形
 
`(define (sqrt x)`  
　　`(sqrt-iter 1.0 x))`

* 分析：该方法对于过大的数以及过小的数均会出现较大的偏差。对于一个较小的数，可能只操作了一次误差便已经在0.001内，精度不够；对于一个较大的数，由于机器的精度无法分辨两个较大数之间的细微差别，即`（improve guess x）`会卡在一个数上不改进（`(improve guess x) = guess`, 即`(/ x guess) = guess`），而判断不出差距小于0.001

### 1.1.8 过程作为黑箱抽象

**局部名**  
过程用户不必去关注的细节之一，就是在有关的过程里面的参数的名字，这是由实现者选用的。这一原则（过程的意义应该不依赖于其作者为形式参数所选择的名字）影响十分深远，如过程的形式参数名必须局部于有关的过程体。  

形式参数的具体名字是什么其实完全没有关系，这样的名字称为**约束变量**，因此我们说，一个过程的定义**约束** 了它的所有的形式参数。如果一个变量不是被约束的，我们称它为**自由**的。一个名字的定义被约束于的那一集表达式称为这个名字的**作用域**。

**内部定义与块结构**  
我们要允许一个过程里带有一些**内部定义**，使它们是局部于这一过程的。如在平方根问题中，可以写：  

 
`(define (sqrt x)`  
　　`(define (good-enough? guess x)`  
　　　　`(< (abs(- square(guess) x) 0.001 ))`  
　　`(define (improve guess x)`  
　　　　`(average guess (/ x guess))`  
　　`(define (sqrt-iter guess x)`  
　　　　`(if (good-enough? guess x)`  
　　　　　　`guess`  
　　　　　　`(sqrt-iter (improve guess x)`  
　　　　　　　　　　　　`x)))`  
　　`(sqrt-iter 1.0 x))`

这样嵌套的定义称为**块结构**，它是最简单的名字包装问题的一种正确解决方式，实际上，还有一种很好的想法，让x作为内部定义中的自由变量，这样**在外围的sqrt被调用时，x由实际参数得到自己的值**。这种方式称为**词法作用域**。

`(define (sqrt x)`  
　　`(define (good-enough? guess)`  
　　　　`(< (abs(- square(guess) x) 0.001 ))`  
　　`(define (improve guess)`  
　　　　`(average guess (/ x guess))`  
　　`(define (sqrt-iter guess)`  
　　　　`(if (good-enough? guess)`  
　　　　　　`guess`  
　　　　　　`(sqrt-iter (improve guess))))`  
　　`(sqrt-iter 1.0))`

* 词法作用域要求过程中的自由变量实际引用外围过程定义中所出现的约束，也就是说，应该在定义本过程的环境去寻找它们。
<<<<<<< HEAD

## 1.2 过程与它们所产生的计算
在这一节中，将考察一些由简单过程所产生的计算过程的“形状”，还将研究这些计算过程消耗的各种重要计算资源（时间和空间）的速率

### 1.2.1 线性的递归和迭代
考虑如下两种计算阶乘的过程：  
1  
`(define (factorial n)`  
　　`(if (= n 1)`  
　　　　`1`  
　　　　`(* n (factorial(- n 1)))))`

2  
`(define (factorial n)`  
　　`(fact-iter 1 1 n))`

`(define (fact-iter product counter max-count)`  
　　`(if (> counter max-count)`  
　　　　`product`  
　　　　`(fact-iter(* counter product)`  
　　　　　　　　　`(+ counter 1)`  
　　　　　　　　　`(max-count)))`

在第一个计算过程中，代换模型是一种先逐步展开而后收缩的形状，构造起一个**推迟进行的操作**所形成的链条，收缩阶段表现为这些运算的实际执行。这成为一个**递归计算过程**。  
在第二个计算过程中，没有任何的增长或收缩，这种过程为**迭代计算过程**。一般来说，迭代计算过程就是那种其状态可以用固定数目的**状态变量**来描述的计算过程。  

* **递归计算过程**与**递归过程**：二者为两个不同的概念，递归过程指的是一个语法形式上的事实，说明这个过程的定义中直接或间接地引用了该过程本身。而计算过程说的是其进展方式。某个递归过程（如fact-iter）将产生一个迭代的计算过程。  

* 对于递归过程的解释，所需要消耗的存储量总与过程调用的数目成正比，即使它所描述的计算过程从原理上来看是迭代的。

### 1.2.2 树形递归
考虑斐波那契数列的递归实现：

`(define (Fib n)`  
　　`(cond ((= n 0) 0)`  
　　　　　`((= n 1) 1)`  
　　　　　`(else (+ (Fib (- n 1))`  
　　　　　　　　　　`(Fib (- n 2))))))`

* 可以证明，Fib（n）是最接近φ^n/(sqrt(5))的整数，其中φ=(1+sqrt(5))/2
* 一般来说，树形递归计算过程中所需的**步骤数**将正比于树中的节点数，其**空间需求**正比于树的最大深度

斐波那契数列的线性迭代实现：

`(define (fib n)`  
　　`(define (fib-iter a b n)`  
　　　　`(if ((= n 0) a)`    
　　　　　　`(fib-iter b (+ a b) (- n 1)))`  
　　`(fib-iter 0 1 n))`

###换零钱方式的统计

给了50、25、10、5、1美分的硬币，给定任意数量的现金，计算出换零钱方式的总数：  
基本想法：总数=除第一种硬币外其他所有方式+扣掉第一种硬币的币值的所有总数

`(define (change-count amount)`  
　　`(cc amount 5))`

`(define (cc amount kind-of-coins)`  
　　`(cond ((= 0 amount) 1)`  
　　　　　`((or (< amount 0) (= kind-of-coins 0)) 0)`  
　　　　　`(else (+ (cc amount (- kind-of-coins 1))`  
　　　　　　　　　　`(cc (- amount (first-denomination kind-of-coins))`
　　　　　　　　　　　　　　　　　　　　　　　`kind-of-coins)))))`

`(define (first-denomination kind-of-coins)`  
　　`(cond ((= 1 kind-of-coins) 1)`  
　　　　　`((= 2 kind-of-coins) 5)`  
　　　　　`((= 3 kind-of-coins) 10)`  
　　　　　`((= 4 kind-of-coins) 25)`  
　　　　　`((= 5 kind-of-coins) 50)))`  

### 1.2.3 增长的阶
令n是一个参数，它能作为问题规模的一个度量，令R(n)是一个计算过程在处理规模为n的问题时所需要的资源量。在每个时刻只能执行固定数目的操作的计算机里，所需的时间将正比于需要执行的基本机器的指令条数。  

* 我们称R(n)具有θ(f(n))的增长阶，记为R(n)=θ(f(n))，如果存在与n无关的整数k1,k2,使得：k1f(n) \leq R(n) \leq k2f(n) 对足够大的n都成立。  

对于上述换零钱的递归，空间的阶为O(n)，时间的阶为O(n^5)。（k种零钱则为O(n^k)）  

证明：显然当所有换的币值为1时，树达到最深，故深度为n，空间的阶为O(n)。
对于时间而言，考虑以下几个步骤：  

* 1. (cc n 1) = O(n)（要执行左支路n/(first-denomination 1)次，为O(n)）
* 2. (cc n 2) = (+ (cc n 1) (cc (- n t) 2)) = (+ (cc n 1) (cc (- n t) 1) ... (cc (- n (* k t)) 1)) = O(n^2) （每个加号为O(n)，共n/t个加号，t为某币值，故为O(n^2)）
* 3. 以此类推，(cc n k) = O(n^k)

### 1.2.4 求幂
基本思路：要求b^n，只需考虑  

* 1. n为偶数，b^n = (b^(n/2))^2 
* 2. n为奇数，b^n = b*b^(n-1)

递归实现：  

`(define (fast-expt b n)`  
　　`(cond ((= n 0) 1)`  
　　　　　`((even? n) (square (fast-expt b (/ n 2))))`  
　　　　　`(else (* b (fast-expt b (- n 1))))))`

`(define (even? n)`  
　　`(= (remainder n 2) 0))`  

* remainder为求余数的固定语法 
* 该算法增长的阶为θ(log n)

迭代实现：

`(define (expt b n)`  
　　`(expt-iter b n a))`

`(define (expt-iter b n a)`  
　　`(cond ((= 0 n) a)`  
　　　　　`((even? n) (expt-iter (square b) (/ n 2) a))`  
　　　　　`(else (expt-iter b (- n 1) (* a b)))))`

* 一般来说，定义一个**不变量**，要求它在状态之间保持不变，这一技术是思考迭代算法设计问题时的强有力的方法。（如上述程序，a*b^n即为不变量）

### 习题1.19
存在着一种以对数步数求出斐波那契数的算法。前述算法的迭代过程使用了变换a+b→a和a→b，现将此称为T变换。斐波那契数可以通过将T^n应用于对偶(1,0)而产生出来。考虑变换族Tpq，满足：bq+aq+ap→a和bp+aq→b，p=0，q=1即为T变换，则将Tpq应用两次，效果等同于同样形式的一次变换Tp'q'，可计算得p'=p^2+q^2,q'=2pq+q^2，再像fast-iter那样，便只需对数的步数。

`(define (fib n)`  
　　`(fib-iter 1 0 0 1 n))`

`(define (fib-iter a b p q count)`  
　　`(cond ((= count 0) b)`  
　　　　　`((even? count)`  
 　　　　　`(fib-iter a`    
　　　　　　　　　　`b`  
　　　　　　　　　　`(+ (square p) (square q))`  
　　　　　　　　　　`(+ (* 2 p q) (square q)))`  
　　　　　`(else (fib-iter (+ (* b q) (* a q) (* a p))`  
　　　　　　　　　　　　　`(+ (* b p) (* a q))`  
　　　　　　　　　　　　　`p`  
　　　　　　　　　　　　　`q (- count 1)))))`


### 1.2.5 最大公约数
最大公约数（GCD,greatest common divisor）定义为能除尽这两个数的最大整数。
算法思想：如果r是a除以b的余数，那么a和b的公约数正好也是b和r的公约数（欧几里得算法）

`(define (gcd a b)`  
　　`(if (= b 0)`  
　　　　`a`  
　　　　`(gcd b (remainder a b))))`
  
其步骤依所涉及的数对数增长

* **Lame定理**：如果欧几里得算法需要用k步计算出一对整数的GCD，那么这对数中较小的那个数必然大于或等于第k个斐波那契数。
* 可于此估计欧几里得算法的阶数为θ(log n)

###1.2.6 实例：素数检测

下面的程序能找出给定数n的最小整数因子：

`(define (smallest-divisor n)`  
　　`(find-divisor n 2))`

`(define (find-divisor n test-divisor)`  
　　`(cond ((> (square test-divisor) n) n)`  
　　　　　`((divide? test-divisor n) test-divisor)`  
　　　　　`(else (find-divisor n (+ test-divisor 1)))))`

`(define (divide? a b)`  
　　`(= (remainder b a) 0))`

而n是素数当且仅当其是自己的最小因子：  

`(define (prime? n)`  
　　`(= (smallest-divisor n) n))`

由循环迭代的次数知，步数达到θ(sqrt n)阶

**费马检查**  

* **费马小定理**：如果n是一个素数，a是小于n的任意正整数，那么a的n次方与a模n同余。
* 如果n不是素数，一般而言，大部分的a<n将满足上面关系。因此随机取一个a<n，如果满足上述等式，通过越来越多的检查，便可不断加强对有关结果的信心。这一算法称为**费马检查**

为了实现费马检查，要有一个过程来计算一个数的幂对另一个数取模的结果：  

`(define (expmod base exp m)`  
　　`(cond ((= exp 0) 1)`  
　　　　　`((even? exp)`  
　　　　　`(remainder (square (expmod base (/ exp 2) m))`  
　　　　　　　　　　　`m)`  
　　　　　`(else`  
　　　　　`(remainder (* base (expmod base (- exp 1) m))`  
　　　　　　　　　　　`m))))`


* 如果用之前使用的`fast-expt`来进行计算，则需要处理较大的数据，造成程序运行的缓慢


随机数a的选取通过过程`random`完成：

`(define (fermat-test n)`  
　　`(define (try-it a)`  
　　　　`(= (expmod a n n) a))`  
　　`(try-it (+ 1 (random (- n 1)))))`

`(define (fast-prime? n times)`  
　　`(cond ((= time 0) true)`  
　　　　　`((fermat-test n) (fast-prime? n (- times 1)))`  
　　　　　`(else false)))`

**概率方法**  
之前的算法都能保证计算的结果一定正确，而费马检查得到的结果只有概率上的正确性。事实上，对于任何数n，如果执行这一检查的次数足够多，而且n通过了检查，那么就能使这一素数检查出错的概率减小到所需的任意程度。（可惜依然存在一些能够骗过费马检查的整数，称为carmichael数，其非常罕见）

* `runtime`基本过程：调用他将返回一个整数，表示系统已经运行的时间（例如，以微秒计）。


## 1.3 用高阶函数做抽象
经常有一些同样的程序设计模式能用于若干不同的过程，为了把这种模式描述为相应的概念，我们就需要构造出这样的过程，让他们以过程为参数，或者以过程作为返回值。这类能操作过程的过程称为**高阶过程**

### 1.3.1 过程作为参数
考虑以下三个过程：  

* 1.计算a到b的各整数之和  
`(define (sum-integers a b)`  
　　`(if (> a b)`  
　　　　`0`  
　　　　`(+ a (sum-integers (+ a 1) b))))`

* 2.计算给定范围内的整数的立方和  
`(define (sum-cubes a b)`  
　　`(if (> a b)`  
　　　　`0`  
　　　　`(+ (cube a) (sum-cubes (+ a 1) b))))`

* 3.计算下面序列之和：1/(1 * 3) + 1/(5 * 7) + 1/(9 * 11) ...，它将非常缓慢地收敛到π/8  
`(define (pi-sum a b)`  
　　`(if (> a b)`  
　　　　`0`  
　　　　`(+ (/ 1 (* a (+ a 2))) (pi-sum (+ a 4) b))))`

因此我们希望能用一个过程能够描述求和的概念，而不只是计算特定求和的过程。  

`(define (sum term a next b)`  
　　`(if (> a b)`  
　　　　`0`  
　　　　`(+ (term a) (sum term (next a) next b))))`

这里又增加了参数`term`和`next`，使用`sum`的方式和其他函数完全一样，例如：立方和函数也可以这样实现 

`(define (inc n) (+ n 1))`  
`(define (sum-cubes a b)`  
　　`(sum cube a inc b))`

对于`sum`也可以使用如下的迭代过程：

`(define (sum term a next b)`  
　　`(define (iter a result)`  
　　　　　　`(if (> a b) result`  
　　　　　　　　　　　　`(iter (next a) (+ result (term a)))`  
　　`(iter a 0))`

类似的，也可以构造连乘`product`过程：  

`(define (product term a next b)`  
　　`(if (> a b)`  
　　　　`1`  
　　　　`(* (term a) (product term (next a) next b))))`

甚至进而将`sum`与`product`进行统一，构造`accumulate`过程  

`(define (accumulate combiner null-value term a next b)`  
　　`(if (> a b)`  
　　　　`null-value`  
　　　　`(combiner (term a) (accumulate combiner null-value term (next a) next b))))`

###1.3.2 用`lambda`构造过程
利用上一节的`sum`函数时，有时必须需要构造出一些简单的函数以进行`term`的替换，使其作为高阶函数的参数，而使用`lambda`直接刻画这类描述，使其能够创建出所需要的过程

* 一般而言，`lambda`用与`define`同样的方式创建过程，除了不为有关过程提供名字之外
`(lambda (<formal-parameters>) <body>)`
* 仅有的不同之处，就是这种过程没有与环境中的任何名字相关联
* 像任何以过程为值的表达式一样，`lambda`表达式可用作组合式的运算符

**用`let`创建局部变量**  

`lambda`的另一个应用是创建局部变量。在一个过程里，除了使用那些已经约束为 过程的变量外，常常还需要另外一些局部变量。因此，语言里有一个专门的特殊形式称为`let`。

`let`表达式的一般形式是：  

`(let ((<var1> <exp1>)`  
　　　`(<var2> <exp2>)`  
　　　`...`  
　　　`(<varn> <expn>))`  
　　`<body>)`

`let`表达式的第一部分是个名字-表达式对偶的表，当`let`被求值时，这里的每个名字将被关联于对应的表达式的值。再将这些名字约束为局部变量的情况下求值`let`的体。这一做法正好使`let`表达式被解释为替代如下表达式的另一种语法形式：  

`((lambda (<var1> <var2> ... <varn>)`  
　　`<body>`  
　`<exp1>`  
　`<exp2>`  
　`...`  
　`<expn>)`

* `let`使人能够在尽可能接近其使用的地方建立局部变量约束
* 变量的值是在`let`之外计算的。在为局部变量提供值的表达式依赖于某些与局部变量同名的变量时，这一规定就起作用了

###1.3.3 过程作为一般性的方法
实例：找出函数的不动点  

数x称为函数f的不动点，如果x满足方程f(x)=x。对于某些函数，通过从某个初始猜测出发，反复的应用f，直到值的变化不大时，就可以找到它的一个不动点。根据这个思路，可以设计出一个过程`fixed-point`

`(define (fixed-point f first-guess)`  
　　`(define (close-enough? a b)`  
　　　　`(< (abs (- a b)) 0.000001))`  
　　`(define (try guess)`  
　　　　`(let ((next (f guess)))`  
　　　　　　`(cond ((close-enough? guess next) next)`  
　　　　　　　　`(else (display next)`  
　　　　　　　　　　　`(newline)`  
　　　　　　　　　　　`(try next)))))`  
　　`(try first-guess))`

但是这个方法有一点缺陷，对某些函数，这种不动点搜寻并不收敛。考虑计算某个数的平方根，即找到y使得y^2=x，变换为y=x/y，于是要做的就是找到x/y的不动点。利用上面的搜寻会使程序进入无限循环，在答案的两边反复震荡  
控制这类震荡的一种方法是不让有关的猜测变化太剧烈。我们可以做一个猜测，使之不像x/y那样原理y，为此可以用二者的平均值。可以取y的下一个猜测值为(1/2)(y+x/y)而不是(x/y)。容易验证，这种猜测序列计算过程和之前一种是一样的。  
这种取逼近一个解的一系列值的平均值的方法，是一种称为**平均阻尼**的技术，它常常用在不动点搜寻中，作为帮助收敛的手段。
