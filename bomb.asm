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

;b Y position
;c X position
CREATE_EXPLOSION:
    POSITION_GET b
    POSITION_GET c

    ld d, 0 ;Counter
    ld e, 0 ;Range
    ld h, b ;Original y
    ld l, c ;Original x

.create_explosion_loop:
    inc e
    call ADD_OFFSET
    ret z ;If the z flag is 1, then all directions have been checked
 
    push hl
    call CHECK_COLLISION
    pop hl
    jr nz, .next
    
    push hl
    push de
    call MAP_TO_ADDRESS
    ld de, explosion_map_data
    ld b, 2
    ld c, 2
    call TILECPY
    pop de
    pop hl
    
    ld a, e
    cp a, p_fire_range
    jr nz, .create_explosion_loop
.next:
    inc d
    ld e, 0
    jr .create_explosion_loop


;
;
ADD_OFFSET:
    ld b, h
    ld c, l

    ld a, d
    cp $0
    jr z, .up
    cp $1
    jr z, .down
    cp $2
    jr z, .right
    cp $3
    jr z, .left
.return:
    ld a, d
    cp $4 ;Check if we're done with all directions
    ret

.up:
    ld a, b
    sub a, e
    ld b, a
    jr .return

.down:
    ld a, b
    add a, e
    ld b, a
    jr .return

.right:
    ld a, c
    sub a, e
    ld c, a
    jr .return

.left:
    ld a, c
    add a, e
    ld c, a
    jr .return