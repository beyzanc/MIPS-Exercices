	.data
MenuWelcome: .asciiz "Welcome to our MIPS project!\n"
MenuContent: .asciiz "Main Menu:\n1. Find Palindrome\n2. Reverse Vowels\n3. Find Distinct Prime\n4. Lucky Number\n5. Exit\n"
MenuOption: .asciiz "Please select an option: "
MenuInvalidInput: .asciiz "Invalid input! Please try again.\n"
MenuGoodBye: .asciiz "Program ends. Bye :)"
MenuNewLine: .asciiz "\n"

Q1LetterAmount: .word 0:26
Q1InputMsg: .asciiz "Input: "
Q1OutputMsg1: .asciiz "Output: The longest palindrome is "
Q1OutputMsg2: .asciiz ", and its length is "
Q1OutputMsg3: .asciiz "."
Q1UserString: .space 200
Q1Palindrome: .space 200

Q2InputMsg: .asciiz "Input: "
Q2OutputMsg: .asciiz "Output: "
Q2UserString: .space 200
Q2ReverseVowels: .space 200
Q2Vowels: .asciiz "aAeEiIoOuU"

Q3InputMsg: .asciiz "Enter an integer number: "
Q3OutputMsg1: .asciiz "Output: "
Q3OutputMsg2: .asciiz " is a square-free number and has "
Q3OutputMsg3: .asciiz " distinct prime factor: "
Q3OutputMsg4: .asciiz " is not a square-free number."
Q3OutputMsg5: .asciiz " distinct prime factors: "
Q3OutputMsg6: .asciiz " "

Q4RowPrompt: .asciiz "Enter the number of rows: "
Q4ColPrompt: .asciiz "Enter the number of columns: "
Q4NumPrompt: .asciiz "Enter the elements of the matrix: "
Q4NotUniquePrompt: .asciiz "The matrix should have only unique values."
Q4NoLuckyFoundMsg: .asciiz "There are no lucky numbers."
Q4LuckyFoundMsg: .asciiz "The lucky numbers are: "
Q4NumString: .space 200
Q4SpaceChar: .asciiz " "

	.text
	.globl main
main:
	li $v0, 4
	la $a0, MenuWelcome
	syscall
	
	# Main menu loop
MenuLoop:
	li $v0, 4
	la $a0, MenuContent
	syscall

	li $v0, 4
	la $a0, MenuOption
	syscall

	li $v0, 5
	syscall
	move $s0, $v0

	beq $s0, 1, MenuQ1
	beq $s0, 2, MenuQ2
	beq $s0, 3, MenuQ3
	beq $s0, 4, MenuQ4
	beq $s0, 5, MenuQuit

	li $v0, 4
	la $a0, MenuInvalidInput
	syscall

	li $v0, 4
	la $a0, MenuNewLine
	syscall

	j MenuLoop
MenuQ1:
	jal Q1
	j MenuLoop
MenuQ2:
	jal Q2
	j MenuLoop
MenuQ3:
	jal Q3
	j MenuLoop
MenuQ4:
	jal Q4
	j MenuLoop

Q1:
	# Save the registers
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)

	# Prompt the user to enter a string
	li $v0,4
	la $a0,Q1InputMsg
	syscall

	# Get the input
	li $v0,8
	la $a0,Q1UserString
	li $a1,199
	syscall

	la $s0,Q1UserString    # $s0 = User input
	li $s1,0               # $s1 = User input length
	la $s2,Q1LetterAmount  # $s2 = Letter amounts array

	# Find the length of the user input
	li $t0,10 # ASCII code of newline
	move $t1, $s0

Q1FindLength:
	lbu $t2, 0($t1)
	beq $t0, $t2, Q1EndFindLength
	addi $s1, $s1, 1
	addi $t1, $t1, 1
	j Q1FindLength
Q1EndFindLength:

	# Initialize the letter amounts array with all 0's
	li $t0,0
	li $t1,26
	move $t2,$s2

Q1InitializeLAA:
	beq $t0, $t1, Q1EndInitializeLAA
	sw $zero, 0($t2)
	addi $t0, $t0, 1
	addi $t2, $t2, 4
	j Q1InitializeLAA
Q1EndInitializeLAA:

	# Initialize the palindrome array with all 0's
	li $t0,0
	li $t1,200
	la $t2,Q1Palindrome

Q1InitializeP:
	beq $t0, $t1, Q1EndInitializeP
	sb $zero, 0($t2)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j Q1InitializeP
Q1EndInitializeP:

	# Count the letters in the user input and store them in the letter amounts array
	li $t0,0
	li $t2,65  # ASCII code of A
	li $t3,90  # ASCII code of Z
	li $t5,97  # ASCII code of a
	li $t6,122 # ASCII code of z

Q1CountLetters:
	beq $t0, $s1, Q1EndCountLetters

	move $t1,$s0
	add $t1, $t1, $t0
	lbu $t1, 0($t1)

	# If $t1 (character from the user string) is between 65 and 90, substract 65 from it. (It is an uppercase letter)
	# This gives us the index of the value we need to increment by 1, in the letter amounts array.
	blt $t1,$t2,Q1NotLetter
	bgt $t1,$t3,Q1NotUpperCase
	sub $t1, $t1, $t2
	sll $t1, $t1, 2
	add $t1, $t1, $s2
	lw $t4, 0($t1)
	addi $t4, $t4, 1
	sw $t4, 0($t1)
	addi $t0, $t0, 1
	j Q1CountLetters
Q1NotUpperCase:
	# If $t1 is between 97 and 122, substract 97 from it. (It is a lowercase letter)
	# This gives us the index of the value we need to increment by 1, in the letter amounts array.
	blt $t1,$t5,Q1NotLetter
	bgt $t1,$t6,Q1NotLetter
	sub $t1, $t1, $t5
	sll $t1, $t1, 2
	add $t1, $t1, $s2
	lw $t4, 0($t1)
	addi $t4, $t4, 1
	sw $t4, 0($t1)
Q1NotLetter:
	addi $t0, $t0, 1
	j Q1CountLetters
Q1EndCountLetters:

	# Traverse the letter amounts array and construct the first half of the longest palindrome
	la $s3,Q1Palindrome # $s3 = Our longest palindrome
	li $t0,0
	li $t1,26
	li $t2,0 # Index for placing the characters in palindrome string

Q1ConstructFirstHalf:
	beq $t0, $t1, Q1EndConstructFirstHalf

	sll $t3, $t0, 2
	add $t3, $t3, $s2
	lw $t3, 0($t3)

	srl $t3, $t3, 1

Q1ConstructFirstHalfInner:
	beq $t3, $zero, Q1EndConstructFirstHalfInner

	li $t4,97
	add $t4, $t4, $t0

	move $t5,$s3
	add $t5, $t5, $t2
	sb $t4, 0($t5)

	addi $t2, $t2, 1
	addi $t3, $t3, -1
	j Q1ConstructFirstHalfInner
Q1EndConstructFirstHalfInner:

	addi $t0, $t0, 1
	j Q1ConstructFirstHalf
Q1EndConstructFirstHalf:

	# Now, the first half of the palindrome is constructed. We need to reverse the first half and
	# insert it to the palindrome string.
	addi $t0, $t2, -1
	move $t1,$t2
	sll $s4, $t2, 1 # $s4 = Palindrome length

Q1ConstructSecondHalf:
	blt $t0,$zero,Q1EndConstructSecondHalf

	move $t2,$s3
	add $t2, $t2, $t0
	lbu $t2, 0($t2)

	move $t3,$s3
	add $t3, $t3, $t1
	sb $t2, 0($t3)

	addi $t0, $t0, -1
	addi $t1, $t1, 1
	j Q1ConstructSecondHalf
Q1EndConstructSecondHalf:

	# Print the output
	li $v0,4
	la $a0,Q1OutputMsg1
	syscall

	li $v0,4
	la $a0,Q1Palindrome
	syscall

	li $v0,4
	la $a0,Q1OutputMsg2
	syscall

	li $v0,1
	move $a0,$s4
	syscall

	li $v0,4
	la $a0,Q1OutputMsg3
	syscall

	li $v0,4
	la $a0,MenuNewLine
	syscall
	syscall

	# Restore the registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 20

	# Return
	jr $ra

Q2:
	# Save the registers
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)

	# Print the text asking for input
	li $v0,4
	la $a0,Q2InputMsg
	syscall

	# Get the user input as string
	li $v0,8
	la $a0,Q2UserString
	li $a1,199
	syscall

	move $s0, $a0 # $s0 = User input
	la $s2, Q2Vowels # $s2 = Array of vowels

	# Find the length of the user input
	li $s1, 0 # $s1 = Length of user input
	li $t0,10 # ASCII code of newline
	move $t1, $s0

Q2FindLength:
	lbu $t2, 0($t1)
	beq $t0, $t2, Q2EndFindLength
	addi $s1, $s1, 1
	addi $t1, $t1, 1
	j Q2FindLength
Q2EndFindLength:

	# Traverse the user input from end to start to find the reverse order of vowels
	la $s3,Q2ReverseVowels # $s3 = Array of vowels in the user input in reversed order
	move $t0,$s1
	li $t7,0

Q2FindReverseVowels:
	beq $t0, $zero, Q2EndFindReverseVowels
	move $t1,$s0
	add $t1, $t1, $t0
	addi $t1, $t1, -1
	lbu $t2, 0($t1)

	li $t3,0
	li $t4,10
Q2FindReverseVowelsInner:
	beq $t3, $t4, Q2EndFindReverseVowelsInner
	move $t5,$s2
	add $t5, $t5, $t3
	lbu $t6, 0($t5)
	beq $t6, $t2, Q2Match
	addi $t3, $t3, 1
	j Q2FindReverseVowelsInner
Q2Match:
	move $t6,$s3
	add $t6, $t6, $t7
	sb $t2, 0($t6)
	addi $t7, $t7, 1
Q2EndFindReverseVowelsInner:
	addi $t0, $t0, -1
	j Q2FindReverseVowels
Q2EndFindReverseVowels:

	# Reverse the order of vowels in the user input
	li $t0,0
	li $t1,0
Q2ReverseUserInput:
	beq $t0, $s1, Q2EndReverseUserInput
	move $t2,$s0
	add $t2, $t2, $t0
	lbu $t3, 0($t2)

	li $t4,0
	li $t5,10
Q2ReverseUserInputInner:
	beq $t4, $t5, Q2EndReverseUserInputInner
	move $t6,$s2
	add $t6, $t6, $t4
	lbu $t6, 0($t6)
	beq $t6, $t3, Q2Match2
	addi $t4, $t4, 1
	j Q2ReverseUserInputInner
Q2Match2:
	move $t6,$s3
	add $t6, $t6, $t1
	lbu $t6, 0($t6)
	sb $t6, 0($t2)
	addi $t1, $t1, 1
Q2EndReverseUserInputInner:
	addi $t0, $t0, 1
	j Q2ReverseUserInput
Q2EndReverseUserInput:

	# Print the reversed string
	li $v0,4
	la $a0,Q2OutputMsg
	syscall

	li $v0,4
	la $a0,Q2UserString
	syscall

	li $v0,4
	la $a0,MenuNewLine
	syscall

	# Restore the registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	
	# Return
	jr $ra

Q3:
	# Save the registers
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)

	# Print the input message
	li $v0,4
	la $a0,Q3InputMsg
	syscall

	# Get the user input
	li $v0,5
	syscall
	move $s0,$v0 # $s0 = User input

	# Save the registers
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)

	# If the input is a prime number, it is square-free.
	# Print the necessary outputs and finish execution if it is a prime number.
	move $a0,$s0
	jal Q3IsPrime

	# Restore the registers
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	beq $v0, $zero, Q3InputNotPrime

	li $v0,4
	la $a0,Q3OutputMsg1
	syscall

	li $v0,1
	move $a0,$s0
	syscall

	li $v0,4
	la $a0,Q3OutputMsg2
	syscall

	li $v0,1
	li $a0,1
	syscall

	li $v0,4
	la $a0,Q3OutputMsg3
	syscall

	li $v0,1
	move $a0,$s0
	syscall

	j Q3Return
Q3InputNotPrime:
	# Distinct prime factors are held in a linked list. The area for the first element
	# is allocated here.
	li $v0,9
	li $a0,8
	syscall

	move $s1,$v0   # $s1 = Address of the first element in the linked list
	move $s2,$v0   # $s2 = Address of the last element in the linked list
	li $s3,0       # $s3 = Number of distinct prime factors

	# This loop finds the distinct prime factors
	srl $t0, $s0, 1
	li $t1,2
Q3FindDPF:
	bgt $t1,$t0,Q3EndFindDPF

	move $a0,$t1
	# Save some of the tempary registers along with saved registers
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $a0, 8($sp)
	sw $ra, 12($sp)
	jal Q3IsPrime

	# Restore them
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $a0, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16

	beq $v0, $zero, Q3Continue

	div $s0, $t1
	mfhi $t2
	bne $t2, $zero, Q3Continue

	mul $t3,$t1,$t1
	bgt $t3,$s0,Q3DPFFound
	div $s0, $t3
	mfhi $t2
	beq $t2, $zero, Q3NotSquareFree
Q3DPFFound:
	sw $t1, 0($s2)

	li $v0,9
	li $a0,8
	syscall

	sw $v0, 4($s2)
	move $s2,$v0

	addi $s3, $s3, 1
Q3Continue:
	addi $t1, $t1, 1
	j Q3FindDPF
Q3EndFindDPF:

	# Print the output
	li $v0,4
	la $a0,Q3OutputMsg1
	syscall

	li $v0,1
	move $a0,$s0
	syscall

	li $v0,4
	la $a0,Q3OutputMsg2
	syscall

	li $v0,1
	move $a0,$s3
	syscall

	li $v0,4
	la $a0,Q3OutputMsg5
	syscall

	# Print the distinct prime factors
	li $t0,0
	move $t1,$s1

Q3PrintDPF:
	beq $t0, $s3, Q3Return
	lw $t2, 0($t1)

	li $v0,1
	move $a0,$t2
	syscall

	li $v0,4
	la $a0,Q3OutputMsg6
	syscall

	lw $t1, 4($t1)
	addi $t0, $t0, 1
	j Q3PrintDPF

Q3NotSquareFree:
	li $v0,4
	la $a0,Q3OutputMsg1
	syscall

	li $v0,1
	move $a0,$s0
	syscall

	li $v0,4
	la $a0,Q3OutputMsg4
	syscall
Q3Return:
	li $v0,4
	la $a0,MenuNewLine
	syscall

	li $v0,4
	la $a0,MenuNewLine
	syscall

	# Restore the registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16

	# Return
	jr $ra

# This method checks whether its argument is a prime number or not.
# If it is a prime number, it returns 1; otherwise returns 0.
Q3IsPrime:
	li $t0,2
	blt $a0,$t0,Q3NotPrime

	srl $t1, $a0, 1

Q3IsPrimeLoop:
	blt $t1,$t0,Q3EndIsPrimeLoop

	div $a0, $t1
	mfhi $t2
	beq $t2, $zero, Q3NotPrime
	addi $t1, $t1, -1
	j Q3IsPrimeLoop
Q3EndIsPrimeLoop:

	li $v0,1
	jr $ra
Q3NotPrime:
	li $v0,0
	jr $ra


Q4:
	# Save the registers
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)

	# Print the text asking for the number of rows
	li $v0,4
	la $a0,Q4RowPrompt
	syscall

	# Get the number of rows
	li $v0,5
	syscall
	move $s0,$v0 # $s0 = Number of rows

	# Print the text asking for the number of columns
	li $v0,4
	la $a0,Q4ColPrompt
	syscall

	# Get the number of columns
	li $v0,5
	syscall
	move $s1,$v0 # $s1 = Number of columns

	# Print the text asking for the elements
	li $v0,4
	la $a0,Q4NumPrompt
	syscall

	# Get the elements as string
	li $v0,8
	la $a0,Q4NumString
	li $a1,199
	syscall

	# Create an array for the integer versions of numbers
	mul $s3,$s0,$s1 # $s3 = Number of elements
	sll $t0, $s3, 2 # Bytes needed for the array

	li $v0,9
	move $a0,$t0
	syscall
	move $s2,$v0 # $s2 = Address of elements array (integer)

	# Initialize the elements array with all 0's
	li $t0,0
	move $t1,$s2

Q4Initialize:
	beq $t0, $s3, Q4EndInitialize
	sw $zero, 0($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j Q4Initialize
Q4EndInitialize:

	# Traverse the number string and convert the numbers to integer
	la $t0,Q4NumString
	move $t1,$s2
	li $t2,10 # ASCII code of newline
	li $t3,32 # ASCII code of space

Q4TraverseString:
	lbu $t4, 0($t0)
	beq $t4, $t2, Q4EndTraverseString
	beq $t4, $t3, Q4SpaceCase

	# Multiply the value loaded from the array by 10
	lw $t5, 0($t1)
	li $t6,10
	mul $t5,$t5,$t6

	# Subtract 48 from characters to convert them to integers
	addi $t4, $t4, -48

	# Add the integer value to the corresponding array location
	add $t5, $t5, $t4
	sw $t5, 0($t1)
	j Q4EndSpaceCase
Q4SpaceCase:
	addi $t1, $t1, 4
Q4EndSpaceCase:
	addi $t0, $t0, 1
	j Q4TraverseString
Q4EndTraverseString:

	# Check if the numbers are unique
	li $t0,0 # Outer loop index
	addi $t1, $s3, -1

Q4CheckUniqueness:
	beq $t0, $t1, Q4EndCheckUniqueness
	sll $t2, $t0, 2
	add $t2, $t2, $s2
	lw $t2, 0($t2)

	addi $t3, $t0, 1 # Inner loop index

Q4CheckUniquenessInner:
	beq $t3, $s3, Q4EndCheckUniquenessInner
	sll $t4, $t3, 2
	add $t4, $t4, $s2
	lw $t4, 0($t4)

	beq $t2, $t4, Q4NotUnique
	addi $t3, $t3, 1
	j Q4CheckUniquenessInner
Q4NotUnique:
	li $v0,4
	la $a0,Q4NotUniquePrompt
	syscall
	j Q4Return
Q4EndCheckUniquenessInner:

	addi $t0, $t0, 1
	j Q4CheckUniqueness
Q4EndCheckUniqueness:

	# Array for the minimum elements in each row
	li $v0,9
	sll $t0, $s0, 2
	move $a0,$t0
	syscall
	move $s4,$v0 # $s4 = Array of minimum row elements

	# Array for the maximum elements in each column
	li $v0,9
	sll $t0, $s1, 2
	move $a0,$t0
	syscall
	move $s5,$v0 # $s5 = Array of maximum column elements

	# Find the minimum element in each row
	li $t0,0

Q4RowMinimums:
	beq $t0, $s0, Q4EndRowMinimums
	mul $t1,$t0,$s1
	sll $t1, $t1, 2
	add $t1, $t1, $s2
	lw $t2, 0($t1) # $t2 holds the minimum number

	li $t3,1

Q4RowMinimumsInner:
	beq $t3, $s1, Q4EndRowMinimumsInner
	sll $t4, $t3, 2
	add $t4, $t4, $t1
	lw $t4, 0($t4)
	blt $t4,$t2,Q4Less
	addi $t3, $t3, 1
	j Q4RowMinimumsInner
Q4Less:
	move $t2,$t4
	addi $t3, $t3, 1
	j Q4RowMinimumsInner
Q4EndRowMinimumsInner:
	sll $t5, $t0, 2
	add $t5, $t5, $s4
	sw $t2, 0($t5)
	addi $t0, $t0, 1
	j Q4RowMinimums
Q4EndRowMinimums:

	# Find the maximum element in each column
	li $t0,0

Q4ColumnMaximums:
	beq $t0, $s1, Q4EndColumnMaximums
	sll $t1, $t0, 2
	add $t1, $t1, $s2
	lw $t1, 0($t1) # $t1 holds the maximum number

	li $t2,1

Q4ColumnMaximumsInner:
	beq $t2, $s0, Q4EndColumnMaximumsInner
	sll $t3, $s1, 2
	mul $t3, $t3, $t2
	add $t3, $t3, $s2
	sll $t5, $t0, 2
	add $t3, $t3, $t5
	lw $t3, 0($t3)
	blt $t1,$t3,Q4Bigger
	addi $t2, $t2, 1
	j Q4ColumnMaximumsInner
Q4Bigger:
	move $t1,$t3
	addi $t2, $t2, 1
	j Q4ColumnMaximumsInner
Q4EndColumnMaximumsInner:

	sll $t4, $t0, 2
	add $t4, $t4, $s5
	sw $t1, 0($t4)
	addi $t0, $t0, 1
	j Q4ColumnMaximums
Q4EndColumnMaximums:

	# Create an array for lucky numbers (first, find the size of it)
	blt $s0,$s1,Q4RowLess
	move $t0, $s1
	j Q4EndFindLuckyArrLength
Q4RowLess:
	move $t0, $s0
Q4EndFindLuckyArrLength:
	move $s7,$t0 # $s7 = Lucky numbers array length

	li $v0,9
	sll $t0, $t0, 2
	move $a0,$t0
	syscall
	move $s6,$v0 # $s6 = Address of lucky numbers array

	# Initialize the elements array with -1's
	li $t0,0

Q4InitializeLuckyNumberArr:
	beq $t0, $s7, Q4EndInitializeLuckyNumberArr
	sll $t1, $t0, 2
	add $t1, $t1, $s6
	li $t2,-1
	sw $t2, 0($t1)
	addi $t0, $t0, 1
	j Q4InitializeLuckyNumberArr
Q4EndInitializeLuckyNumberArr:

	# Compare each number in the row-minimums array with all numbers in the column-maximums array. 
	# If a number exists in both arrays, it is a lucky number.
	li $t0,0
	li $t4,0

Q4Lucky:
	beq $t0, $s0, Q4EndLucky
	sll $t1, $t0, 2
	add $t1, $t1, $s4
	lw $t1, 0($t1)

	li $t2,0

Q4LuckyInner:
	beq $t2, $s1, Q4EndLuckyInner
	sll $t3, $t2, 2
	add $t3, $t3, $s5
	lw $t3, 0($t3)

	bne $t1, $t3, Q4NotEqual
	sll $t5, $t4, 2
	add $t5, $t5, $s6
	sw $t1, 0($t5)
	addi $t4, $t4, 1
Q4NotEqual:
	addi $t2, $t2, 1
	j Q4LuckyInner
Q4EndLuckyInner:

	addi $t0, $t0, 1
	j Q4Lucky
Q4EndLucky:

	# Print the messages whether there is a lucky number found or not
	bne $t4, $zero, Q4LuckyExists
	li $v0,4
	la $a0,Q4NoLuckyFoundMsg
	syscall
	j Q4Return
Q4LuckyExists:
	li $v0,4
	la $a0,Q4LuckyFoundMsg
	syscall

	li $t0,0

Q4PrintLuckies:
	beq $t0, $t4, Q4Return
	sll $t1, $t0, 2
	add $t1, $t1, $s6
	lw $t1, 0($t1)

	li $v0,1
	move $a0,$t1
	syscall

	li $v0,4
	la $a0,Q4SpaceChar
	syscall
	
	addi $t0, $t0, 1
	j Q4PrintLuckies
Q4Return:
	li $v0,4
	la $a0,MenuNewLine
	syscall
	syscall

	# Restore the registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32

	# Return
	jr $ra

MenuQuit:
    li $v0, 4
    la $a0, MenuGoodBye
    syscall

    li $v0, 10
    syscall