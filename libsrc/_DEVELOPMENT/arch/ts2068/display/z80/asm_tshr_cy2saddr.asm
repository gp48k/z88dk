; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_cy2saddr(uchar row)
;
; Character y coordinate to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cy2saddr

EXTERN asm_zx_cy2saddr

defc asm_tshr_cy2saddr = asm_zx_cy2saddr
