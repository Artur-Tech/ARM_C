.global max

max:
    // Arguments:
    // r0: Array Address
    // r1: Array Length
    // Return value:
    // r0: Value of the biggest Array-Element
    // Register assignment:
    // r2: Maximum value found so far
    // r3: Array element being checked
    // r4: Loop counter
    LDR r2, [r0]           // Load the first element of the array into r2 as the current maximum
    SUB r1, r1, #1         // Decrement the length of the array by 1
    BEQ end                // If the array has only one element, jump to the end of the function
    ADD r4, r1, #0         // Copy the array length to r4
loop:
    LDR r3, [r0, r4, LSL #2] // Load the next element of the array into r3
    CMP r2, r3              // Compare the current maximum with the next element
    MOVLT r2, r3            // If the next element is greater, update the maximum
    SUBS r4, r4, #1         // Decrement the loop counter
    BNE loop                // If the loop counter is not zero, continue looping
end:
    MOV r0, r2 // Return the maximum in r0
    BX lr     // Jump back to the calling C function
