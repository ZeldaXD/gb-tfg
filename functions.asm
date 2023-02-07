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

; @return a = a // 16
;****************************************************************************************************************************************************

POSITION_GET:
    srl a
    srl a
    srl a
    srl a
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

; @param a: Next position Y
; @param c: Next position X

;
;
;****************************************************************************************************************************************************

CHECK_COLLISION:
    ld d, a
    ld e, c

    xor a ;Counter
    ld [collisionCounter], a

    ld a, c
    add p_hitbox_X
    ld c, a
    ld a, d
    add p_hitbox_Y

.check_collision_loop:
    ld b, a
    ld a, c
    call POSITION_GET ;Pixel position X to map
    ld c, a
    xor a
    ld [swapTileByte], a
    bit 0, c
    jr z, .odd
    inc a
    ld [swapTileByte], a
.odd
    ld a, b
    call POSITION_GET ;Pixel position Y to map

    ld hl, level1_map
    ld b, 0
    srl c
    add hl, bc
    call MULTIPLY_BY_10
    ld c, a
    ld b, 0
    add hl, bc
    ld a, [swapTileByte]
    ld c, a
    ld a, [hl]
    bit 0, c
    jr nz, .not_swap_byte
    swap a
.not_swap_byte:
    and $0F
    cp $0
    jr z, .empty ;If the tile is empty then do the next point
    ret ;Otherwise, return movement is blocked
.empty:
    ld a, [collisionCounter]
    inc a
    ld [collisionCounter], a
    cp $1
    jr z, .top_right
    cp $2
    jr z, .bottom_left
    cp $3
    jr z, .bottom_right
    cp $4
    ret
.top_right:
    ; X = X + WIDTH
    ; Y = Y
    ld a, d
    ld c, e
    ld a, c
    add p_hitbox_X + p_hitbox_width
    ld c, a
    ld a, d
    add p_hitbox_Y
    jr .check_collision_loop
.bottom_left:
    ; X = X
    ; Y = Y + HEIGHT
    ld a, d
    ld c, e
    ld a, c
    add p_hitbox_X
    ld c, a
    ld a, d
    add p_hitbox_Y + p_hitbox_height
    jr .check_collision_loop
.bottom_right:
    ; X = X + WIDTH
    ; Y = Y + HEIGHT
    ld a, d
    ld c, e
    ld a, c
    add p_hitbox_X + p_hitbox_width
    ld c, a
    ld a, d
    add p_hitbox_Y + p_hitbox_height
    jr .check_collision_loop