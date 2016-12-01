# Andrew Lehmann 1473136
.data
x: .word 1
y: .word 1
ARRAY1_SIZE: .word 1
ARRAY2_SIZE: .word 1
hold: .word 1
finalSum: .asciiz "\nThe final sum of the two arrays is: "
fillFirst: .asciiz "Please enter next number for first array: "
fillSecond: .asciiz "Please enter next number for the second array: "
firstFilled: .asciiz "First array filled! "
secondFilled: .asciiz "Second array filled! "
Array1: .asciiz "\nArray1: "
Array2: .asciiz "\nArray2: "
SPACE: .byte ' '
.text
.globl main
#------------------------------MAIN----------------------------------------------
main:

li $a0, 10
sw $a0, ARRAY1_SIZE		# array1size = 10
li $a0, 6
sw $a0, ARRAY2_SIZE		# array2size = 10


jal load_array
jal sort_array
jal print_array
jal add_elements

add $a1, $v0, $v1
li $v0, 4
la $a0, finalSum
syscall

move $a0, $a1
li $v0, 1
syscall


j exit

#----------------------------------LOAD ARRAY--------------------------------------
load_array:
#--------------------------Allocate first array[10]------------------------------------
li $v0, 9		# want to allocate some space
lw $a0, ARRAY1_SIZE	
mul $a0, $a0, 4
syscall			# Allocate space equal to 4*Array1_size
div $a0, $a0, 4		#set Array1_size back to original value
move $s0, $v0		#s0 = address for start of First Array
lw $s1, ARRAY1_SIZE	#s1 = ARRAY1_SIZE

#------------------------Allocate second array[6]-----------------------------
li $v0, 9		#Allocate Space
lw $a0, ARRAY2_SIZE
mul $a0, $a0, 4		
syscall			#allocate space equal to array2size * 4
div $a0, $a0, 4		#set arraysize back to normal
move $s3, $v0		#set beginning of array at s3
lw $s4, ARRAY2_SIZE	#s4 = array2_size

#-----------------------FILL FIRST ARRAY---------------------------------------
startFirstEntry:
bgt $t0, 9, endFirstEntry
mul $t1, $t0, 4		#store 4*i in t1
add $s2, $s0, $t1	#add 4*i to initial address

li $v0, 4
la $a0, fillFirst	#print fillFirst
syscall
li $v0, 5		#read in int
syscall
sw $v0, ($s2) 		#store user input in array[i]

addi $t0, $t0, 1
j startFirstEntry

endFirstEntry:
li $v0, 4		#print first is filled
la $a0, firstFilled
syscall
#-----------------FILL SECOND ARRAY-----------------------------------------
li $t1, 0
startSecondEntry:
bgt $t1, 5, endSecondEntry
mul $t2, $t1, 4		#store 4*j in t2
add $s5, $s3, $t2	#add 4*j to beginning of array

li $v0, 4
la $a0, fillSecond	#print fillSecond
syscall
li $v0, 5
syscall
sw $v0, ($s5)

addi $t1, $t1, 1
j startSecondEntry

endSecondEntry:
li $v0, 4		#print second is filled
la $a0, secondFilled
syscall
jr $ra
#----------------------SORT ARRAY-------------------------------------------
sort_array:
#----------------------Sort first array-------------------------------------
li $t0, 0
li $t1, 0
startFirstOutsideLoop:
bgt $t0, 8, endFirstOutsideLoop
li $t1, 0
	startFirstInsideLoop:
	bgt $t1, 8, endFirstInsideLoop	
	mul $t5, $t1, 4
	add $s2, $s0, $t5	#set pointer to s0 + 4i
	lw $t3, ($s2)		#save value x from s0 into t2
	lw $t4, 4($s2)		# t3 = s0 + y
	ble $t3, $t4, false1	#if array[j] > array[j+1] 
	sw $t4, ($s2)		#put t4 where t3 was
	sw $t3, 4($s2)		#put t3 where t4 was	
	afterFalse1:
	addi $t1, $t1, 1
	j startFirstInsideLoop
	endFirstInsideLoop:
addi $t0, $t0, 1
j startFirstOutsideLoop
endFirstOutsideLoop:
#--------------------Sort second array--------------------------------
li $t0, 0
li $t1, 0
startSecondOutsideLoop:
bgt $t0, 4, endSecondOutsideLoop
li $t1, 0
	startSecondInsideLoop:
	bgt $t1, 4, endSecondInsideLoop	
	mul $t5, $t1, 4
	add $s5, $s3, $t5	#set pointer to s0 + 4i
	lw $t3, ($s5)		#save value x from s0 into t2
	lw $t4, 4($s5)		# t3 = s0 + y
	ble $t3, $t4, false2	#if array[i] > array[i+1] 
	sw $t4, ($s5)		#put t3 where t2 was
	sw $t3, 4($s5)		#put t2 where t3 was
	afterFalse2:
	addi $t1, $t1, 1
	j startSecondInsideLoop
	endSecondInsideLoop:
addi $t0, $t0, 1
j startSecondOutsideLoop
endSecondOutsideLoop:
jr $ra
false1:
j afterFalse1
false2:
j afterFalse2

#------------------------------PRINT_ARRAY------------------------------------
print_array:
#------------------------------Print first array------------------------------

li $v0, 4
la $a0, Array1	#print Array 1: 
syscall

li $t0, 0
startPrint1:
bgt $t0, 9, print1Done	#print first array loop
mul $t1, $t0, 4
add $s2, $s0, $t1
lw $a0, ($s2)
li $v0, 1
syscall

li $v0, 4
la $a0, SPACE
syscall

addi $t0, $t0, 1
j startPrint1
print1Done:

#---------------------------print 2nd array-----------------------------------
li $v0, 4
la $a0, Array2
syscall

li $t0, 0
startPrint2:
bgt $t0, 5, print2Done
mul $t1, $t0, 4
add $s5, $s3, $t1
lw $a0, ($s5)
li $v0, 1
syscall

li $v0, 4
la $a0, SPACE
syscall

addi $t0, $t0, 1
j startPrint2
print2Done:
jr $ra

#------------------------ADD_ELEMENTS------------------------------------------
add_elements:
#-----------------------add elements first array------------------------------
li $t0, 0
startAddition1:
bgt $t0, 9, endAddition1
mul $t1, $t0, 4
add $s2, $s0, $t1
lw $a0, ($s2)
add $v0, $v0, $a0
addi $t0, $t0, 1
j startAddition1
endAddition1:

li $t0, 0
startAddition2:
bgt $t0, 5, endAddition2
mul $t1, $t0, 4
add $s5, $s3, $t1
lw $a0, ($s5)
add $v1, $v1, $a0
addi $t0, $t0, 1
j startAddition2
endAddition2:
jr $ra

#------------------------------EXIT--------------------------------------------
exit:

li $v0, 10
syscall
