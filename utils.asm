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
  ld a, $16 ;player Y
  ld [pY], a
  ld a, $e ;player X
  ld [pX], a
  ld a, 15
  ld [pSpeed], a
  ret 