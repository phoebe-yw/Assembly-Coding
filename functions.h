/**************************************************************************
 * C S 429 Assembly Coding Lab
 *
 * testbench.c - Testbench for all the assembly functions.
 *
 * Copyright (c) 2022, 2023, 2024.
 * Authors: Anoop Rachakonda, Kavya Rathod, Prithvi Jamadagni
 * All rights reserved.
 * May not be used, modified, or copied without permission.
 **************************************************************************/

#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>


/**
 * A struct representing a student. The various fields
 * will be compared in the compare() function.
 */
typedef struct concert_ticket {
  unsigned long unique_id;      // 1
  char seat_code[3];            // 2
  double price;                 // 3
  bool special_admission;       // 4
  struct concert_ticket *recommendations;          // 5
  bool refundable;              // 6
} concert_ticket_t;

/**
 * A struct that represents a node of a binary tree.
 * It contains pointers to its 2 children and 1 piece of data.
 */
typedef struct tree_node {
  struct tree_node *left, *right;
  uint64_t data;
} node_t;

/**
 * A struct that represents a node of a linked list.
 * It contains an npx pointer to both its previous and next,
 * as well as 1 piece of data.
 */
typedef struct linked_list_node {
    unsigned long data;
    struct linked_list_node* npx; /* XOR of next and previous node */
} linked_node_t;

// Week 1:

/**
 * lru function
 * 
 * Given a uint64_t access and a uint64_t* cache_matrix, perform an access.
 * Then return the least recently used cache line.
 * 
 * @param access is the cache line to access
 * @param cache_matrix points to the cache matrix to be modified
 * @return the least recently used line
 */
uint64_t lru(const uint64_t access, uint64_t* cache_matrix);

/**
 * UTF8 to unicode function
 * 
 * Returns the Unicode codepoint of a UTF-8 encoding stored in utf8.
 * May be a four byte, three byte, two byte, or one byte long encoding.
 * There is no need to check for any error conditions.
 *
 * @param utf8 is the char array containing the UTF-8 encoding.
 * @return the Unicode codepoint of the given encoding.
 */
uint64_t UTF8_to_unicode(const char utf8[4]);

/**
 * unicode to UTF8 function
 * 
 * Converts given Unicode codepoint a into a valid UTF-8 encoding, stored in utf8.
 * May be a four byte, three byte, two byte, or one byte long encoding.
 * If a falls outside the valid Unicode codespace, all elements of utf8 must be 0xFF.
 *
 * @param a is the Unicode codepoint to convert.
 * @param utf8 is the array in which to store the UTF8 value.
 * This function does not return any value.
 */
void unicode_to_UTF8(const uint64_t a, char utf8[4]);

/**
 * compare function
 * 
 * Given two pointers to concert_ticket_t structs, perform a field-by-field
 * comparison and return 0 if the two structs have the same field values.
 *
 * Compare characters, ints via numerical comparison.
 * Compare floats as raw binary strings, disregarding their numerical value.
 * Compare pointers by seeing if they point to the same memory location.
 * 
 * @param a a pointer to the first struct to compare
 * @param b a pointer to the second struct to compare
 * @return a uint64_t representing the ordinal position of the first field
 *          that the two structs differ. For example if the structs first
 *          differ in the "gpa" field, return 3.
 */
uint64_t compare(concert_ticket_t *a, concert_ticket_t *b);

// Week 2:

/**
 * tree_depth function
 * 
 * Given a pointer to the root of a binary tree, return the depth of the tree.
 * The tree is not necessarily complete or balanced.
 * A tree with only 1 node (the root) has depth 1.
 * This function must use recursion.
 *
 * @param root a pointer to the root node of the tree.
 * @return the depth of the tree.
 */
uint64_t tree_depth(node_t *root);

/**
 * insert_at_head function
 * 
 * Given a pointer to the head of a linked list, the tail of a linked list, and the corresponding data,
 * add a new node to the front.
 * You must call malloc in your implementation.
 * 
 * @param head_ref is the node that must be updated
 * @param data is the data corresponding to the new head
 * @param tail is the node that may be updated, depending on if certain conditions are met
 * This function does not return any value.
 */
void insert_at_head(linked_node_t **head_ref, unsigned long data, linked_node_t** tail_ref);

/**
 * del_at_head function
 * 
 * Given pointers to both the head and tail of a linked list,
 * delete the node at the front.
 * You must call free in your implementation.
 * 
 * @param head_ref is the node that must be updated
 * @param tail is the node that may be updated, depending on if certain conditions are met
 * This function does not return any value.
 */
void del_at_head(linked_node_t **head_ref, linked_node_t **tail_ref);

/**
 * sum_up function
 * 
 * Given the the starting node of a linked list,
 * sum up all of its elements.
 * This MUST work regardless of whether the head or tail is passed in.
 * 
 * @param starting_node may either be the head or tail of the linked list
 * @return a uint64_t representing the values of the linked list summed together.
 */
uint64_t sum_up(linked_node_t **starting_node);


#endif
