SECTION "Player", ROM0
;****************************************************************************************************************************************************
;@param Y
;@param X
;@param Tile_ID
;@param Attributes
;****************************************************************************************************************************************************
PLAYER_LOAD:
    ld hl, shadowOAM ;Set stack to point at the OAM
    ld a, [pY]
    ld [hl+], a ;Y
    ld a, [pX]
    ld [hl+], a ;X
    ld a, 0
    ld [hl+], a ;Tile ID
    ld [hl+], a ;Attributes

    ld a, [pY]
    ld [hl+], a ;Y
    ld a, [pX]
    add a, 8
    ld [hl+], a ;X
    ld a, 2
    ld [hl+], a ;Tile ID
    ld [hl+], a ;Attributes
    ret
    
PLAYER_UPDATE:
    ld a, [pY]
    ld [shadowOAM], a ;Y
    ld [shadowOAM + 4], a ;Y

    call POSITION_GET ;Calculate Y pos in map
    ld a, b
    ld [map_pY], a

    ld a, [pX]
    ld [shadowOAM + 1], a ;X
    add a, 8
    ld [shadowOAM + 4 + 1], a

    call POSITION_GET ;Calculate X pos in map
    ld a, b
    ld [map_pX], a
    ret