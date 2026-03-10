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
    // Input parameter a is passed in X0; input parameter utf8 is passed in X2
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
    