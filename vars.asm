SECTION "Variables", WRAM0

level_map: ds 8*15
LEVEL_SIZE EQU 8*15

frameCounter: db
hitbox_locs: ds 2*4
current_hitbox_locs: ds 2*4
PLAYER_ID EQU $00

player_sprites: ds 2*4
pY: db
pX: db
pSpeed: db
p_spawn_X EQU 16
p_spawn_Y EQU 16
p_hitbox_Y EQU 8
p_hitbox_X EQU 4
p_hitbox_width EQU 7
p_hitbox_height EQU 7