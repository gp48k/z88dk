; $Id: bit_open_di.asm,v 1.1 2008-12-09 17:48:18 stefano Exp $
;
; Galaksija 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_open_di
    XREF     snd_tick

.bit_open_di
          ld   a,@10111000
          ld   (snd_tick),a
          di
          ret
