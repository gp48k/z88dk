
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memccpy_callee

EXTERN asm_memccpy

memccpy_callee:

   pop ix
   pop bc
   pop de
   ld a,e
   pop hl
   pop de
   push ix

   jp asm_memccpy
