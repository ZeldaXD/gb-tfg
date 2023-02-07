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
  ld a, 16 ;player Y
  ld [pY], a
  ld a, 16 ;player X
  ld [pX], a
  ld a, 15
  ld [pSpeed], a
  ld a, 1 ;player Y position in map
  ld [map_pY], a
  ld a, 1 ;player X position in map
  ld [map_pX], a
  ret 

SCROLL_UPDATE:
  ; ld a, [pX]
  ; sub a, $19
  ; ld [rSCX], a
  ; ld a, [pY]
  ; sub a, $13
  ; ld [rSCY], a
  ret