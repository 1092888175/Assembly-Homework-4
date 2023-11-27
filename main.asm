# 在Linux X86-64汇编中，系统调用由syscall指令调用
# 在%rax寄存器中存储系统调用编号
# 在%rdi，%rsi，%rdx寄存器分别存放移送给系统调用的第一、二、三个参数
# 系统调用的返回值存储在%rax寄存器中
# 在本次作业中使用到的系统调用表如下
#   %rax    System Call     %rdi            %rsi            %rdx
#   1       sys_write       unsigned int fd const char* buf size_t count
#   60      sys_exit        int error_code

# X86-64 Linux 中各寄存器的保存要求
# Caller Save：%rax %rcx %rdx %rsp %rsi %rdi %r8 %r9 %r10 %r11
# Callee Save：%rbx %rbp %r12 %r13 %r14 %r15
.data
# 提示语
msg:    .ascii "WHAT IS THE DATE"
# 提示语长度
len:    .quad len-msg
.text
.globl _start
# 主函数入口
_start:
    # 将提示语的地址赋给rdi，提示语的长度赋给rsi，调用函数输出
    leaq msg,%rdi
    movq len,%rsi
    call _print_string
    # 输出换行
    movq $10,%rdi
    call _print_char
    # 输出响铃
    movq $7,%rdi
    call _print_char
    # 读入三个数组，按顺序压栈，栈顶是日期，下一个是月份，最后是年份
    call _get_num
    pushq %rax
    call _get_num
    pushq %rax
    call _get_num
    pushq %rax
    # 输出位于栈顶的日期
    movq (%rsp),%rdi
    call _print_num
    # 输出短横线
    movq $45,%rdi
    call _print_char
    # 输出位于栈底(相对栈顶偏移16)的年份
    movq 16(%rsp),%rdi
    call _print_num
    # 输出短横线
    movq $45,%rdi
    call _print_char
    # 输出栈第二个元素(相对栈顶偏移8)的月份
    movq 8(%rsp),%rdi
    call _print_num
    # 输出换行
    movq $10,%rdi
    call _print_char
.done:
    # 程序结束
    movq $60,%rax
    movq $0,%rdi
    syscall
