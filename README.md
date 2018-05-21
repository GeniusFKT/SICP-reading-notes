# SICP-reading-notes

  ## 1 构造过程抽象
   ### 1.1 程序设计的基本元素

  每种语言都提供了三种机制
  * **基本表达形式** 用于表示语言所关心的最简单的个体
  * **组合的方法** 通过它们可以从较简单的东西出发构造出复合的元素
  * **抽象的方法** 通过它们可以对复合对象命名，并将它们当做单元去操作

  程序设计中需要处理的两类要素：**过程和数据**（实际上并不是这样严格去分离的）

#### 1.1.1 表达式
形式：**前缀表示**

表里最左的元素称为**运算符**，其他元素称为**运算对象**。

例如：
``（+ 137 349）
486``
这样的表达式称为**组合式**
