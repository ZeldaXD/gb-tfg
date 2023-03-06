MAP_CLEAR:
  ld hl, _SCRN0
  ld bc, $1F * $1F
  call MEMCLEAR
  ret

OAM_CLEAR:
  ld hl, shadowOAM
  ld bc, OAM_COUNT * 4
  call MEMCLEAR
  ret 

VARS_INIT: 
  xor a
  ld [vblankCount], a
  ld [timerSeconds], a
  ld [frameCounter], a
  ld a, p_spawn_Y ;Player Y
  ld [pY], a
  ld a, p_spawn_X ;Player X
  ld [pX], a
  ld a, 15
  ld [pSpeed], a
  ld a, 2
  ld [p_fire_range], a

  ;Copy the level data from the ROM into the level data in the RAM
  ld hl, level_map
  ld de, level1_map
  ld bc, LEVEL_SIZE
  call MEMCPY

  ld bc, $1
  call srand
  xor a
  ld [holesCount], a
  ret 

SCROLL_UPDATE:
  ld a, [pY]
  ld b, a
  ld a, (SCRN_Y / 2) - SCRN_Y + 8
  add a, b
  jr c, .y_underflow
  xor a
.y_underflow:
  ld b, 0
  call MATH_MINMAX
  ld b, 15*16 - SCRN_Y
  call MATH_MINMAX
  ld a, b
  ld [rSCY], a

  ld a, [pX]
  ld b, a
  ld a, (SCRN_X / 2) - SCRN_X + 8
  add a, b
  jr c, .x_underflow
  xor a
.x_underflow:
  ld b, 0
  call MATH_MINMAX
  ld b, 15*16 - SCRN_X
  call MATH_MINMAX
  ld a, b
  ld [rSCX], a
  ret