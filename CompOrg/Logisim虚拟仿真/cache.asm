#######################################################################
#file: cache.asm
#######################################################################
#本程序通过MARS数据cache仿真器插件和内存访问可视化插件帮助
#理解Cache参数对cache性能的影响
#本汇编程序的功能可以参考以下c语言伪代码:
# int array[];                      //整型数据位宽为4Byte
# for (k=0; k<repcount; k++) 
# {     // repcount:总循环次数?
# 访问数组元素,具体访问哪些数组元素取决于步长stepsize.
#       for (index=0; index<arraysize; index+=stepsize)
#       {
#           if(option== 0 )
#               array[index]=0;               //option 0: 涉及1次主存写
#           else
#               array[index]=array[index]+1;  //option 1:涉及主存读后写?
#        }
#  }
#######################################################################
#以下为MIPS汇编程序代码
#######################################################################
        .data
array:  .space 2048                   # array数组最大字节空间,请勿修改
        .text                         # 代码段开始
#######################################################################
#以下数值参数用户可以自行调整
main:      li $a0,256                 # 数组实际字节大小(应是2的幂次方并小于等于2048)
           li $a1,2                   # step size(数组索引变化步长，应是2的幂次方)
           li $a2,20                  # repcount（外循环次数，大于0）
           li $a3,1                  # 访存方式：0-option 0, 1-option 1
#######################################################################
           jal accessWords            # lw/ sw
         #jal  accessBytes            # lb/sb
           li $v0,10                  # exit
           syscall
#代码中寄存器使用说明:
#$a0 = arraySize  数组实际字节大小
#$al = stepSize   数组索引变化步长
#$a2 = number of times to repeat 数组循环访问次数
#$a3 = 0(w)/1(Rw)访存方式 
#$s0 = moving array ptr  数组滑动指针
#$sl = array limit (ptr) 数组访问上界指针

accessWords:
           la   $s0, array            # ptr to array：数组首地址（指针）赋值给$s0
           addu $s1, $s0, $a0         # hardcode array limit (ptr)：求和计算数组上限指针
           sll  $t1, $a1, 2           # multiply stepsize by 4 because WORDS:将子地址转换为字节地址
wordLoop:
           beq $a3, $0, wordZero      # 判断主存访问方式
           lw  $t0, 0($s0)            # 数组首地址元素赋值给$t0
           addi $t0, $t0, 1           # array[index]++
           sw  $t0, 0($s0)            # 增1后的值写回数组
           j wordCheck                # 判断是否越界或者循环结束
wordZero:
           sw $0, 0($s0)              # array[index]=0
wordCheck:
           addu $s0, $s0, $t1         # increment ptr：stepSize*4+array  $t1=stepSize*4
           blt  $s0, $s1, wordLoop    # inner loop done?
           addi $a2, $a2, -1          # 循环次数减1
           bgtz $a2, accessWords      # outer loop done?
           jr $ra

accessBytes:
           la   $s0, array            # ptr to array：数组首地址（指针）赋值给$s0
           addu $s1, $s0, $a0         # hardcode array limit (ptr)：求和计算数组上限指针
byteLoop:
           beq  $a3, $0, byteZero     # 判断主存访问方式
           lbu  $t0, 0($s0)           # 数组首地址元素赋值给$t0
           addi $t0, $t0, 1           # arrayLindex]++
           sb   $t0, 0($s0)           # 增1后的值写回数组
           j byteCheck                # 判断是否越界或者循环结束
byteZero:
           sb  $0, 0($s0)             # array[index]= 0
byteCheck :
           addu $s0, $s0, $a1         # increment ptr：stepSize+array  $a1=stepSize
           blt  $s0, $s1, byteLoop    # inner loop done?
           addi $a2, $a2, -1          # 循环次数减1
           bgtz $a2, accessBytes      # outer loop done?
           jr $ra
