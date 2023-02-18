SECTION "Hole", ROM0

;Decide if we can place a hole
HOLE_EVENT_CHECK:
    ld a, [holesCount]
    cp HOLES_NUMBER_LIMIT
    ret z
    call HOLE_PLACE
    ret 

HOLE_PLACE:
    ;Generate random number in bc
    ;b will be the y value, c will be the x value
    call rand 
    ;Get their tile positions in the map
    POSITION_GET b
    POSITION_GET c
    ;Get the tile from that position
    call TILE_GET
    ld d, a
    and $0F ;Apply mask
    cp TILES_EMPTY_ID ;Check if it's empty
    ;If it's not then generate another position
    jr nz, HOLE_PLACE
    ;If it is, then place a hole there and increase the counter
    ld a, d
    and $F0
    or TILES_HOLE_ID
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a
    ld hl, holes_array
    ld d, 0
    ld a, [holesCount]
    ld e, a
    inc a
    ld [holesCount], a ;Increase counter
    ;Add to array
    add hl, de
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ;Finally, load the tile into the screen
    call MAP_TO_ADDRESS
    ld de, hole_map_data
    ld b, hole_tile_height
    ld c, hole_tile_width
    call TILECPY
    ret
