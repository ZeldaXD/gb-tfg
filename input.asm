SECTION "Joypad vars", WRAM0

rPAD: ds 1

SECTION "Joypad", ROM0

INPUT_READ:
    xor a
    ld [rPAD], a

    ld a, %00100000 ; Read D-PAD
    ld [rP1], a

    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]

    and $0F ; Keep low nibble
    swap a ; Swap low and high nibble
    ld b, a

    ld a, %00010000 ; Read buttons
    ld [rP1], a

    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]

    and $0F
    or b

    cpl ; Make the complement of it
    ld [rPAD], a ; Save in rPAD the controls
    ld a, $30 ; Reset joypad
    ld [rP1], a
    ret

INPUT_CHECK:
    call INPUT_READ
    ld a, [rPAD]

    cp PADF_UP
    jr z, .up_buton
    cp PADF_DOWN
    jr z, .down_button
    cp PADF_LEFT
    jr z, .left_button
    cp PADF_RIGHT
    jr z, .right_button

    cp PADF_START
    jr z, .start_button
    cp PADF_SELECT
    jr z, .select_button
    cp PADF_A
    jr z, .a_button
    cp PADF_B
    jr z, .b_button
    ret

.up_buton
    ; ld a, [pY]
    ; sub a, 1
    ; call POS_TO_MAP ;Calculate new Y (minus 10 due to sprite size) pos in map [map_pY] 
    ; ld a, [map_pX]
    ; ld e, a
    ; ld a, b
    ; ld d, a ;map_pY 
    ; call CHECK_COLLISION ;Check the collision in next position
    ; ret nz ;Return if the next tile is not empty

    ld a, [pY]
    dec a
    ld [pY], a
    ret

.down_button
    ; ld a, [pY]
    ; inc a
    ; inc a
    ; call POS_TO_MAP ;Calculate new Y (plus 1 due to sprite size) pos in map [map_pY] 
    ; ld a, [map_pX]
    ; ld e, a
    ; ld a, b
    ; ld d, a ;map_pY 
    ;call CHECK_COLLISION ;Check the collision in next position
    ;ret nz ;Return if the next tile is not empty

    ld a, [pY]
    inc a
    ld [pY], a
    ret

.left_button
    ; ld a, [pX]
    ; sub a, 1
    ; call POS_TO_MAP ;Calculate new X (minus 2 due to sprite size) pos in map [map_pX] 
    ; ld a, [map_pY]
    ; ld d, a
    ; ld a, b
    ; ld e, a ;map_pX 
    ; ;call CHECK_COLLISION ;Check the collision in next position
    ; ;ret nz ;Return if the next tile is not empty

    ld a, [pX]
    dec a
    ld [pX], a
    ret

.right_button
    ; ld a, [pX]
    ; add a, 10
    ; call POS_TO_MAP ;Calculate new X pos (plus 9 due to sprite size) in map [map_pX] 
    ; ld a, [map_pY]
    ; ld d, a
    ; ld a, b
    ; ld e, a ;map_pX 
    ; ;call CHECK_COLLISION ;Check the collision in next position
    ; ;ret nz ;Return if the next tile is not empty

    ld a, [pX]
    inc a
    ld [pX], a
    ret

.start_button
    ret

.select_button
    ret

.a_button
    ret

.b_button
    ret