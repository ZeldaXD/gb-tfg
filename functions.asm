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

;****************************************************************************************************************************************************
; Convert the position in the array map to the pixel position

; @param a: Position in the map

; @return a = a % 8
; @return b = a // 8
;****************************************************************************************************************************************************

POSITION_GET:
    ld b, 0 ;Counter
.position_get_loop:
    cp 16
    jr c, .done
    sub 8
    inc b
    jr .position_get_loop
.done:
    ret

;****************************************************************************************************************************************************
; Multiply a 8 bit number by 7, this is used to convert to map address

; @param a: Input

; @return a = a * 20
; @return b = a
;****************************************************************************************************************************************************

MULTIPLY_BY_10:
    sla a
    ld b, a
    sla a
    sla a
    add a, b
    ret

;****************************************************************************************************************************************************
; Check if the next move collides with a wall

; @param d: Next position Y
; @param e: Next position X

;
;
;****************************************************************************************************************************************************

CHECK_COLLISION:
    ld hl, level1_map
    ld a, d
    call MULTIPLY_BY_10
    ld c, e
    sra e
    add a, e
    ld e, a
    ld d, 0
    add hl, de
    ld a, [hl]
    bit 0, c
    jr nz, .even
    swap a
.even:
    and $0F
    cp $0
    ret 