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

    cp PADF_START
    jr z, .start_button
    cp PADF_SELECT
    jr z, .select_button
    cp PADF_A
    jr z, .a_button
    cp PADF_B
    jr z, .b_button

    cp PADF_UP
    jr z, .up_buton
    cp PADF_DOWN
    jr z, .down_button
    cp PADF_LEFT
    jr z, .left_button
    cp PADF_RIGHT
    jr z, .right_button

    ret

.start_button
    ret

.select_button
    ret

.a_button
    ld a, [pX]
    add a, 8
    ld c, a
    ld a, [pY]
    add a, 8
    ld b, a
    call BOMB_PLACE
    ret

.b_button
    ld a, [pX]
    add a, 8
    ld c, a
    ld a, [pY]
    add a, 8
    ld b, a
    call CREATE_EXPLOSION
    ret

.up_buton
    ld a, [pX]
    ld c, a
    ld a, [pY]
    dec a
    ld b, a
    call CHECK_BOUNDARY ;Check the collision in next position
    ret nz ;Return if the next tile is not empty

    ld a, [pY]
    dec a
    ld [pY], a
    ret

.down_button
    ld a, [pX]
    ld c, a
    ld a, [pY]
    inc a
    ld b, a
    call CHECK_BOUNDARY ;Check the collision in next position
    ret nz ;Return if the next tile is not empty

    ld a, [pY]
    inc a
    ld [pY], a
    ret

.left_button
    ld a, [pX]
    dec a
    ld c, a
    ld a, [pY]
    ld b, a
    call CHECK_BOUNDARY ;Check the collision in next position
    ret nz ;Return if the next tile is not empty

    ld a, [pX]
    dec a
    ld [pX], a
    ret

.right_button
    ld a, [pX]
    inc a
    ld c, a
    ld a, [pY]
    ld b, a
    call CHECK_BOUNDARY ;Check the collision in next position
    ret nz ;Return if the next tile is not empty

    ld a, [pX]
    inc a
    ld [pX], a
    ret