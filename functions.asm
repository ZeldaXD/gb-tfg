SECTION "Functions", ROM0

;****************************************************************************************************************************************************
; Copy memory from one source to a destination.

; @param hl: Address memory destination
; @param de: Memory source to copy
; @param bc: Size of memory (counter)

; @return hl = hl + bc
; @return de = de
; @return bc = $0000
; @return a = $00

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
; Copy memory from one source to a destination with a height and width.

; @param hl: Address memory destination
; @param de: Memory source to copy
; @param b: Height of tiles to copy (MAX: $FF)
; @param c: Width of tiles to copy (MAX: $FF)

; @return hl = hl + (b * scrn_vx_b) + c
; @return de = de + b + c
; @return bc = $0000
; @return a = $00
;****************************************************************************************************************************************************
TILECPY:
    push bc
.tilecpy_loop:
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    ld a, c
    ;Check if we're done with the width
    cp $0
    jr nz, .tilecpy_loop
    pop bc
    dec b
    ld a, b
    ;Check if we're done with the height
    cp $0
    ret z ;If we are, then return
    ;Otherwise, go to the next line of the screen
    push bc
    ld a, SCRN_VX_B
    sub a, c
    ld b, 0
    ld c, a
    add hl, bc
    pop bc
    push bc
    jr .tilecpy_loop

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

; @param r: Position in the map

; @return r = r // 16
;****************************************************************************************************************************************************

MACRO POSITION_GET
    srl \1
    srl \1
    srl \1
    srl \1
ENDM

;****************************************************************************************************************************************************
; Multiply a 8 bit number by 8, this is used to convert to map address

; @param r: Input

; @return r = a * 8
;****************************************************************************************************************************************************

MACRO MULTIPLY_BY_8
    sla \1
    sla \1
    sla \1
ENDM

;****************************************************************************************************************************************************
; Multiply a 8 bit number by 8, this is used to convert to map address

; @param b: Y position in map
; @param c: X position in map

; @return a = if x % 2 == 0 swap(map[y, x]) else map[y,x]
; @return hl = [level_map] + (b * 8) + c
;****************************************************************************************************************************************************
TILE_GET:
    push bc
    ld a, b
    MULTIPLY_BY_8 a ;a = b * 8
    srl c
    add a, c ;a = a + c, thus a = (b * 8) + c = (y * 8) + x
    ld hl, level_map
    ;Add to the address (y * 8) + x to get the tile position in table
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [hl]
    pop bc

    ;Check if X is even or not to see if we have to swap the nibble
    ;This is because one byte encodes 2 tiles
    bit 0, c
    ret nz
    swap a
    ret

;****************************************************************************************************************************************************
; Check if the next move collides with a wall

; @param b: Next position Y
; @param c: Next position X

; @return @return a = map[y, x] & $0F
; @return hl = [level_map] + (b * 8) + c
; @return z = 1 if map[y, x] == 0
;****************************************************************************************************************************************************
CHECK_COLLISION:
    ;Get the tile in the map from these positions
    call TILE_GET

    and $0F
    cp TILES_EMPTY_ID
    ;If the tile is not empty then it will return nz
    ret

;****************************************************************************************************************************************************
; Calculate the map positions of all hitbox corners

; @param b: Next position Y
; @param c: Next position X
; @param hl: Hitbox map storage address

; @return a = 3
; @return b = b + hitbox_height
; @return d = 3
; @return hl = hl + 8
;****************************************************************************************************************************************************
HITBOX_MAP:
    ld d, 0 ;Counter
    ;We need to know which corner we're currently checking

.hitbox_map_loop:
    ld a, b
    add a, p_hitbox_Y
    POSITION_GET a
    ld [hl+], a

    ld a, c
    add a, p_hitbox_X
    POSITION_GET a
    ld [hl+], a
    ld a, d
    inc d
    cp $0
    jr z, .top_right
    cp $1
    jr z, .bottom_right
    cp $2
    jr z, .bottom_left
    ret

;Add the width and height of the hitbox depending on the corner we're checking
.top_right:
    ld a, c
    add a, p_hitbox_width
    ld c, a
    jr .hitbox_map_loop
.bottom_right:
    ld a, b
    add a, p_hitbox_height
    ld b, a
    jr .hitbox_map_loop
.bottom_left:
    ld a, c
    sub a, p_hitbox_width
    ld c, a
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

;****************************************************************************************************************************************************
; Check if we're crossing the boundary between two tiles, and if we are then check the collision

; @param a: First 8 bit number
; @param b: Second 8 bit number

; @alters: a, b, c, d, e, hl
; @return z = 1 if map[y, x] == 0 || e == 4
;****************************************************************************************************************************************************
CHECK_BOUNDARY:
    ld hl, hitbox_locs
    ;Create the hitbox map for the next position
    call HITBOX_MAP

    ld a, [pX]
    ld c, a
    ld a, [pY]
    ld b, a
    ld hl, current_hitbox_locs
    ;Create the hitbox map for the current position
    call HITBOX_MAP

    ld d, 0
    ld e, 0 ;Counter
    ;Load both hitbox maps to compare
.check_loop:
    ld hl, hitbox_locs
    add hl, de
    ld b, [hl]
    inc hl
    ld c, [hl]
    inc hl
    
    ld hl, current_hitbox_locs
    add hl, de
    inc e
    inc e
    ld a, [hl+]
    ;Check if current_y[i] = next_y[i]
    cp b
    jr nz, .crossed_boundary
    ld a, [hl+]
    ;Check if current_x[i] = next_x[i]
    cp c
    jr nz, .crossed_boundary
.return:
    ld a, e
    cp 4*2 ;Total amount of memory addresses to check
    ;4*2, because we have 2 positions (y,x) and 4 corners for hitboxes
    jr nz, .check_loop
    ret
.crossed_boundary:
    push de
    call CHECK_COLLISION
    pop de
    ;If it's not empty then we can stop, otherwise check the other points
    ret nz
    jr .return
