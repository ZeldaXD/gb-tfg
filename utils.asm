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
  ld [frameCounter], a
  ld a, 100
  ld [pY], a
  ld a, 16
  ld [pX], a
  ld a, 15
  ld [pSpeed], a
  ret 