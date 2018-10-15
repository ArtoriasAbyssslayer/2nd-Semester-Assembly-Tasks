	.globl	v
	.data
	.align	2
v:
	.word	3
	.word	10
	.word	8
	.word	2
	.word	7
	.word	1
	.word	5
	.word	9
	.word	6
	.word	4

array_a:.space  1000            # 250 integers

strSize:.asciiz "Enter array size (maximum 250)"

strInp: .asciiz "Enter next number (element "
               
strPower: .asciiz " * 2^(32) + "

strHex: .asciiz "0x"
        
	.text
swap:
	# <<YOUR-CODE-HERE>>
	j	$ra
	nop


partition:
	addiu	$sp,$sp,-48
	sw	$ra,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	sw	$a1,52($fp)
	lw	$v1,52($fp)
	li	$v0,1073676288			# 0x3fff0000
	ori	$v0,$v0,0xffff
	addu	$v0,$v1,$v0
	sll	$v0,$v0,2
	lw	$v1,48($fp)
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	sw	$v0,36($fp)
	sw	$0,28($fp)
	sw	$0,32($fp)
	b	part_loop
	nop

part_for:
	lw	$v0,32($fp)
	sll	$v0,$v0,2
	lw	$v1,48($fp)
	addu	$v0,$v1,$v0
	lw	$v1,0($v0)
	lw	$v0,36($fp)
	slt	$v0,$v1,$v0
	beq	$v0,$0,part_noswap
	nop

	lw	$v0,28($fp)
	addiu	$v1,$v0,1
	sw	$v1,28($fp)
	lw	$a2,32($fp)
	move	$a1,$v0
	lw	$a0,48($fp)

	jal	swap

part_noswap:
	lw	$v0,32($fp)
	addiu	$v0,$v0,1
	sw	$v0,32($fp)
part_loop:
	lw	$v0,52($fp)
	addiu	$v1,$v0,-1
	lw	$v0,32($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$0,part_for
	nop

	lw	$v0,52($fp)
	addiu	$v0,$v0,-1
	move	$a2,$v0
	lw	$a1,28($fp)
	lw	$a0,48($fp)

	jal	swap

	lw	$v0,28($fp)
	move	$sp,$fp
	lw	$ra,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	j	$ra

        
qsort:
        # <<YOUR-CODE-HERE>>
	j	$ra

main:
	addiu	$sp,$sp,-40
	sw	$ra,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	## li	$v0,10			# 0xa


        # original values for *a and i
        la      $t1, array_a    # $s1 = *v
        li      $t0, 0          # $t0 = i

        # display line to input size
        la      $a0, strSize
        jal     printStringln
        
        # get array size
        addi    $v0, $0, 5      # user input
        syscall                   

        move    $s0, $v0        # s0 := n

initLoop:
        beq     $t0, $s0, initDone  # jump if loop finished

        # Display line for next element input
        la      $a0, strInp
        jal     printString

        move    $a0, $t0
        jal     printInteger

        li      $a0, 41         # ')'
        jal     printASCIIln
        
        # Get user input (element a[i])
        addi    $v0, $0, 5        
        syscall
        
        sw      $v0, ($t1)      # store input number in a[i]

        addi    $t1, $t1, 4     # move array pointer
        addi    $t0, $t0, 1     # increase i
        b       initLoop        # loop

initDone: 

        move    $v0, $s0
        
	sw	$v0,28($fp)
	lw	$a1,28($fp)
        
        la      $a0, array_a
        
        jal     printArray

        lw	$a1,28($fp)
        la      $a0, array_a
        
	jal	qsort

        la      $a0, array_a
        move    $a1, $s0
        jal     printArray
        
	move	$v0,$0
	move	$sp,$fp
	lw	$ra,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$ra


# printArray -- Function to print an array
#
# Inputs:
#       $a0:    Array pointer
#       $a1:    Array length
#
# Outputs:
#       (none)
#
printArray:
        # initialize i
        li     $t0, 0
        move   $t1, $a0

        # print [
        addi   $v0, $0, 11
        li     $a0, 91
        syscall

        # print space
        addi    $v0, $0, 11
        li      $a0, 32
        syscall



loopPrint:
        beq    $t0, $a1, loopEnd

        # print element a[i]
        li     $v0, 1
        lw     $a0, ($t1)
        syscall

        # print space
        addi   $v0, $0, 11
        li     $a0, 32
        syscall

        addi   $t1, $t1, 4
        addi   $t0, $t0, 1

        b      loopPrint


loopEnd:

        # print ]
        addi   $v0, $0, 11
        li     $a0, 93
        syscall

        move   $t0, $ra
        jal    printNewline
        move   $ra, $t0
        
        jr     $ra


# printNewline -- Print new line
#
# Inputs:
#       (none)
#       
# Outputs:
#       (none)
#       
printNewline:

        # print new line
        addi    $v0, $0, 11     # ASCII character print
        li      $a0, 10         # ASCII character new line
        syscall

        jr      $ra


# printString -- Print input string to console
#
# Inputs:
#       $a0:    Memory address of string
#
# Outputs:
#       (none)
#       
printString:

        # print input string
        addi    $v0, $0, 4
        syscall

        jr      $ra

# printStringln -- Print input string to console, followed by
#  new line
#
# Inputs:
#       $a0:    Memory address of string
#
# Outputs:
#       (none)
#       
printStringln:

        # print input string
        addi    $v0, $0, 4
        syscall
        
        # print new line
        addi    $v0, $0, 11     # ASCII character print
        li      $a0, 10         # ASCII character new line
        syscall

        jr      $ra

# printInteger -- Print input integer to console
#
# Inputs:
#       $a0:    Integer value
#
# Outputs:
#       (none)
#       
printInteger:

        # print integer
        addi    $v0, $0, 1
        syscall

        jr      $ra

        
# printIntegerln -- Print input integer to console, followed
#  by new line
#
# Inputs:
#       $a0:    Integer value
#
# Outputs:
#       (none)
#       
printIntegerln:

        # print integer
        addi    $v0, $0, 1
        syscall

        # print new line
        addi    $v0, $0, 11     # ASCII character print
        li      $a0, 10         # ASCII character new line
        syscall

        jr      $ra

# printASCII -- Print input ASCII character to console
#
# Inputs:
#       $a0:    ASCII character to print
#
# Outputs:
#       (none)
#       
printASCII:

        # print ASCII
        addi    $v0, $0, 11
        syscall

        jr      $ra

# printASCIIln -- Print input ASCII character to console, followed
#  by new line
#
# Inputs:
#       $a0:    ASCII character to print
#
# Outputs:
#       (none)
#       
printASCIIln:

        # print ASCII
        addi    $v0, $0, 11
        syscall

        # print new line
        addi    $v0, $0, 11     # ASCII character print
        li      $a0, 10         # ASCII character new line
        syscall

        jr      $ra
