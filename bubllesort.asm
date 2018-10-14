	.globl	v
	.data
	.globl instrCount
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


	.text
	#todo ελευθέρωσε στο τέλος εκει που τελειώνει η διαδικασία swap του καταχωρητές που χρησιμοποίησες
	#t1->temp, #t1->v[k] #t2 -> v[k+1]
swap:#η swap ειναι διαδικασία φύλλο αρα είναι ανεξάρτητη του υπόλοιπου προγράμματος
#a1

	addi $sp,$sp,-16

	sw    $t1,0($sp)    #t1 the register that has the k index (fixed)
	sw    $t2,4($sp)		 #t2 the register that takes the k+1 element (fixed)
	sw    $ra,6($sp)    #save ra
	sw    $t0,12($sp)   #t0 temporary

	sll   $t1,$a1,2     # now t0  has 4 times the value of the index i -- διευθύνσεις στον mips διαφέρουν κατα 4
	add   $t0,$a0,$t0   #temp takes the v[k] adrress

	 lw   $t1,(0)t0     #t1 takes the v[k]
addiu   $t1,$t1,4     #t1 has the adress of the next element
   sw   $t2,0(t1)     #t2 has the adress of the element before


partition:
	addiu	$sp,$sp,-48
	sw	$ra,44($sp)   // krata to ra
	sw	$fp,40($sp)   // κρατά τον fp στο 40 ($sp)
	move	$fp,$sp			// μετακινεί τον sp στον fp
	sw	$a0,48($fp)   // αποθηκεύει τον α
	sw	$a1,56($fp)   // η a1
	lw	$v1,56($fp)
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
addu  $v0,$v1,$v0
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
		addi $sp,$sp-20  #δημιουργία χώρου στην στοίβα για 5 καταχωρητές
		sw $ra,16($sp)	#αποθήκευση του $ra στην στοίβα
		sw $s3,12($sp)  #αποθήκευση του #s3 στην στοίβα
		sw $s2,6($sp)   #αποθήκευση του $s2 στην στοίβα
		sw $s1,4($sp)   #αποθήκευση του $s1 στην στοίβα
		sw $s0,2($sp)   #αποθήκευση του $s0 στην στοιβα
#--------------------------------------------------------------------------------------
							#main body of the procedure
		move $s2,$a0    #αντιγραφή της παραμέτρου $α0 στον $s2
		move $s3,$a1    #αντιγραδή της παραμέτρου $α1 στον $s3
		move $s0,$zero  #i=0
#EΞΩΤΕΡΙΚΟΣ ΒΡΟΧΟΣ
#--------------------------------------------------------------------------------------
  	forltst: slt  $t0,$s0,$a1 #καταχωρητής $t0 = 0 αν $s0 >= $a1 (i>=n)
  	beq  $t0,$s0,exit1 #μετάβαση στην exit1 an $s0>=$a1(i>=n)
  	addi $s1,$s0,-1  #j=i-1
#ΕΣΩΤΕΡΙΚΟΣ ΒΡΟΧΟΣ
#--------------------------------------------------------------------------------------
 		 for2tst:slti $t0,$s1,0
     bne  $t0,$zero,exit2
     sll  $t1,$s1,2
     add  $t2,$a0,$t1
     lw   $t3,0($t2)
     lw   $t4,4($t2)
     slt  $t0,$t4,$t3
     beq  $t0,$zero,exit2
#ΜΕΤΑΒΙΒΑΣΗ ΠΑΡΑΜΈΤΡΩΝ ΚΑΤΑ ΤΗΝ ΚΛΗΣΗ

     move  $a0,$s2
     move  $a1,$s1
     jal   swap

#Εσωτερικός βρόχος
     addi $s1,$s1,-1
     j    for2tst
exit2:  addi $s0,$s0,1     #i += 1
     j    for1tst


exit1:
     lw $s0,0($sp)
     lw $s1,4($sp)
     lw $s2,8($sp)
     lw $s3,12($sp)
    addi $sp,$sp,20
	    j	$ra

main:
			addiu	  $sp,$sp,-40
			sw    	$ra,36($sp)
			sw	    $fp,32($sp)
			move	  $fp,$sp
			li	    $v0,10			# 0xa
      move    $s0, $v0
			sw	    $v0,28($fp)
			lw	    $a1,28($fp)
      la      $a0, v

      jal     printArray

      lw	$a1,28($fp)
      la      $a0, v

jal	qsort

      la      $a0, v
      move    $a1, $s0
      jal     printArray

			move	$v0,$0
			move	$sp,$fp
			lw	$ra,36($sp)
			lw	$fp,32($sp)
			addiu	$sp,$sp,40
			j	$ra

------------------------------------------------------------------------------------------------------------------
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
