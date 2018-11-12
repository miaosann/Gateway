# Gateway
### 一、写作初衷

​由于前一段搭了一个内网的Linux服务器，可是当我想要安装一些镜像的时候才意识到根本没有网络，所以只好写一个shell脚本进行模拟常规的网关登陆，从而将内网服务器联网。同时在学习shell的时候发现网上的一些博客存在错误，于是乎这就是我想借这个小demo进行shell总结的初衷。

### 二、编写

​	在shell脚本的一开始我们要写入幻数（magic number）`#!/bin/sh`这是为什么呢？

> - #!/bin/sh是指此脚本使用/bin/sh来解释执行，#!是特殊的表示符，其后⾯跟的是解释此脚本的shell的路径；
> - 其实第⼀句的#!是对脚本的解释器程序路径，脚本的内容是由解释器解释的，我们可以用各种各样的解释
> - 器来写对应的脚本；
> - 比如说/bin/csh脚本，/bin/perl脚本，/bin/awk脚本，/bin/sed脚本，甚至/bin/echo等等；



### 三、运行

​	在运行时我们可以采用两种方式：

1. 使用命令：`sh + xxx.sh` 即可完成执行，此时不需要更改该文件的权限；
2. 使用`chmod +x xxx.sh` 命令先赋予该文件可执行权限，然后 `./xxx.sh` 执行；

### 四、变量

1. 创建变量

   脚本语言中的变量是赋值的时候创建的，创建好后加入集合set中。变量定义时不加`$`符号

   ```shell
   HELLO="hello world"   ##注意：等号两端都不可有空格！！
   ```

2. 查看与删除变量

   创建好上述变量后，该变量将保存在set中，可用`set|grep HELLO`命令进行查看，而若想删除该变量则可以使用`unset HELLO`；

3. 输出变量

   输出主要分以下几种方式：

   ```shell
   echo ${HELLO}
   echo $HELLO
   echo ${HELLO:0:5}  #第一个冒号后数字表示字符串串起点下标，第二个冒号后数字表示从起点开始的长度 
   echo ${HELLO:2}  #打印从第2字符个开始到最后
   echo ${HELLO::2}  #打印从第0个开始到第2个字符是
   ```

4. 一些特殊的符号

   - $$：显示PID；
   - $?：显示上一条命令的执行结果，返回结果只能是0~255间的整数，0为成功，1~255为相应的错误；可用`$?`来查看编写函数的返回值，如果超过255则会轮回；
   - $#：参数的个数；
   - $0：当前脚本的文件名；
   - $n：第n个参数，n从1开始；

5. 变量间的组合

   ```shell
   echo ${HELLO}${HELLO1}
   echo ${HELLO}"abcde"${HELLO1}
   ```

### 五、环境变量

- 设置环境变量量的三种方法： 

  1. 在文件` /etc/profile` 文件中增加变量，该变量将会对Linux下所有用户有效，并且是“永久的”；

     ```shell
     vi /etc/profile 
     export CLASSPATH=./JAVA_HOME/lib;$JAVA_HOME/jre/lib
     ```

     注：修改文件后要想马上生效还要运行 `# source /etc/profile` ，不然只能在下次重进此用户时生效；

  2. 在用户目录下的 `.bash_profile `文件中增加变量，改变量仅会对当前用户有效，并且是“永久的”；

     ```shell
     export CLASSPATH=./JAVA_HOME/lib; $JAVA_HOME/jre/lib
     ```

     注：修改文件后要想马上生效还要运行 `# source /home/guok/.bash_profile` ，不然只能在下次重进此用户时生效；

  3. 直接运行export命令定义变量，只对当前shell有效“临时的”；

     在shell的命令行下直接使用 `export 变量名=变量值`来定义变量，该变量只在当前的shell或其子shell 下是有效的，shell关闭了，变量也就失效了，再打开新shell时没有这个变量，需要使用的话还需要再重新定义。 

- 输出环境变量：

  - 既可以直接`echo 变量名`；

  - 又可以使用`env`命令进行查看全部环境变量(`env`是`set`的子集)；


### 六、各种条件判断、循环语句

1. foreach循环

   ```shell
   for i in 1 3 5 7 9 
   do
   echo $i
   done
   ```

2. for循环

   ```shell
   for((i=0;i<10;i++))
   do
   echo $i
   done
   ```

3. while循环

   ```shell
   while <condition>; do <stmts> done
   ```

4. until循环

   ```shell
   until <condition>; do <stmts> done
   ```

5. if - then - else

   ```shell
   if [ '$1' –lt '0' ]; then    
   	echo "Error: invalid grade" 
   elif [ '$1' –lt '60' ] ; then    
   	echo 'no pass' 
   elif [ '$1' –lt '70' ] ; then    
   	echo "pass" 
   elif [ '$1' –lt '80' ] ; then    
   	echo 'good' 
   elif [ '$1' –le '100' ] ; then    
   	echo 'excellent' 
   else    
   	echo'Error: invalid grade' 
   fi
   ```

6. case

   ```shell
   #!/bin/sh 
   echo –n "Do you want to continue this operation? [n]" 
   read yesno 
   case $yesno in 
   y | Y | Yes | yes)    
   	echo "system will continue this operation"    
   	;; 
   n | N | no | NO)    
   	echo "system will skip this operation"   
   	;; 
   *)    
   	echo "Incorrect input" exit 1    
   	;; 
   esac
   ```

### 七、shell连接校园网网关

- 该代码为Linux系统中代码复制到Windows中上传，所以文件格式为`doc`而不是`unix`所以在运行前需要将其进行转码操作。

  - 首先，`vi`查看其格式；
  - 若格式不符合标准，转变格式即可；

  ```
  vi Gateway  #打开vi后进行下述操作
  :set ff?  #可以看到doc或unix字样，如果doc格式需进行转码
  :set ff=unix  #把格式转为unxi后，存盘运行
  ```

- 运行结果如下图所示：

  ![photo](https://github.com/miaosann/Gateway/blob/master/img/operate.png)



