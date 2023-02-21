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