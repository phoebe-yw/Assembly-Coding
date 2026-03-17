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

    // load all 4 bytes into x1
    LDUR X1, [X0]
    // only care about the first 4 bytes, so mask out the rest
    MOVZ X10, #0xFFFF
    MOVK X10, #0xFFFF, LSL #16
    ANDS X1, X1, X10
    // extract every byte
    MOVZ X2, #0xFF
    ANDS X3, X1, X2 // x3 = byte0
    LSR X1, X1, #8
    ANDS X4, X1, X2 // X4 = byte1
    LSR X1, X1, #8
    ANDS X5, X1, X2 // X5 = byte2
    LSR X1, X1, #8
    ANDS X6, X1, X2 // X6 = byte3

    MOVZ X12, #0x3F // mask for last 6 bits

    // set the conditions
    MOVZ X11, #0x7F
    CMP X3, X11
    B.LS is_1byte

    MOVZ X11, #0xDF
    CMP X3, X11
    B.LS is_2byte

    MOVZ X11, #0xEF
    CMP X3, X11
    B.LS is_3byte

    // if 4 byte
    MOVZ X11, #0x07
    ANDS X3, X3, X11
    LSL X3, X3, #18 
    ANDS X4, X4, X12
    LSL X4, X4, #12
    ANDS X5, X5, X12
    LSL X5, X5, #6
    ANDS X6, X6, X12
    ORR X0, X3, X4
    ORR X0, X0, X5
    ORR X0, X0, X6
    ret

is_1byte:
    // just return the value in x3
    MOVZ X0, #0
    ORR X0, X0, X3
    RET

is_2byte:
    MOVZ X10, #0x1F
    ANDS X3, X3, X10
    LSL X3, X3, #6
    ANDS X4, X4, X12
    ORR X0, X3, X4
    RET

is_3byte:
    MOVZ X10, #0x0F
    ANDS X3, X3, X10
    LSL X3, X3, #12
    ANDS X4, X4, X12
    LSL X4, X4, #6
    ANDS X5, X5, X12
    ORR X0, X3, X4
    ORR X0, X0, X5
    RET

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
    // first check 1 byte range
    MOVZ X2, #0x7F
    MOVZ X6, #0x3F // x6 = masks last 6 bits
    CMP X0, X2
    B.GT if_2byte
    STUR X0, [X1] // store the value in x0 into memory address x1
    ret

if_2byte:
    MOVZ X2, #0x7FF
    CMP X0, X2
    B.GT if_3byte
    // 2 byte encoding
    // first byte: 110xxxxx
    MOVZ X2, #0xC0 // 11000000
    LSR X3, X0, #6 // first 5 bytes
    ORR X3, X3, X2 // add the 110
    // second byte: 10xxxxxx
    MOVZ X2, #0x80 // 10000000
    ANDS X4, X0, X6 // last 6 bits
    ORR X4, X4, X2 // add the 10
    STUR X3, [X1] 
    STUR X4, [X1, #1] 
    RET

if_3byte:
    MOVZ X2, #0xFFFF
    CMP X0, X2
    B.GT if_4byte
    // first byte
    MOVZ X2, #0xE0
    LSR X3, X0, #12 // first 4 bytes
    ORR X3, X3, X2 // add the 1110
    // second byte
    MOVZ X2, #0x80
    LSR X4, X0, #6 // next 6 bytes
    ORR X4, X4, X2 // add the 10
    // third byte
    ANDS X5, X0, X6 // last 6 bytes
    ORR X5, X5, X2 // add the 10
    STUR X3, [X1]
    STUR X4, [X1, #1]
    STUR X5, [X1, #2]
    RET

if_4byte:
    MOVZ X2, #0xFFFF
    MOVK X2, #0x0010, LSL #16
    CMP X0, X2
    B.GT invalid_utf8
    // first byte
    MOVZ X2, #0xF0
    LSR X3, X0, #18 // first 3 bytes
    ORR X3, X3, X2 // add the 11110
    // second byte
    MOVZ X2, #0x80
    LSR X4, X0, #12 // next 6 bytes
    ANDS X4, X4, X6 // mask to get only 6 bits
    ORR X4, X4, X2 // add the 10
    LSL X4, X4, #8
    // third byte
    LSR X5, X0, #6 // next 6 bytes
    ANDS X5, X5, X6 // mask to get only 6 bits
    ORR X5, X5, X2 // add the 10
    LSL X5, X5, #16
    // fourth byte
    ANDS X7, X0, X6 // last 6 bytes
    ORR X7, X7, X2 // add the 10
    LSL X7, X7, #24
    ORR X3, X3, X4
    ORR X3, X3, X5
    ORR X3, X3, X7
    STUR X3, [X1]
    RET

invalid_utf8:
    MOVZ X2, #0xFFFF
    MOVK X2, #0xFFFF, LSL #16
    STUR X2, [X1]
    RET

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

    // x0 = root
    CMP X0, XZR
    B.EQ is_null

    // make space in SP
    SUB SP, SP, #32 // must be 16 byte aligned
    STUR X0, [SP, #0] // save root
    // sp, #8 not saved just yet for left
    STUR X30, [SP, #16] // save return address

    // load left_depth into x0
    LDUR X0, [X0, #0] 
    BL tree_depth
    STUR X0, [SP, #8] // save left_depth

    // restore root to x9
    LDUR X9, [SP, #0] 
    // load right_depth into x0
    LDUR X0, [X9, #8] 
    BL tree_depth
    // now SP holds root, left_depth, return address; x0 holds right_depth
    // restore left_depth to x10
    LDUR X10, [SP, #8]
    LDUR X30, [SP, #16] // restore return address
    // pop the stack
    ADD SP, SP, #32
    // compare left and right depth
    CMP X10, X0
    B.GT left_deeper
    // right deeper or equal
    MOVZ X11, #1
    ADDS X0, X0, X11
    RET

left_deeper:
    MOVZ X11, #1
    ADDS X0, X10, X11
    RET
is_null:
    MOVZ X0, #0 // return 0 for null node
    RET

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

    // x0 = **head, x1 = data, x2 = **tail
    // save everything
    SUB SP, SP, #32 
    STUR X0, [SP, #0] // save **head
    STUR X1, [SP, #8] // save data
    STUR X2, [SP, #16] // save **tail
    STUR X30, [SP, #24] // save return address

    // create new node
    MOVZ X0, #16 // size of node
    BL malloc 

    // restore saved registers
    LDUR X9, [SP, #0] // restore **head
    LDUR X10, [SP, #8] // restore data
    LDUR X11, [SP, #16] // restore **tail
    LDUR X30, [SP, #24] // restore return address
    // pop the stack
    ADD SP, SP, #32

    STUR X10, [X0] // new_node->data = data

    // check if head is NULL
    LDUR X12, [X9] // X12 = *head
    CMP X12, XZR
    B.NE not_empty

    // empty list, new node is both head and tail
    MOVZ X13, #0 // X13 = NULL
    STUR X13, [X0, #8] // new_node->npx = NULL
    STUR X0, [X9] // *head = new_node
    STUR X0, [X11] // *tail = new_node
    ret

not_empty:
    STUR X12, [X0, #8] // new_node->npx = *head
    LDUR X13, [X12, #8] // X13 = (*head)->npx
    EOR X13, X13, X0 // X13 = (*head)->npx XOR new_node
    STUR X13, [X12, #8] // (*head)->npx
    STUR X0, [X9] // *head = new_node
    RET

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

    // x0 = **head, x1 = **tail
    LDUR X2, [X0] // X2 = *head
    LDUR X3, [X1] // X3 = *tail
    CMP X2, XZR // check if head is NULL
    B.EQ is_empty

    CMP X2, X3 // check if head == tail
    B.EQ one_node

    // now has more than 1 node
    LDUR X4, [X2, #8] // X4 = old_head->npx = new_head
    LDUR X5, [X4, #8] // X5 = new_head->npx
    EOR X5, X5, X2 // new_head->npx XOR old_head
    STUR X5, [X4, #8] // set to new_head->npx
    STUR X4, [X0] // *head = new_head 
    B free_node
    
one_node:
    MOVZ X4, #0 // X4 = NULL
    STUR X4, [X0]
    STUR X4, [X1]

free_node:
    SUB SP, SP, #16
    STUR X2, [SP, #0]
    STUR X30, [SP, #8]
    ORR X0, XZR, X2
    BL free
    LDUR X30, [SP, #8]
    ADD SP, SP, #16
    RET

is_empty:
    RET

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

    // x0 = **starting_node
    // x1 = sum
    MOVZ X1, #0
    // x2 = curr = *starting_node
    LDUR X2, [X0]
    // x3 = previous node
    MOVZ X3, #0
    // x4 = next node
    MOVZ X4, #0

loop:
    // while curr != NULL
    CMP X2, XZR
    B.EQ end_loop

    // sum += curr->data
    LDUR X5, [X2] // x5 = curr->data
    ADDS X1, X1, X5
    // next = curr->npx XOR prev
    LDUR X5, [X2, #8]
    EOR X4, X5, X3
    // prev = curr
    ORR X3, X2, XZR
    // curr = next
    ORR X2, X4, XZR
    B loop

end_loop:
    // return sum
    ORR X0, X1, XZR
    RET

    .size   sum_up, .-sum_up
    // ... and ends with the .size above this line.
    