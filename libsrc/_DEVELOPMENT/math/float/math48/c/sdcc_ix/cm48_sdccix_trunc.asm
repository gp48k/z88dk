
; float trunc(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_trunc

EXTERN cm48_sdccixp_dx2m48, am48_trunc, cm48_sdccixp_m482d

cm48_sdccix_trunc:

   call cm48_sdccixp_dx2m48
   
   call am48_trunc
   
   jp cm48_sdccixp_m482d