; struct sp1_ss __CALLEE__ *sp1_CreateSpr_callee(void *drawf, uchar type, uchar height, int graphic, uchar plane)
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res version

PUBLIC sp1_CreateSpr_callee
PUBLIC ASMDISP_SP1_CREATESPR_CALLEE

EXTERN _sp1_struct_ss_prototype, _sp1_struct_cs_prototype
EXTERN _u_malloc, _u_free, SP1V_TEMP_AF, SP1V_TEMP_IX

.sp1_CreateSpr_callee

   pop ix
   pop bc
   pop hl
   pop de
   ld a,e
   pop de
   ld b,e
   pop de
   push ix
   
.asmentry

; Create sprite of given height one column wide.  Further columns are
; added with successive calls to SP1AddColSpr.
;
; enter :  a = height in chars
;          b = type: bit 7 = 1 occluding, bit 6 = 1 2 byte definition, bit 4 = 1 clear pixelbuff
;          c = plane sprite occupies (0 = closest to viewer)
;         de = address of draw function
;         hl = graphic definition for column
; uses  : all except af',iy
; exit  : no carry and hl=0 if memory allocation failed else hl = struct sp1_ss * and carry set

.SP1CreateSpr

   ld (SP1V_TEMP_AF + 1),a     ; a = a' = height  
   exx

   ld hl,0                    ; first try to get all the memory we need
   push hl                    ; push a 0 on stack to indicate end of allocated memory blocks
   ld b,a                     ; b = height

.csalloc

   push bc                    ; save height counter
   ld hl,22                   ; sizeof(struct sp1_cs)
   push hl
   call _u_malloc
   pop bc
   jp nc, fail
   pop bc
   push hl                    ; stack allocated block
   djnz csalloc

   ld hl,20                   ; sizeof(struct sp1_ss)
   push hl
   call _u_malloc
   pop bc
   jp nc, fail
   push hl
   
   exx
   ex (sp),hl                 ; stack = graphic pointer
   push de                    ; save de = draw function
   push bc                    ; save b = type, c = plane

   ; have all necessary memory blocks on stack, hl = & struct sp1_ss

   ld de,_sp1_struct_ss_prototype
   ex de,hl                   ; hl = & struct sp1_ss prototype, de = & new struct sp1_ss
   ld ixl,e
   ld ixh,d                   ; ix = & struct sp1_ss
   ld bc,20                   ; sizeof(struct sp1_ss)
   ldir                       ; copy prototype into new struct
   
   ; have copied prototype struct sp1_ss, now fill in the rest of the details
   
   ld a,(SP1V_TEMP_AF + 1)    ; a = height
   ld (ix+3),a                ; store height
   
   pop bc                     ; b = type, c = plane
   bit 6,b
   jr z, onebyte
   set 7,(ix+4)               ; indicate 2-byte definition

.onebyte

   ld a,b                     ; a = type
   and $90
   or $40                     ; a = type entry for struct sp1_cs
   
   pop de                     ; de = draw function
   pop hl
   ex (sp),hl                 ; stack = graphics ptr, hl = & first struct sp1_cs
   push de                    ; save draw function
   
   ld (ix+15),h               ; store ptr to first struct sp1_cs in struct sp1_ss
   ld (ix+16),l
   
   ld (SP1V_TEMP_IX),ix       ; struct sp1_ss now in SP1V_TEMP_IX
   
   ; done with struct sp1_ss, now do first struct sp1_cs
   
   ld de,_sp1_struct_cs_prototype
   ex de,hl                   ; hl = & struct sp1_cs prototype, de = & new struct sp1_cs
   ld ixl,e
   ld ixh,d                   ; ix = & struct sp1_cs
   push bc                    ; save c = plane
   ld bc,22                   ; sizeof(struct sp1_cs)
   ldir                       ; copy prototype into new struct
   pop bc                     ; c = plane
   
   ; have copied prototype struct sp1_cs, now fill in the rest of the details
   
   ld (ix+4),c                ; store plane
   ld (ix+5),a                ; store type

   ld e,ixl
   ld d,ixh
   ld hl,8
   add hl,de
   ex de,hl                   ; de = & struct sp1_cs.draw_code (& embedded code in struct sp1_cs)
 
   pop bc                     ; bc = draw function
   ld hl,-10
   add hl,bc                  ; hl = embedded draw function code
   ld bc,10                   ; length of draw code
   ldir                       ; copy draw code into struct sp1_cs

   ld a,(SP1V_TEMP_IX)
   add a,8
   ld (ix+6),a                ; store & struct sp1_ss + 8 (& embedded code in struct sp1_ss)
   ld a,(SP1V_TEMP_IX + 1)
   adc a,0
   ld (ix+7),a
   
   pop hl                     ; hl = graphics ptr
   ld (ix+9),l                ; store graphics ptr
   ld (ix+10),h

.loop

   ; (SP1_TEMP_IX) = struct sp1_ss, ix = last struct sp1_cs added to sprite

   pop hl                     ; hl = & next struct sp1_cs to add

   ld a,h
   or l
   jr z, done
   
   push hl

   ld (ix+0),h                ; store ptr to next struct sp1_cs
   ld (ix+1),l

   ld e,ixl
   ld d,ixh
   ex de,hl                   ; hl = last struct sp1_cs, de = new struct sp1_cs
   ld bc,22                   ; sizeof(struct sp1_cs)
   ldir                       ; make copy of last one into new one

   ld e,(ix+9)
   ld d,(ix+10)               ; de = graphics ptr from last struct sp1_cs

   pop ix                     ; ix = new struct sp1_cs

   ld (ix+0),c                ; place 0 into struct sp1_cs.next_in_spr to indicate
   ld (ix+1),c                ;  this is currently last struct sp1_cs in sprite

   ld hl,(SP1V_TEMP_IX)       ; hl = struct sp1_ss *
   ld bc,4
   add hl,bc
   bit 7,(hl)
   ld hl,8                    ; offset to next character in sprite graphic def
   jr z, onebyte2
   ld l,16                    ; if 2-byte def, offset is 16 bytes
   
.onebyte2

   add hl,de
   ld (ix+9),l                ; store correct graphics ptr for this struct sp1_cs
   ld (ix+10),h
   
   jp loop

.done

   set 5,(ix+5)               ; indicate last struct sp1_cs added is in the last row of sprite
   ld hl,(SP1V_TEMP_IX)       ; hl = struct sp1_ss *
   scf                        ; indicate success
   ret

.fail

   pop bc
   
.faillp

   pop hl                     ; hl = allocated memory block
   
   ld a,h
   or l
   ret z                      ; if 0 done freeing, ret with nc for failure
   
   push hl
   call _u_free               ; free the block
   pop hl
   jp faillp

DEFC ASMDISP_SP1_CREATESPR_CALLEE = # asmentry - sp1_CreateSpr_callee
