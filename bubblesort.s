main
			
			;		We will use this function to test our Bubble Sort Algorithm, so we will create an unsorted array with 5 elements and sort it
			
			;		Initialize Array using Registers R1 and R0. This will also serve as the parameter that will be passed to the sort function
			mov		r1,#5
			mov		r0, #0x14000000
			
			;		We will now add data to the 5 memory spaces in the array. Register R10 will be used to store the
			;		temporary numeric value that will be stored to the array
			
			;		Store 5 at index 0 of the array
			mov		r10, #5
			str		r10, [r0, #0]
			
			;		Store 7 at index 1 of the array
			mov		r10, #7
			str		r10, [r0, #4]
			
			;		Store 9 at index 2 of the array
			mov		r10, #9
			str		r10, [r0, #8]
			
			;		Store 1 at index 3 of the array
			mov		r10, #1
			str		r10, [r0, #12]
			
			;		Store 3 at index 4 of the array
			mov		r10, #3
			str		r10, [r0, #16]
			
			;		Reset the Register we used back to 0
			mov		r10, #0
			
			;		Now that the array has been created and parameters has been set, we branch (call) the sort function to sort our array.
			;		We use the Branch & Link (bl) instruction to save the address of the next instruction into LR so it could return here after the sort function exits
			bl		sort
			
sort
			stmfd	sp!, {r0,r1,r2,r3,r4, r5, r6, r7, r8,r9,r10, lr}	; Add registers to the stack. This is equivalent to the PUSH instruction
			
			;		The following code are represented as a high level code comment to the right to understand it.
			
			;		Keeps track of the swapped state using Register R6
			mov		r6, #1                   ; swapped = true
			
while									; while {
			;		If swapped is false,
			;		exit the while loop
			cmp		r6, #0                   ; 	if(swapped == false){
			beq		endwhile				;     	//exit while loop
			;		-						}else{
			;		-							//continue while loop
			;		Set swapped as false
			mov		r6,#0				;     	swapped = false
			
			;		Set the base pointer for the array
			mov		r4, r0 	; base pointer of array
			mov		r9,#0	; set index i
			sub		r5,r1,#1	; set value n - 1
for										;     	for{
			;		Forloop condition
			cmp		r9, r5				;			if(i >= (n-1)){
			bge		endfor				;				//exit for loop
			;		-					               }else{
if
			;		load values for p[i] and p[i - 1]
			ldr		r7, [r4]				;				// get p[i]
			ldr		r8, [r4, #4]			;				// get p[i + 1]
			
			cmp		r7,r8				; 				if(p[i] <= p[i + 1]){
			ble		endif				;					//exit if condition
			;		-									}else{
			
			str		r7, [r4, #4]			; 					p[i + 1] = p[i]
			str		r8, [r4]				;					p[i] = p[i + 1]
			
			mov		r6, #1				;					swapped = true
			b		endif
endif									;				}
			add		r4,r4,#4
			add		r9,r9,#1				;				i += 1
			;		-                                       }
			
			b		for
endfor									;     	}
			;		-						}
			
			sub		r1, r1,#1				;    n -= 1
			b		while
endwhile									; }
			b		endfunction
			
endfunction
			
			ldmfd	sp!, {r0,r1,r2,r3,r4, r5, r6, r7, r8,r9,r10, lr}	; Restoring Registers, Frame Pointer, and Link Register from the stack. This is Equivalent to the POP instruction
			
exitprogram
			;		For debug purposes, we will store the array values in R1, R2, R3, R4, R5 and see that the final array is sorted.
			;		Final array should be array[1, 3, 5, 7, 9]
			ldr		r1, [r0, #0]
			ldr		r2, [r0, #4]
			ldr		r3, [r0, #8]
			ldr		r4, [r0, #12]
			ldr		r5, [r0, #16]
