/**************************************************************************
 * C S 429 Assembly Coding Lab
 *
 * functions.s - Template for all functions to be implemented.
 *
 * Copyright (c) 2022, 2023, 2024, 2025, 2026
 * Authors: Kavya Rathod, Prithvi Jamadagni, Anoop Rachakonda, Zeeshan Ahmad, Hugo Mireles
 * All rights reserved.
 * May not be used, modified, or copied without permission.
 **************************************************************************/

 /*
 ** YIFEI (PHOEBE) WANG YW27589 **
 */
    
    .arch armv8-a
	.file	"functions.c"
	.text


// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global lru
    .type   lru, %function
lru:
    // (STUDENT TODO) Code for LRU goes here.
    // Input parameter access is passed in X0
    // Input parameter cache_matrix is passed in X1
    // Output value is returned in X0
    
    // x0 = access
    // x1 = cache_matrix

    // first assign the value of cache_matrix to a register
    // load the value of x1 into register x2
    // m = *cache_matrix
    LDUR X2, [X1] // X2 = the value at mem addr stored in x1, cache_matrix

    // step 1: fill column i of the matrix with 1's
    // X3 = 0x0101010101010101
    MOVZ X3, #0x0101, LSL #48
    MOVK X3, #0x0101, LSL #32
    MOVK X3, #0x0101, LSL #16
    MOVK X3, #0x0101
    // shift by access 
    // X4 = column mask = base << access
    LSL X4, X3, X0 
    // or with current cache_matrix
    // m |= column mask
    ORR X2, X2, X4
    // *cache_matrix = m
    // store the value in x2 into memory address x1

    // step 2: set row i to 0's
    // X5 = multiply 8 to determine how many bits to shift
    LSL X5, X0, #3
    // shift by X5
    MOVZ X6, #0xFF // X6 = masking one byte
    LSL X6, X6, X5 // X6 = 0xFF << (access * 8)
    // negate to make the mask
    MVN X6, X6
    // and with original matrix to 0 out row
    ANDS X2, X2, X6
    // store into mem addr x1
    STUR X2, [X1]

    // part 3
    // collaspe the 8 rows 
    MOVZ X7, #0 // zero out everything in x7
    // make first mask >> 32
    LSR X7, X2, #32
    ORR X2, X2, X7
    // make second mask >> 16
    LSR X7, X2, #16
    ORR X2, X2, X7
    // make third mask >> 8
    LSR X7, X2, #8
    ORR X2, X2, X7
    // keep only last byte
    MOVZ X8, #0x00FF 
    ANDS X2, X2, X8

    // invert
    MVN  X2, X2
    ANDS X2, X2, X8

    // smear the first 1 bit to the right
    MOVZ X7, #0
    LSR X7, X2, #1
    ORR X2, X2, X7
    LSR X7, X2, #2
    ORR X2, X2, X7
    LSR X7, X2, #4
    ORR X2, X2, X7

    // pop count
    MOVZ X8, #0x55
    LSR X9, X2, #1
    ANDS X9, X9, X8
    MOVZ X10, #0
    ANDS X10, X2, X8
    ADDS X2, X10, X9

    MOVZ X8, #0x33
    LSR X9, X2, #2
    ANDS X9, X9, X8
    MOVZ X10, #0
    ANDS X10, X2, X8
    ADDS X2, X10, X9

    MOVZ X8, #0x0F
    LSR X9, X2, #4
    ANDS X9, X9, X8
    MOVZ X10, #0
    ANDS X10, X2, X8
    ADDS X2, X10, X9

    // return the final count
    MOVZ X11, #1
    SUBS X0, X2, X11 // subtract 1 to get the index of the LRU way

    ret
    .size   lru, .-lru
    // ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
	.align	2
	.global	UTF8_to_unicode
	.type	UTF8_to_unicode, %function
UTF8_to_unicode:
    // (STUDENT TODO) Code for UTF8_to_unicode goes here.
    // Input parameter utf8 is passed in X0
    // Output value is returned in X0

    ret
	.size	UTF8_to_unicode, .-UTF8_to_unicode
	// ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
	.align	2
	.global	unicode_to_UTF8
	.type	unicode_to_UTF8, %function
unicode_to_UTF8:
    // (STUDENT TODO) Code for unicode_to_UTF8 goes here.
    // Input parameter a is passed in X0; input parameter utf8 is passed in X1
    // There are no output values

    ret
	.size	unicode_to_UTF8, .-unicode_to_UTF8
	// ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global compare
    .type   compare, %function
compare:
    // Input parameter a is passed in X0; input parameter b is passed in X1.
    // Output value is returned in X0.

    // unique_id
    LDUR X2, [X0]
    LDUR X3, [X1]
    CMP X2, X3
    B.NE not_equal // not equal to 0

    // seat_code + padding
    LDUR X2, [X0, #8]
    LDUR X3, [X1, #8]
    // mask out the padding
    MOVZ X4, #0xFFFF
    MOVK X4, #0x00FF, LSL #16
    ANDS X2, X2, X4
    ANDS X3, X3, X4
    CMP X2, X3
    B.NE not_equal

    // price
    LDUR X2, [X0, #16]
    LDUR X3, [X1, #16]
    CMP X2, X3
    B.NE not_equal

    // special + padding
    LDUR X2, [X0, #24]
    LDUR X3, [X1, #24]
    // mask out the padding
    MOVZ X4, #0x00FF
    ANDS X2, X2, X4
    ANDS X3, X3, X4
    CMP X2, X3
    B.NE not_equal

    // recommendations
    LDUR X2, [X0, #32]
    LDUR X3, [X1, #32]
    CMP X2, X3
    B.NE not_equal

    // refund + padding
    LDUR X2, [X0, #40]
    LDUR X3, [X1, #40]
    MOVZ X4, #0x00FF
    ANDS X2, X2, X4
    ANDS X3, X3, X4
    CMP X2, X3
    B.NE not_equal

    // all equal
    MOVZ X0, #0
    RET

not_equal:
    MOVZ X0, #1
    RET

    .size   compare, .-compare
    // ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
	.align	2
	.global	tree_depth
	.type	tree_depth, %function
tree_depth:
    // (STUDENT TODO) Code for tree_depth goes here.
    // Input parameter root is passed in X0.
    // Output value is returned in X0.

    ret
	.size	tree_depth, .-tree_depth
	// ... and ends with the .size above this line.

	// Every function starts from the .align below this line ...
	.align	2
	.global	insert_at_head
	.type	insert_at_head, %function
insert_at_head:
    // (STUDENT TODO) Code for insert_at_head goes here.
    // Input parameter head is passed in X0; input parameter data is passed in X1; input parameter tail is passed in X2
    // There is no output value. Parameter head will be mutated, and possibly tail

ret

	.size	insert_at_head, .-insert_at_head
	// ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global del_at_head
    .type   del_at_head, %function
del_at_head:
    // (STUDENT TODO) Code for del_at_head goes here.
    // Input parameter head is passed in X0; Input parameter tail is passed in X1
    // There is no output value. Parameter head and tail will be possibly mutated

    ret
    .size   del_at_head, .-del_at_head
    // ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global sum_up
    .type   sum_up, %function
sum_up:
    // (STUDENT TODO) Code for sum_up goes here.
    // Input parameter starting_node is passed in X0
    // Output value is returned in X0.

    .size   sum_up, .-sum_up
    // ... and ends with the .size above this line.
    