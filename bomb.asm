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

; @param b: Y position of the bomb in the map.
; @param c: X position of the bomb in the map.
; 
; @return a  = $04
; @return bc = bc
; @return de = [explosion_end_map_data] + 16
; @return hl = $0400
;****************************************************************************************************************************************************
BOMB_EXPLODE:
    ld hl, 0 ;h = Counter, l = Range

    call BOMB_CALCULATE_RANGES

    ;Place the center tile of the explosion
    push bc
    call MAP_TO_ADDRESS
    ld de, explosion_center_map_data
    ld b, 2
    ld c, 2
    call TILECPY

    ;Now we can do the tiles for all four directions
    ld hl, 0
.restart:
    pop bc
    ;Check if we're done with all directions (i.e. h == 4)
    ld a, h
    cp $4 
    ret z
    push bc

    ;If the range of the explosion is zero in this direction then there's no need to do it
    ld de, explosionRanges
    ld a, h
    add a, e
    ld e, a
    ld a, [de]
    ld l, a
    cp $0
    jr z, .next
.loop:
    dec l
    call DIRECTION_ADD_OFFSET

    ;Check if we've reached zero range, because if is then it's the last tile
    ;and we need to use a different tile for the direction's end
    ld a, l
    cp $0
    jr z, .last
    call BOMB_EXPLOSION_COPY_TILE
    jr .loop

.last:
    ;Get the address for the direction's end tile by adding d*4 to the end tile map data
    ld de, explosion_end_map_data
    ld a, h
    sla a
    sla a
    add a, e
    ld e, a
    call BOMB_EXPLOSION_COPY_TILE

.next:
    inc h
    jr .restart

BOMB_EXPLOSION_COPY_TILE:
    push hl
    push bc
    push de
    call MAP_TO_ADDRESS
    pop de
    ld b, 2
    ld c, 2
    call TILECPY
    pop bc
    pop hl
    ret

;****************************************************************************************************************************************************
; Calculate how many tiles below the explosion range are empty in a direction.

; @param b: Y position of the bomb in the map.
; @param c: X position of the bomb in the map.
; @param h: Direction (0: Up, 1: Down, 2: Right, 3: Left)
; @param l: Range
; 
; @return a  = $04
; @return bc = bc
; @return de = [explosionRanges]
; @return hl = $0400
;****************************************************************************************************************************************************
BOMB_CALCULATE_RANGES:
    push bc

    ;Check if we're done with all directions (i.e. h == 4)
    ld a, h
    cp $4
    jr nz, .loop 
    pop bc
    ret
.loop:
    ;Check if we've reached the range limit
    ld a, [p_fire_range]
    cp l
    jr z, .next

    inc l
    call DIRECTION_ADD_OFFSET

.continue:
    push hl
    call CHECK_COLLISION
    pop hl
    ;If the next tile is empty then we can continue, otherwise go to next direction
    jr z, .loop
    dec l
.next:
    pop bc
    
    ;Store the range for this direction in the explosionRanges array
    ld de, explosionRanges
    ld a, h
    add a, e
    ld e, a
    ld a, l
    ld [de], a

    ld l, 0
    inc h
    jr BOMB_CALCULATE_RANGES


;****************************************************************************************************************************************************
; Add the direction offset to a position.

; @param b: Y position of the bomb in the map.
; @param c: X position of the bomb in the map.
; @param h: Direction (0: Up, 1: Down, 2: Right, 3: Left)
; 
; @return if h == 0:
;       b = b - 1
;       c = c
; @return if h == 1:
;       b = b + 1
;       c = c
; @return if h == 2:
;       b = b
;       c = c + 1
; @return if h == 3:
;       b = b
;       c = c - 1
;****************************************************************************************************************************************************
DIRECTION_ADD_OFFSET:
    ;Get counter
    ld a, h
    ;Check which direction we're currently doing
    ld de, explosion_v_middle_map_data

    ;Here we add the vertical or horizontal offset (i.e. the range) to the original position
    cp $0
    jr z, .up
    cp $1
    jr z, .down
    ld de, explosion_h_middle_map_data
    cp $2
    jr z, .right
    cp $3
    jr z, .left
    ret

.up:
    dec b
    ret

.down:
    inc b
    ret

.right:
    inc c
    ret

.left:
    dec c
    ret