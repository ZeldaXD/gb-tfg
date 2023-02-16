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
    ld a, [rSCY]
    ld b, a
    ld a, [pY]
    ld d, a
    add a, 16
    sub a, b
    ld [shadowOAM], a ;Y
    ld [shadowOAM + 4], a ;Y

    ld a, [rSCX]
    ld b, a
    ld a, [pX]
    ld e, a
    add a, 8
    sub a, b
    ld [shadowOAM + 1], a ;X
    add a, 8
    ld [shadowOAM + 4 + 1], a

    ; ld a, d
    ; add a, p_hitbox_Y
    ; ld d, a
    ; ld a, e
    ; add a, p_hitbox_X
    ; ld e, a
    
    ; srl d
    ; srl d
    ; srl d
    ; srl d

    ; srl e
    ; srl e
    ; srl e
    ; srl e

    ; call TILE_GET
    ; and $0F
    ; cp TILES_BOMB_ID
    ; ret z
    ; xor a
    ; ld hl, last_bomb_locs
    ; ld [hl+], a
    ; ld [hl+], a
    ret