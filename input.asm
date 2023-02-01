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
    jr z, .UP_BUTTON
    cp PADF_DOWN
    jr z, .DOWN_BUTTON
    cp PADF_LEFT
    jr z, .LEFT_BUTTON
    cp PADF_RIGHT
    jr z, .RIGHT_BUTTON

    cp PADF_START
    jr z, .START_BUTTON
    cp PADF_SELECT
    jr z, .SELECT_BUTTON
    cp PADF_A
    jr z, .A_BUTTON
    cp PADF_B
    jr z, .B_BUTTON
    ret

.UP_BUTTON
    ld a, [pY]
    dec a
    ld [pY], a
    ret

.DOWN_BUTTON
    ld a, [pY]
    inc a
    ld [pY], a
    ret

.LEFT_BUTTON
    ld a, [pX]
    dec a
    ld [pX], a
    ret

.RIGHT_BUTTON
    ld a, [pX]
    inc a
    ld [pX], a
    ret

.START_BUTTON
    ret

.SELECT_BUTTON
    ret

.A_BUTTON
    ret

.B_BUTTON
    ret