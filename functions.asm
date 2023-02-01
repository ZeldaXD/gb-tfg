SECTION "Functions", ROM0

;****************************************************************************************************************************************************
; Copy memory from one source to a destination.

; @param hl: Address memory destination
; @param de: Memory source to copy
; @param bc: Size of memory (counter)

; @return a = $00
; @return bc = $0000
; @return de = de
; @return hl = hl + bc
;****************************************************************************************************************************************************
MEMCPY:
    ld a, [de]
    inc de
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, MEMCPY
    ret 

;****************************************************************************************************************************************************
; Clear the memory (set to 0) of a destination

; @param hl: Address memory destination
; @param bc: Size of memory (counter)

; @return hl = hl + bc
; @return bc = 0
;****************************************************************************************************************************************************
MEMCLEAR:
    xor a
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, MEMCLEAR
    ret 