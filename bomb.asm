SECTION "Bomb", ROM0

;****************************************************************************************************************************************************
; Place bomb in a position of the map.

; @param b: Y position of the bomb
; @param c: X position of the bomb
;****************************************************************************************************************************************************
BOMB_PLACE:
    POSITION_GET b
    POSITION_GET c

    call TILE_GET
    and $F0
    or TILES_BOMB_ID
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a

    call MAP_TO_ADDRESS
    ld de, bomb_map_data
    ld b, bomb_tile_height
    ld c, bomb_tile_width
    call TILECPY
    ret

;****************************************************************************************************************************************************
; Explode a bomb in all directions given its position.

; @param b: Y position of the bomb
; @param c: X position of the bomb
; 
; @return b = b
; @return c = c - range
; @return d = 4
; @return e = range
; @return h = b
; @return l = c
;****************************************************************************************************************************************************
BOMB_EXPLODE:
    POSITION_GET b
    POSITION_GET c

    push bc
    call MAP_TO_ADDRESS
    ld de, explosion_center_map_data
    ld b, 2
    ld c, 2
    call TILECPY
    pop bc

    ld h, 0 ;High = Counter, Low = Range
    ld a, b ;High = Original Y, Low = Original X
    swap a
    ld l, c
    or l
    ld l, a

.create_explosion_loop:
    inc h
    call DIRECTION_ADD_OFFSET
    ret z ;If the z flag is 1, then all directions have been checked
 
    push hl
    call CHECK_COLLISION
    pop hl
    ;If the next tile is empty then we can continue, otherwise go to next direction
    jr z, .continue
    dec h
    jr .next
.continue:
    ;Check if it's the last tile of the range
    ld a, [p_fire_range]
    sub a, h
    and $0F
    cp $0
    jr z, .next

    ;Copy the explosion tiles to the map in that position
    push bc
    push hl
    push de
    call MAP_TO_ADDRESS
    pop de
    ld b, 2
    ld c, 2
    call TILECPY
    pop hl
    pop bc
    jr .create_explosion_loop

.next:
    call DIRECTION_IS_LAST
    ld a, h
    and $F0
    swap a
    inc a
    swap a
    ld h, a
    jr .create_explosion_loop


;****************************************************************************************************************************************************
; Add the direction offset to a position.

; @param h: Y position of the bomb
; @param l: X position of the bomb
; @param d: Direction (0: Up, 1: Down, 2: Right, 3: Left)
; @param e: Offset (i.e. range)
; 
; @return b = h + range if d == 0 or d == 1
; @return c = l + range if d == 2 or d == 3
;****************************************************************************************************************************************************
DIRECTION_ADD_OFFSET:
    ;Get range
    ld a, h
    and $0F
    ld d, a

    ;Set the original Y
    ld a, l
    and $F0
    swap a
    ld b, a
    ;Set the original X
    ld a, l
    and $0F
    ld c, a

    ;Get counter
    ld a, h
    and $F0
    swap a
    ;Check which direction we're currently doing
    cp $0
    jr z, .up
    cp $1
    jr z, .down
    cp $2
    jr z, .right
    cp $3
    jr z, .left
.return:
    ld a, h
    and $F0
    swap a
    cp $3 + $1 ;Check if we're done with all directions
    ret

;Here we add the vertical or horizontal offset (i.e. the range) to the original position
.up:
    ld a, b
    sub a, d
    ld b, a
    ld de, explosion_v_middle_map_data
    jr .return

.down:
    ld a, b
    add a, d
    ld b, a
    ld de, explosion_v_middle_map_data
    jr .return

.right:
    ld a, c
    add a, d
    ld c, a
    ld de, explosion_h_middle_map_data
    jr .return

.left:
    ld a, c
    sub a, d
    ld c, a
    ld de, explosion_h_middle_map_data
    jr .return


;
;
DIRECTION_IS_LAST:
    ;Get range
    ld a, h
    and $0F
    cp $0
    ret z

    call DIRECTION_ADD_OFFSET

    push hl
    ld de, explosion_end_map_data
    ld a, h
    and $F0
    swap a
    sla a
    sla a
    add a, e
    ld e, a

    push de
    call MAP_TO_ADDRESS
    pop de
    ld b, 2
    ld c, 2
    call TILECPY
    pop hl
    ret