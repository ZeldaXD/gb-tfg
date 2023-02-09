SECTION "Variables", WRAM0

frameCounter: db
hitbox_locs: ds 2*4

player_sprites: ds 2*4
map_pY: db
map_pX: db
pY: db
pX: db
pSpeed: db
p_hitbox_Y EQU 8
p_hitbox_X EQU 4
p_hitbox_width EQU 7
p_hitbox_height EQU 7