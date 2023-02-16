SECTION "Bomb", ROM0


;a = y
;b = x
BOMB_PLACE:
    srl a
    srl a
    srl a
    srl a

    srl b
    srl b
    srl b
    srl b
    ld c, b

    ld d, a
    ld e, b
    call TILE_GET
    or TILES_BOMB_ID
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a

    ld a, d
    ld b, c

    sla b

    ld d, 0
    ld e, SCRN_VX_B * 2 ;Screen width bytes
    ld h, 0
    ld l, b

.sum_loop:
    add hl, de
    dec a
    cp a, 0
    jr nz, .sum_loop
    call BOMB_LOAD
    ret

;bc = address offset
BOMB_LOAD:
    ld bc, $9800
    add hl, bc

    ld a, $0D
    ld [hl+], a
    ld a, $0E
    ld [hl+], a
    ld bc, 16* 2 - 2
    add hl, bc
    ld a, $0F
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    ret