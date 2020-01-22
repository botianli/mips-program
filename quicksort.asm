#studentName:260824476
#studentID:Li,Botian


# This MIPS program should count the occurence of a word in a text block using MMIO

.data


 
welcome: .asciiz"Welcome to QuickSort\n"
sorted: .asciiz"The sorted list is:\n"
reinitial: .asciiz"The array is re-initialized\n"
endprogram: .asciiz"End Program\n"

integer: .space 2
array: .word 200

line: .asciiz"\n"
.text
.globl main

main:

 	la $a1,welcome
 	jal Strings
 #la $a1,sorted
 #jal Strings
# la $a1,reinitial
# jal Strings
 
 	addi $sp,$sp,-32
redo:   la $a0,integer   	#integer buffer adress
 	sw $a0,16($sp)
 	addi $t1,$zero,0	#index
 	sw $t1,20($sp)
 	li $t1,0
 	sw $t1,24($sp)  	#total number of int
				
j getinput


showit:
		li $a0,10
		jal Write
		
		la $a1,sorted
		jal Strings
	 
		lw  $s0,24($sp)
		mul $s0,$s0,4	
	
		addi $s2, $zero, 0   #initial i=0
	 	     			#count			
while:		beq $s2, $s0,exit #  if index = length, while loop to print the values
		lw $s1, array($s2)
		
		addi $a0,$s1,0
		jal printint
		
		addi $s2, $s2,4
		j while
		

	exit:	
		li $a0,10
		jal Write
		
		j getinput

printint:	
		sw $ra,12($sp)					#addi $t6,$t6,48
		
		li $t7,10 			#s=10
		addi $t6,$a0,0 #hold argument int
		rem $t5,$t6,$t7 	 #rem = int%10
		sub $t4,$t6,$t5			 # result=int-rem  
		beq $t4,0,singlerep 			#if after sub stract=0 than this is single number
		  				  #else it is double numbe		
doublerep:	
		 	
		div $t4,$t4,$t7 #exp: 40/10=4
		addi $t4,$t4,48 # 4+48=52 ascciz value
				#addi $s1,$s1,48 # reminder+48= ascciz value
		addi $a0,$t4,0 # print result
		jal Write

singlerep:	addi $t5,$t5,48 
		addi $a0,$t5,0
		jal Write
		
		li $a0,32
		jal Write  #print space
			
	 	lw $ra,12($sp)
	 	jr $ra
  
 
getinput: 
 		jal Read
		 add $a0,$v0,$zero 
# beq $a0,10,showit
	 	blt $a0,47,checkspace
	 	bgt $a0,57,check  #check if char is  c s or q
		jal Write
  		jal inbuffer
		j getinput
check: 
		 beq $a0,99,initial #char is c
 		beq $a0,115,sort #char is s
 		beq $a0,113,endgame #char is q 
 		j getinput #else loop again

inbuffer: 
		lw $t1,16($sp)
		sb $a0,0($t1)
		addi $t1,$t1,1
		sw $t1,16($sp)
		jr $ra
	
	

sort:		la $a0,integer 
		lb $t1,0($a0) #check if there still number in inter buffer
				#lb $t2,0($a0)
		beq $t1,0,start #if there isn't start sorting
	
		jal inArray #else if there's still number in buffer,put it in array then start sorting
start:
			#la $a0,array		 #a0,address of array
		li $a1,0  		#low =0 
		lw $s0,24($sp) 		#high in stack
		addi $s0,$s0,-1 	#last  index= total element-1
		addi $a2,$s0,0		#a3=high, start sorting
	
		la $a0,array		 #a0,address of array
		jal quicksort
		j showit                 #after finish show it on screen

quicksort:              #quicksort method

		addi $sp, $sp, -16      # Make room for 4

		sw $a0, 0($sp)          # a0
		sw $a1, 4($sp)          # low
		sw $a2, 8($sp)          # high
		sw $ra, 12($sp)         # return address

		move $t0, $a2           #saving high in t0

		slt $t1, $a1, $t0       # t1=1 if low < high, else 0
		beq $t1, $zero, endif       # if low >= high, endif

		jal partition           # call partition 
		move $s0, $v0           # pivot, s0= v0

		lw $a1, 4($sp)          #a1 = low
		addi $a2, $s0, -1       #a2 = pi -1
		jal quicksort           #call quicksort

		addi $a1, $s0, 1        #a1 = pi + 1
		lw $a2, 8($sp)          #a2 = high
		jal quicksort           #call quicksort

 endif:

		lw $a0, 0($sp)          #restore a0
		lw $a1, 4($sp)          #restore a1
		lw $a2, 8($sp)          #restore a2
		lw $ra, 12($sp)         #restore return address
		addi $sp, $sp, 16       #restore the stack
		jr $ra              #return to caller

swap:               #swap method

		addi $sp, $sp, -12  # Make stack room for three

		sw $a0, 0($sp)      # Store a0
		sw $a1, 4($sp)      # Store a1
		sw $a2, 8($sp)      # store a2

		sll $t1, $a1, 2     #t1 = 4a
		add $t1, $a0, $t1   #t1 = arr + 4a
		lw $s3, 0($t1)      #s3  t = array[a]

		sll $t2, $a2, 2     #t2 = 4b
		add $t2, $a0, $t2   #t2 = arr + 4b
		lw $s4, 0($t2)      #s4 = arr[b]

		sw $s4, 0($t1)      #arr[a] = arr[b]
		sw $s3, 0($t2)      #arr[b] = t 


		addi $sp, $sp, 12   #Restoring the stack size
		jr $ra          #jump back to the caller
	
partition:          #partition method

		addi $sp, $sp, -16  #Make room for 5

		sw $a0, 0($sp)      #store a0
		sw $a1, 4($sp)      #store a1
		sw $a2, 8($sp)      #store a2
		sw $ra, 12($sp)     #store return address

		move $s1, $a1       #s1 = low
		move $s2, $a2       #s2 = high

		sll $t1, $s2, 2     # t1 = 4*high
		add $t1, $a0, $t1   # t1 = arr + 4*high
		lw $t2, 0($t1)      # t2 = arr[high] //pivot

		addi $t3, $s1, -1   #t3, i=low -1
		move $t4, $s1       #t4, j=low
		addi $t5, $s2, -1   #t5 = high - 1

forloop: 
  		  slt $t6, $t5, $t4   #t6=1 if j>high-1, t7=0 if j<=high-1
  		  bne $t6, $zero, endfor  #if t6=1 then branch to endfor

  		  sll $t1, $t4, 2     #t1 = j*4
  		  add $t1, $t1, $a0   #t1 = arr + 4j
  		  lw $t7, 0($t1)      #t7 = arr[j]

  		  slt $t8, $t2, $t7   #t8 = 1 if pivot < arr[j], 0 if arr[j]<=pivot
  		  bne $t8, $zero, endfif  #if t8=1 then branch to endfif
  		  addi $t3, $t3, 1    #i=i+1

  		  move $a1, $t3       #a1 = i
  		  move $a2, $t4       #a2 = j
  		  jal swap        #swap(arr, i, j)

  		  addi $t4, $t4, 1    #j++
  			 j forloop

endfif:
   		 addi $t4, $t4, 1    #j++
   		 j forloop       #junp back to forloop

endfor:
  		  addi $a1, $t3, 1        #a1 = i+1
   		 move $a2, $s2           #a2 = high
   		 add $v0, $zero, $a1     #v0 = i+1 return (i + 1);
   		 jal swap            #swap(arr, i + 1, high);

  		  lw $ra, 12($sp)         #return address
  		  addi $sp, $sp, 16       #restore the stack
   		 jr $ra              #junp back to the caller

checkspace:
		beq $a0,32,intoArray #if the char is space,we need to change the inter and put into array
	
		j getinput
	
intoArray:
		jal Write
		jal inArray
		j getinput
inArray:
		addi  $s0,$s0,0
		la $t3,integer #addres of integer
		lb $t1,0($t3)  #first byte
		lb $t2,1($t3)	#second byte
		beq $t1,0,getinput
		beq $t2,0,single
	
	j double
	
double:	#move $a0,$t1
	#jal Write
	#move $a0,$t2
	#jal Write

		addi $t1,$t1,-48 #x-48
		addi $t2,$t2,-48 #y=y-48
		mul $t1,$t1,10  
		add $t1,$t1,$t2 #int=x*10+y
		addi $s0,$t1,0#put in $s1
	
	
		j EXIT
		
single:		 addi $t1,$t1,-48
		addi $s0,$t1,0
	
		j EXIT
			
EXIT:	
		lw  $t5,20($sp) 	#array[i]
	
	
		sw $s0,array($t5)#array[i]=int
	
	
	#lw $s2,array($t5)
	
	
	#li $v0,4
	#la $a0,line
	#syscall
	
		addi $t5,$t5,4 #i=i+1
		sw $t5,20($sp) #save back to stack
		lw $t1,24($sp) # num of int
		addi $t1,$t1,1
		sw $t1,24($sp)	#save ttl number of int back to stack
	
		li $t1,0 #x=0
	
		sb $t1,0($t3)
		sb $t1,1($t3)
		la $t1,integer
		sw $t1,16($sp) #initial pointer to begining of integer
		jr $ra	
						

Read:  		 lui $t0, 0xffff  #ffff0000
Loop1: 		lw $t1, 0($t0)   #control
 		andi $t1,$t1,0x0001
 		beq $t1,$zero,Loop1
 		lw $v0, 4($t0)   #data 
 		jr $ra 
 
 
 
 

Strings:
    #Strings: process for displaying strings to MMIO (a1 should string to display)
     lui $t0, 0xffff #ffff0000
loopStr:lw $t1, 8($t0) #control
     andi $t1,$t1,0x0001
     beq $t1, $0, loopStr
    
     lb $t3, 0($a1)
     sw $t3, 12($t0) #data
     beq $t3, 10, strDone
     addi $a1, $a1, 1
    
     j Strings
strDone: jr $ra  

Write:  lui $t0, 0xffff 		#ffff0000

Loop2: 		
	lw $t1, 8($t0) 			#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop2
	sw $a0, 12($t0) 		#data	
	jr $ra
initial:
	li  $a0,10
	jal Write
	
	la $a1,reinitial
	jal Strings
	j redo
	
endgame:
	la $a1,endprogram
	jal Strings
	addi $sp,$sp,24 #restore stack
	
exor:
     
