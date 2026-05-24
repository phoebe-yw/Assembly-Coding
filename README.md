# AC Lab - Assembly Coding

Eight functions implemented in **chArm-v5** assembly as part of CS 429 (Computer Architecture) at UT Austin. chArm-v5 is a 25-instruction subset of the A64 (AArch64) instruction set. All code runs on an Arm64/Linux virtual machine on AWS EC2.

## Overview

The only file submitted is `functions.s`, which contains eight hand-written assembly functions covering bit manipulation, Unicode encoding, struct comparison, recursive tree traversal, and XOR linked list operations.

## Functions Implemented

### Week 1

| Function | Description |
|---|---|
| `lru` | Straight-line bit manipulation — updates an 8x8 bit matrix to track LRU cache usage and returns the index of the least recently used item |
| `unicode_to_UTF8` | Encodes a Unicode code point into its UTF-8 byte representation (1–4 bytes); sets all bytes to `0xFF` for invalid code points |
| `UTF8_to_unicode` | Decodes a UTF-8 byte sequence back to its Unicode code point, handling all four byte-length cases |
| `compare` | Compares two `concert_ticket_t` structs field by field using struct padding offsets and bit masking; returns 0 if equal, 1 otherwise |

### Week 2

| Function | Description |
|---|---|
| `tree_depth` | Recursively computes the depth of a binary tree using `BL` for self-recursive calls; returns 0 for a null root |
| `insert_at_head` | Inserts a new node at the head of an XOR linked list; calls `malloc` via `BL` and updates XOR-combined `npx` pointers |
| `del_at_head` | Removes the head node of an XOR linked list; calls `free` via `BL` and repairs the new head's `npx` pointer |
| `sum_up` | Iteratively traverses an XOR linked list from any starting node and returns the sum of all `data` fields |

## chArm-v5 Instruction Set Used

| Category | Instructions |
|---|---|
| Data transfer | `LDUR`, `STUR` |
| Immediate | `MOVZ`, `MOVK`, `ADRP` |
| Computation | `ADD`, `ADDS`, `SUB`, `SUBS`, `CMP`, `CMN`, `MVN`, `ORR`, `EOR`, `ANDS`, `TST`, `LSL`, `LSR`, `ASR`, `UBFM` |
| Control | `B`, `B.cond`, `BL`, `RET` |
| Misc | `NOP`, `HLT` |

All registers used are 64-bit `X` registers — `W` registers are not part of chArm-v5.

## Key Data Structures

**`concert_ticket_t`** (48 bytes with AArch64 padding):
```c
typedef struct concert_ticket {
    unsigned long unique_id;              // offset 0,  8 bytes
    char seat_code[3];                    // offset 8,  3 bytes + 5 bytes padding
    double price;                         // offset 16, 8 bytes
    bool special_admission;               // offset 24, 1 byte  + 7 bytes padding
    struct concert_ticket *recommendations; // offset 32, 8 bytes
    bool refundable;                      // offset 40, 1 byte  + 7 bytes padding
} concert_ticket_t;
```

**`node_t`** — binary tree node with `left`, `right` pointers and `uint64_t data`.

**`linked_node_t`** — XOR linked list node where `npx = prev XOR next`, allowing bidirectional traversal with a single pointer field.

## XOR Linked List

Each node stores `npx = prev ^ next` instead of two separate pointers. To traverse:
- Start from the head (where `npx == next` since `prev == NULL`)
- At each step: `next = npx ^ prev_address`
- Continue until `next == NULL`

This allows both forward and backward traversal using only one pointer per node.

## Building and Running

Compilation and execution must be done on an AWS EC2 Arm64/Linux VM.

```bash
# Build the test executable
make

# Run all tests
./ac_lab

# Run a specific function's tests
./ac_lab -f lru
./ac_lab -f unicode_to_UTF8
./ac_lab -f tree_depth

# Verify only chArm-v5 instructions are used
make verify
```

## Tools Used

- **GCC** (AArch64 cross-compiler on AWS EC2)
- **GDB** for runtime debugging on ARM
- **Gradescope** autograder for correctness scoring