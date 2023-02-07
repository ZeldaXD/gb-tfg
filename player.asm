SECTION "Player", ROM0
;****************************************************************************************************************************************************
;@param Y
;@param X
;@param Tile_ID
;@param Attributes
;****************************************************************************************************************************************************

; top-left: x + 4, y + 4
; bottom-right: x + 12, y + 16
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
    add a, 16
    ld [shadowOAM], a ;Y
    ld [shadowOAM + 4], a ;Y

    ld a, [pY]
    call POSITION_GET ;Calculate Y pos in map
    ld [map_pY], a

    ld a, [pX]
    add a, 8
    ld [shadowOAM + 1], a ;X
    add a, 8
    ld [shadowOAM + 4 + 1], a

    ld a, [pX]
    call POSITION_GET ;Calculate X pos in map
    ld [map_pX], a
    ret