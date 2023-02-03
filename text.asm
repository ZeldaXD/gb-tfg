SECTION "Text", ROM0

LOAD_FONT:
	ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
    call MEMCPY
    ret

STRCPY:
    ld a, [de]
	inc de
    ld [hl+], a
    and a			    ;Check if the byte we just copied is zero
    jr nz, STRCPY       ;Continue if it's not
    ret

FontTiles:
INCBIN "system/font.chr"
FontTilesEnd:

TEST:
    db "TEST MESSAGE", 0
TEST_END: