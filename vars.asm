SECTION "Variables", WRAM0

frameCounter: db
collisionCounter: db
swapTileByte: db

player_sprites: ds 4*4
map_pY: db
map_pX: db
pY: db
pX: db
pSpeed: db
p_hitbox_Y EQU 5
p_hitbox_X EQU 4
p_hitbox_width EQU 7
p_hitbox_height EQU 10