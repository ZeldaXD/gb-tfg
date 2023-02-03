SECTION "Player Tiles", ROM0

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

player_tile_map_size EQU $04
player_tile_map_width EQU $02
player_tile_map_height EQU $02

player_tile_data_size EQU $40
player_tile_count EQU $04

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

player_map_data:
DB $00,$01,$02,$03

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

player_tile_data:
DB $00,$00,$00,$00,$00,$00,$07,$07,$08,$0F,$16,$1F,$17,$1A,$17,$1C
DB $13,$1F,$16,$1D,$0D,$0B,$04,$07,$03,$01,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$E0,$E0,$10,$F0,$68,$F8,$E8,$58,$E8,$38
DB $C8,$F8,$68,$B8,$B0,$D0,$20,$E0,$C0,$40,$00,$00,$00,$00,$00,$00