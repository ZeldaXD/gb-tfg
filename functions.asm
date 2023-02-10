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
; Multiply a 8 bit number by 8, this is used to convert to map address

; @param a: Input

; @return a = a * 8
;****************************************************************************************************************************************************

MULTIPLY_BY_8:
    sla a
    sla a
    sla a
    ret

;****************************************************************************************************************************************************
; Check if the next move collides with a wall

; @param a: Next position Y
; @param c: Next position X

; @alters: a, b, c, d, e, hl
;****************************************************************************************************************************************************
CHECK_COLLISION:
    call HITBOX_MAP

    ld c, 0 ;Counter
.check_collision_loop:
    ld b, 0
    ld hl, hitbox_locs
    add hl, bc
    ld d, [hl]
    inc hl
    ld e, [hl]

    ;Add to the address x + (y * 10) to get the tile position in table
    ld a, d
    call MULTIPLY_BY_8
    ld b, e
    srl e
    add a, e
    ld d, 0
    ld e, a
    ld hl, level1_map
    add hl, de 
    ld a, [hl]

    ;Check if X is even or not to see if we have to swap the nibble
    ;This is because one byte encodes 2 tiles
    bit 0, b
    jr nz, .not_swap_nibble
    swap a
.not_swap_nibble:
    and $0F
    cp $0
    ret nz ;If the tile is not empty then we don't need to do the other points
    ;Otherwise, continue with the other points
    ld a, c
    inc c
    cp $4 ;Check if we've done all corners
    jr nz, .check_collision_loop
    ret 

;****************************************************************************************************************************************************
; Calculate the map positions of all hitbox corners

; @param a: Next position Y
; @param c: Next position X

; @return a = a + hitbox_y + hitbox_height
; @return b = 3
; @return c = c + hitbox_x + hitbox_height
; @return d = a
; @return e = c
; @return hl = hitbox_locs + 8
;****************************************************************************************************************************************************
HITBOX_MAP:
    ld b, 0 ;Counter
    ld d, a
    ld e, c
    ld hl, hitbox_locs

.hitbox_map_loop:
    add a, p_hitbox_Y
    call POSITION_GET
    ld [hl+], a

    ld a, c
    add a, p_hitbox_X
    call POSITION_GET
    ld [hl+], a
    ld a, b
    inc b
    cp $0
    jr z, .top_right
    cp $1
    jr z, .bottom_left
    cp $2
    jr z, .bottom_right
    ret

.top_right:
    ld a, e
    add a, p_hitbox_width
    ld c, a
    ld a, d
    jr .hitbox_map_loop
.bottom_left:
    ld a, d
    add a, p_hitbox_height
    ld c, e
    jr .hitbox_map_loop
.bottom_right:
    ld a, e
    add a, p_hitbox_width
    ld c, a
    ld a, d
    add a, p_hitbox_height
    jr .hitbox_map_loop

;****************************************************************************************************************************************************
; Determine the min and max value between two numbers

; @param a: First 8 bit number
; @param b: Second 8 bit number

; @return a = max(a,b)
; @return b = min(a,b)
; @return c = a
;****************************************************************************************************************************************************

MATH_MINMAX:
    cp b
    ;a-b, if a > b then c=0, a is the maximum and we can return
    ret nc
    ;Otherwise, swap a and b
    ld c, a
    ld a, b
    ld b, c
    ret