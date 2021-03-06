
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_bitmask2px(uchar bitmask)
;
; Return x coordinate 0-7 corresponding to bitmask.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_bitmask2px

asm_zx_bitmask2px:

   ; enter :  l = 8-bit bitmask
   ;
   ; exit  :  l = x coordinate corresponding to leftmost set bit
   ;
   ; uses  : af, l
   
   ld a,l
   ld l,0
   
   or a
   ret z
   
   dec l
   
loop:

   inc l
   add a,a
   jp nc, loop
   
   ret
