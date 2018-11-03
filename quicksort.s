main
			;		The following 3 lines is the prologue. It saves the current state of the registers including the Frame Pointer (FP) and Link Register (LR)
			;		so we could restore it back when the function exits. This is necessary since there is only one set of Registers and we are going to update it.
			stmfd	sp!, {r1, r2, r11, lr}		; Add registers to the stack. This is equivalent to the PUSH instruction
			add		r11, sp, #0				; Setting up the Frame Pointer (FP) to the bottom of the stack frame. Note that R11 is the Register for the FP
			sub		sp, sp, #24  				; End of the prologue. Allocating some buffer on the stack
			
			;		We will use this function to test our Quick Sort Algorithm, so we will create an unsorted array with 5 elements and sort it
			
			;		Initialize Array using Registers R1 and R2. This will also serve as the parameter that will be passed to the sort function
			mov		r1, #0x14000000 	; Allocate an address in memory to be the base address (starting address) of the array
			mov		r2, #5       		; Set the size of the array (Number of elements)
			
			;		We will now add data to the 5 memory spaces in the array. Register R3 will be used to store the
			;		temporary numeric value that will be stored to the array
			
			;		Store 5 at index 0 of the array
			mov		r3, #5
			str		r3, [r1, #0]
			
			;		Store 7 at index 1 of the array
			mov		r3, #7
			str		r3, [r1, #4]
			
			;		Store 9 at index 2 of the array
			mov		r3, #9
			str		r3, [r1, #8]
			
			;		Store 1 at index 3 of the array
			mov		r3, #1
			str		r3, [r1, #12]
			
			;		Store 3 at index 4 of the array
			mov		r3, #3
			str		r3, [r1, #16]
			
			;		Reset the Register we used back to 0
			mov		r3, #0
			
			;		Now that the array has been created and parameters has been set, we branch (call) the sort function to sort our array.
			;		We use the Branch & Link (bl) instruction to save the address of the next instruction into LR so it could return here after the sort function exits
			bl		sort
			
			;		We are now at the end of the function, we need to restor original values to registers before exiting.
			;		The following 2 lines is the epilogue. It restores Registers to its original values and Readjusts the Stack Pointer (SP)
			mov		sp, r11  				; Readjusting the Stack Pointer
			ldmfd	sp!, {r1, r2, r11, lr}	; Restoring Registers, Frame Pointer, and Link Register from the stack. This is Equivalent to the POP instruction
			
			;		Before we end the program, we will store the array values in R0, R1, R2, R3, R4 for debug purposes and see that the final array is sorted.
			;		Final array should be array[1, 3, 5, 7, 9]
			
			mov		r10, #0x14000000 	; We go to the base address of the array. We will use Register R10 this time cause we want Registers R0-R4 to display the output for debug puprose
			
			ldr		r0, [r10, #0]		; Load array[0] and save it to Register R0
			
			ldr		r1, [r10, #4]		; Load array[1] and save it to Register R1
			
			ldr		r2, [r10, #8]		; Load array[2] and save it to Register R2
			
			ldr		r3, [r10, #12]		; Load array[3] and save it to Register R3
			
			ldr		r4, [r10, #16]  	; Load array[4] and save it to Register R4
			
			;		At this point we already finished executing all instructions, we will branch (call) the endprogram function to exit
			b		endprogram
			
sort
			;		The following 3 lines is the prologue. It saves the current state of the registers including the Frame Pointer (FP: R11) and Link Register (LR)
			;		so we could restore it back when the function exits. This is necessary since there is only one set of Registers and we are going to update it.
			stmfd	sp!, {r1, r2, r3, r4, r11, lr}	; Add registers to the stack. This is equivalent to the PUSH instruction
			add		r11, sp, #0  					; Setting up the Frame Pointer (FP) to the bottom of the stack frame. Note that R11 is the Register for the FP
			sub		sp, sp, #32  					; End of the prologue. Allocating some buffer on the stack
			
			;		We will call the function quicksort and pass in 3 parameters including q, start, and end. Parameter q is already in the local parameter so
			;		we will just pass it to the quicksort function. Register R3 and R4 will be used for the start and end paramters respectively
			mov		r3, #0		; Set start parameter as 0
			sub		r4, r2, #1	; Set the end paramter as n - 1
			
			;		Now that the parameters has been set, we branch (call) the quuicksort function. We use the Branch & Link (bl) instruction to save the
			;		address of the next instruction into LR so it could return here after the quicksort function exits
			bl		quicksort
			
			;		We are now at the end of the function, we need to restor original values to registers before exiting.
			;		The following 3 lines is the epilogue. It restores Registers to its original values, Readjusts the Stack Pointer (SP),
			;		and jumps back to the caller function via the Link Register (LR)
			mov		sp, r11  						; Readjusting the Stack Pointer
			ldmfd	sp!, {r1, r2, r3, r4, r11, lr}     ; Restoring Registers, Frame Pointer, and Link Register from the stack. This is Equivalent to the POP instruction
			mov		pc, lr           				; Jumping back to caller function via LR register
			
			
quicksort
			;		The following 3 lines is the prologue. It saves the current state of the registers including the Frame Pointer (FP: R11) and Link Register (LR)
			;		so we could restore it back when the function exits. This is necessary since there is only one set of Registers and we are going to update it.
			stmfd	sp!, {r1, r2, r3, r4, r5, r6, r11, lr}	; Add registers to the stack. This is equivalent to the PUSH instruction
			add		r11, sp, #0  						; Setting up the Frame Pointer (FP) to the bottom of the stack frame. Note that R11 is the Register for the FP
			sub		sp, sp, #40  						; End of the prologue. Allocating some buffer on the stack
			
			;		The quicksort function only executes the code if start < end, so we first compare start and end to see if start >= end and we exit.
			;		Otherwise, continue
			cmp		r3, r4		; Compare start (R3) and end (R4)
			bge		endquicksort	; If start >= end, we exit the function
			
			;		The following code is executed if start < end. First, it calls the partition function to get the
			;		partition index (middle index to plit in two) of the array and stores it in q. Register R5 is used for q. Paramters are the same so its
			;		just passed when calling partition. After the partition index q is gotten, this function is recursively called twice. To pass the
			;		left half of the array, and to pass the right half of the array
			
			bl		partition		; Call the partition function. use the Branch & Link (bl) instruction to save the address of the next instruction into LR so it could return here after the sort function exits
			mov		r5, r0 		; Save retured value from partition function to q (Register R5)
			
			;		Registers R6, R7 and R8 will be used to store temporary values
			;		Sort the Left half of the array by recursively calling this function and passing the required parameters.
			mov		r6, r4 		; Save current state of end to temp since end will be modified. R6 is temp and R4 is end
			sub		r4, r5, #1	; Readjust end (R4) value to (q - 1)
			bl		quicksort		; call quicksort
			
			mov		r4, r6 		; Restore the value of end (R4) from temp  (R6)
			
			;		Sort the Right half of the array by recursively calling this function and passing the required parameters.
			mov		r6, r3 		; Save current state of start to temp since start will be modified. R6 is temp and R3 is start
			add		r3, r5, #1 	; Readjust end (R3) value to (q + 1)
			bl		quicksort		; call quicksort
			
endquicksort
			;		We are now at the end of the function, we need to restor original values to registers before exiting.
			;		The following 3 lines is the epilogue. It restores Registers to its original values, Readjusts the Stack Pointer (SP),
			;		and jumps back to the caller function via the Link Register (LR)
			mov		sp, r11  								; Readjusting the Stack Pointer
			ldmfd	sp!, {r1, r2, r3, r4, r5, r6, r11, lr}       ; Restoring Registers, Frame Pointer, and Link Register from the stack. This is Equivalent to the POP instruction
			mov		pc, lr           						; Jumping back to caller function via LR register
			
partition
			;		The following 3 lines is the prologue. It saves the current state of the registers including the Frame Pointer (FP: R11) and Link Register (LR)
			;		so we could restore it back when the function exits. This is necessary since there is only one set of Registers and we are going to update it.
			stmfd	sp!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, lr}	; Add registers to the stack. This is equivalent to the PUSH instruction
			add		r11, sp, #0  										; Setting up the Frame Pointer (FP) to the bottom of the stack frame. Note that R11 is the Register for the FP
			sub		sp, sp, #56  										; End of the prologue. Allocating some buffer on the stack
			
			;		We need to first get the value of the pivot point which is at address array[end]. We have to calculate the address to that value in the array.
			
			;		Muliply end * 4 to get address. 4 is the offset between each memory location
			;		we couldn't use the MUL instruction here cause its not available so we made a custom function called multiply to multiply 2 values num1 (stored in R6), and
			;		num2 (stored in R7).
			mov		r6, #4		; Set num1
			mov		r7, r4		; Set num2
			bl		multiply		; Call function to multiply the two numbers. Result is returned in R0
			
			;		Having the memory address offset for value at array[end], we load it and store it at Register R5. R5 is resued here for the pivot point. It will be restored after the function exits
			;		The following code are represented as a high level code comment to the right to understand it.
			
			;		Load pivot and set i and j
			ldr		r5, [r1, r0] 						;	pivot = p[end]
			mov		r10, r3 							;	i = start
			mov		r9,r3 							; 	j=start
			
			;		Begin For Loop and check
			;		condition to exit or continue
for													;	for{
			cmp		r9, r4 							;		if(j >= end){
			bge		endfor							;			//Exit for loop
			;		-								;		}else{
			
			;		Begin inner If Condition
if													;
			;		Calculate memory address
			;		for array[j]
			mov		r6, #4
			mov		r7, r9
			bl		multiply
			
			;		Load array[j] value and
			;		compare to pivot value
			ldr		r8, [r1, r0]						;			//get p[j]
			cmp		r8, r5							;			if(p[j] > pivot){
			bgt		endif							;				//exit if condition
			;		-								;			}else{
			
			mov		r2, r0							;				temp = p[j] (address)
			
			;		Calculate memory address
			;		for array[i]
			mov		r6, #4
			mov		r7, r10
			bl		multiply
			
			;		Load array[i] value
			ldr		r6, [r1, r0]						;				//get p[i]
			
			;		Swap array[i] and array[j] values
			str		r6, [r1, r2]						;				p[j] = p[i]
			str		r8, [r1, r0]						;				p[i] = p[j]
			
			;		Increment i by 1
			add		r10, r10, #1						;				i += 1
			b		endif
endif				 								;			}
			;		Increment j by 1 and loop back to for
			add		r9,r9,#1							;			j += 1
			b		for
			;		-								;		}
			
endfor												;	}
			;		Swap current value of array[i] to
			;		the value on the end of the array
			;		Calculate memory address for
			;		array[end]
			mov		r6, #4
			mov		r7, r4
			bl		multiply
			
			ldr		r8, [r1, r0]						;	//get p[end]
			mov		r2, r0							;	temp = p[end] (address)
			
			;		Calculate memory address
			mov		r6, #4
			mov		r7, r10
			bl		multiply
			
			ldr		r6, [r1, r0]						;	//get p[i]
			
			;		Swap values of array[end] and
			;		array[i]
			str		r6, [r1, r2]						;	p[end] = p[i]
			str		r8, [r1, r0]						;	p[i] = p[end]
			
			;		Return value of i
			mov		r0, r10							;	return i
			b		endpartition
			
endpartition
			;		We are now at the end of the function, we need to restor original values to registers before exiting.
			;		The following 3 lines is the epilogue. It restores Registers to its original values, Readjusts the Stack Pointer (SP),
			;		and jumps back to the caller function via the Link Register (LR)
			mov		sp, r11  											; Readjusting the Stack Pointer
			ldmfd	sp!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, lr}	; Restoring Registers, Frame Pointer, and Link Register from the stack. This is Equivalent to the POP instruction
			mov		pc, lr           									; Jumping back to main via LR register
			
multiply
			;		This is the custom function to multiply 2 values
			;		Setup prologue
			stmfd	sp!, {r3, r6, r7, r11, lr}
			add		r11, sp, #0
			sub		sp, sp, #28
			
			;		Set initial value of local variables
			mov		r0, #0
			mov		r3, #1
loop
			;		loops till it adds all values
			add		r0, r0, r7 	; result += num2
			add		r3, r3, #1	; count += 1
			;		Compare values
			cmp		r3, r6
			ble		loop
			
			b		endmultiply ; End Function
			
endmultiply
			;		Setup Epilogue to restor values of Registers and return to caller
			mov		sp, r11
			ldmfd	sp!, {r3, r6, r7, r11, lr}
			mov		pc, lr
			;+--------------------------------------------------------------
			
endprogram
			END		; End of program
