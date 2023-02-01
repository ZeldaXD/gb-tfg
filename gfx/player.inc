; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: player.png
; Pixel Width: 16px
; Pixel Height: 16px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

SECTION "Player Tiles", ROM0

player_tile_data_size EQU $40
player_tile_count EQU $04

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

player_tile_data:
DB $07,$07,$08,$0F,$10,$1F,$20,$3F,$20,$3F,$2E,$3F,$4F,$74,$53,$7C
DB $5F,$79,$97,$F6,$95,$F7,$9D,$FB,$59,$77,$28,$2F,$07,$05,$02,$02
DB $E0,$E0,$10,$F0,$08,$F8,$04,$FC,$04,$FC,$74,$FC,$F2,$2E,$CA,$3E
DB $FA,$9E,$E9,$6F,$A9,$EF,$B9,$DF,$9A,$EE,$14,$F4,$E0,$A0,$40,$40