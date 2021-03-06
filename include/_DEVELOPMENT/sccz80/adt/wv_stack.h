
// automatically generated by m4 from headers in proto subdir


#ifndef _ADT_WV_STACK_H
#define _ADT_WV_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct wv_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} wv_stack_t;

extern size_t __LIB__ __FASTCALL__ wv_stack_capacity(wv_stack_t *s) __smallc;


extern void __LIB__ __FASTCALL__ wv_stack_clear(wv_stack_t *s) __smallc;


extern void __LIB__ __FASTCALL__ wv_stack_destroy(wv_stack_t *s) __smallc;


extern int __LIB__ __FASTCALL__ wv_stack_empty(wv_stack_t *s) __smallc;


extern wv_stack_t __LIB__ *wv_stack_init(void *p,size_t capacity,size_t max_size) __smallc;
extern wv_stack_t __LIB__ __CALLEE__ *wv_stack_init_callee(void *p,size_t capacity,size_t max_size) __smallc;
#define wv_stack_init(a,b,c) wv_stack_init_callee(a,b,c)


extern size_t __LIB__ __FASTCALL__ wv_stack_max_size(wv_stack_t *s) __smallc;


extern void __LIB__ __FASTCALL__ *wv_stack_pop(wv_stack_t *s) __smallc;


extern int __LIB__ wv_stack_push(wv_stack_t *s,void *item) __smallc;
extern int __LIB__ __CALLEE__ wv_stack_push_callee(wv_stack_t *s,void *item) __smallc;
#define wv_stack_push(a,b) wv_stack_push_callee(a,b)


extern int __LIB__ wv_stack_reserve(wv_stack_t *s,size_t n) __smallc;
extern int __LIB__ __CALLEE__ wv_stack_reserve_callee(wv_stack_t *s,size_t n) __smallc;
#define wv_stack_reserve(a,b) wv_stack_reserve_callee(a,b)


extern int __LIB__ __FASTCALL__ wv_stack_shrink_to_fit(wv_stack_t *s) __smallc;


extern size_t __LIB__ __FASTCALL__ wv_stack_size(wv_stack_t *s) __smallc;


extern void __LIB__ __FASTCALL__ *wv_stack_top(wv_stack_t *s) __smallc;



#endif
