#studentName:260824476
#studentID:Li,botian

# This MIPS program should count the occurence of a word in a text block using MMIO

.data
#any any data you need be after this line 
buffer: .space 600
getwords: .space 100
keywords: .space 100
greeting: .asciiz "Word count\n"
enter: .asciiz "Enter the text segemt:\n"
search: .asciiz "Enter the search word:\n"
result1: .asciiz "The word "
result2: .asciiz " times\n"
occur: .assciiz " occure :
question: .asciiz "press 'e'  to enter another  segment of text or 'q' to quite.\n"
line: .asciiz"\n"

error: .asciiz "wrong input\n"
exitprogram: .asciiz  "Finished program\n"

	.text
	.globl main

main:	# all subroutines you create must come below "main"
	
	
	
	la $a0,greeting
	jal  Strings
	

	addi $sp,$sp,-28
	
	
	
	
redo:	li $a0,0	
	sw $a0,0($sp) 		#number of occurence of the word,initialze with 0
	
	la  $a0,enter  		#print enter message
	jal Strings
	
	jal restorebuffer
	la $t1,buffer		#save buffer adress into stack
	sw $t1,4($sp)
	
	li $a0,0	
	sw $a0,8($sp)		#number of operation I/O did
	
	li $a0,0
	sw $a0,16($sp)	
		#boolean value for last word
	j echo 			#get input from i/o
	
finishtext:
	#li $a0,0
	#jal Write
	
	lw $a1,8($sp)	
	beq $a1,0,here
	beq $a1,1,here1

here:	
	la $a0,buffer
	jal Strings
	 
	 la $a0,line
	 jal Strings
	
	
	la $a0,search
	jal Strings
	
	la $t1,keywords
	
	sw $t1,4($sp) 		#put keyword buffer into stack instead of text buffer
	lw $a1,8($sp)	
	addi $a1,$a1,1
	sw $a1,8($sp)
	j echo

	
echo:	
	
	jal countword
	
	add $a0,$v1,$zero
	
	jal intobuffer
	
	#add $a0,$v1,$zero
	#jal Write
	
	j echo
	
intobuffer:
	
	lw $t1,4($sp)
	add $a1,$a0,$zero
	beq $a1,10,finishtext 	#hit enter quit i/o
	#beq $a1,33,intobuffer
	#b $a1,33,intobuffer
	sb $a1,0($t1) 	      	#store data into buffer

	addi $t1,$t1,1		#else advance buffer adress then advance
	sw $t1,4($sp)		#safe advance data back to stack 
				#put result back to v0
	add $v0,$a1,$zero	#jump back to link
	jr $ra
	

countword: 
				#Strings: process for displaying strings to MMIO (a1 should string to displa
Read:  	lui $t0, 0xffff 	#ffff0000

Loop1:	lw $t1, 0($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop1
	lb $v1, 4($t0)
	
	jr $ra

Write:  lui $t0, 0xffff 		#ffff0000

Loop2: 		
	lw $t1, 8($t0) 			#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop2
	sw $a0, 12($t0) 		#data	
	jr $ra

here1:	
	
	
	la $a0,keywords
	jal Strings
	
	la $a1,keywords			#address of keyword buffer with content in it
	jal countlength 
	
	move $a1,$v0			#length of keyword
	addi $a1,$a1,0			#put result in #a1
	sw $a1,12($sp) 			#store length into stack
	
	la $t1,buffer 	
	sw $t1,4($sp)

checkOccurence:
	jal getWord			#go to occurencecheck,get word return adress of the word buffer
	 
	la $a1,getwords
	jal countlength	
	
	addi $a1,$v0,0
	lw $t0,12($sp) 	
	beq $a1,$t0,h1			#if the length of this 2 words is the same, check for next step

h:	lw $t3,16($sp)
					#boolean to check if its the last word or not,   1 means it is the last word
	beq $t3,1,printresult	
					#if it is the last word and it is not same length,go to printresult, else
	j checkOccurence
	
h1:	jal nextstep			#if length is the same,check if content is the same, this return null
					#then go back to loop,where checking if this is the last words or not
	j h

nextstep: #void nextstep()
	
	
	##li $v0,4
	#la $a0,line
	#syscall
	#li $v0,4
	#la $a0,keywords
	#syscall
	#li $v0,4
	#la $a0,line
	#syscall
	lw $t0,12($sp)	 	#length of the key word
	li $t1,0		#initialize to zero
	la $t2,getwords		#get pointer of the getwords buffer
	la $t4,keywords 	#address of key word	
	
lllop:	lb $t3,0($t2) 		#one byte at a time from  getword
	lb  $t5,0($t4)		#one byte at a time of keyword char
	bne $t5,$t3,exit	#exit if not the same char at same position
	beq $t1,$t0,wrapup  	#if hit run succeseult to the last char and didnt exit, means the word match
	addi $t1,$t1,1		#counting +1
	addi $t2,$t2,1		#move pointer forward
	addi $t4,$t4,1
					#beq $t1,$t0,wrapup  	#if hit run succeseult to the last char and didnt exit, means the word match
	j lllop

exit:				#return null

	j er			
wrapup: 
	lw $t1,0($sp) 		# load number ocvcurence in $t1
	addi $t1,$t1,1		#occurence+1
	sw $t1,0($sp)		#save it back to stack
	j er		
	
er:	
	jr $ra
				
printresult:	#print result on the screen weather its 0 or greater than 0
	 la $a0,line
	 jal Strings

	la  $a0,result1  #the  word
	jal Strings
	

	la $a0,keywords  #keyword
	
	jal Strings
	
	li $a0,32
	 jal Write
	
	 lw  $t1,0($sp)
	 
	 addi $a0,$t1,48
	 jal Write
	 
	 
	
	la $a0,result2
	jal Strings
	
	 
	 la $a0,question
	jal Strings
	 
	 jal Read
	 addi $a0,$v1,0
	 beq $a0,101,redo
	 beq $a0,113,finished  #check opytion after finish the program
	 
	
	

	 j finished

countlength: 
	li  $t1,0	
	add $t0,$a1,$zero #put argument in t0
	
loopp:	lb $t2,0($t0) #get first char of keywords
	
	
	beq $t2,0,out #if char is enter,then finish


	addi $t1,$t1,1	
	addi $t0,$t0,1 #move pointer forward
	
	
	j loopp
	

out:	
	addi $v0,$t1,0
	jr $ra	# return int length

getWord:
	sw $ra,24($sp) #return  adress at 24
	jal restore
	la $t2,getwords		#poitner of getwords
	lw $t1,4($sp)		#pointer to buffer
hh:	lb $t4,0($t1) 
	bge $t4,33,skipit		#byte from buffer ignor special char like ',' '!'
isnot:	beq $t4,32,wordgot       #if it is space, we get the word
	beq $t4,0,lastword
	sb $t4,0($t2)		#store char to getwords buff

				#addi $t1,$t1,1		#move pointer forward
	addi $t2,$t2,1		#move pointer  forward
yes:	addi $t1,$t1,1
	j hh
skipit:	
	ble $t4,47,yes
	j isnot
wordgot: 
	addi $t1,$t1,1       	#pointer to the next availble char
	j ici
lastword:
	lw $t3,16($sp) 		#use as boolean variable
	addi $t3,$t3,1		#initlay zero,var=1, it is the last word
	sw $t3,16($sp)
	j ici
	
ici:	
	li $s1,0		#enter char
	sb $s1,0($t2) 		#put a null char at the end
	sw $t1,4($sp) 		#store pointer adress back to stack
	lw $ra,24($sp)
	jr $ra

restorebuffer:
	la $t1,buffer#getadress of getwords buff
	li $t2,0	# for loop i =0
	li $t5,0
mminiL:
	sb $t5,0($t1) #buffer[i]=null
	addi $t1,$t1,1  #i++
	addi  $t2,$t2,1 #buffer ++
	bge $t2,600,quitt #i=100,exit
	j mminiL	
quitt:	
	 jr $ra	
restore:
	la $t1,getwords #getadress of getwords buff
	li $t2,0	# for loop i =0
	li $t5,0
miniL:
	sb $t5,0($t1) #buffer[i]=null
	addi $t1,$t1,1  #i++
	addi  $t2,$t2,1 #buffer ++
	bge $t2,100,quit #i=100,exit
	j miniL	
quit:	
	 jr $ra	
	 
Strings:
    #Strings: process for displaying strings to MMIO (a1 should string to display)
     lui $t0, 0xffff #ffff0000
loopStr:lw $t1, 8($t0) #control
     andi $t1,$t1,0x0001
     beq $t1, $0, loopStr
    
     lb $t3, 0($a0)
     
     beq $t3, 0, strDone
     sw  $t3,12($t0)
     addi $a0, $a0, 1
    
     j Strings
strDone: jr $ra  
	 				
	
finished:	
	
	
	addi $sp,$sp,28
			#retore stack and quit
	
	la $a0,exitprogram
	jal  Strings
	
	
	
	
	
	
	
	
