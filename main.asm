;****************************************************************************************************************************************************
;*	MAIN.ASM - Blast Maidens source code
;****************************************************************************************************************************************************
;* Developed by Miguel Molina
;* for the University of Seville end-of-degree project
;****************************************************************************************************************************************************

;****************************************************************************************************************************************************
;*	Includes
;****************************************************************************************************************************************************

	;System includes
	INCLUDE	"system/hwgb.inc"

    ;Tile includes
    INCLUDE "gfx/tiles.inc"
    INCLUDE "gfx/player.inc"

	;Project includes
    INCLUDE	"utils.asm"
    INCLUDE	"text.asm"
    INCLUDE	"functions.asm"
    INCLUDE	"input.asm"
    INCLUDE	"vars.asm"
    INCLUDE "player.asm"

;****************************************************************************************************************************************************
;*	Header
;****************************************************************************************************************************************************


SECTION "OAM DMA routine", ROM0
COPY_DMA_ROUTINE:
  ld  hl, DMA_ROUTINE
  ld  b, DMA_ROUTINE_END - DMA_ROUTINE ; Number of bytes to copy
  ld  c, LOW(hOAMDMA) ; Low byte of the destination address
.copy
  ld  a, [hli]
  ldh [c], a
  inc c
  dec b
  jr  nz, .copy
  ret

DMA_ROUTINE:
  ldh [rDMA], a
  
  ld  a, 40
.wait
  dec a
  jr  nz, .wait
  ret
DMA_ROUTINE_END:

SECTION "Shadow OAM", WRAM0,ALIGN[8]
shadowOAM: ds 4 * 40 ; This is the buffer we'll write sprite data to
    
SECTION "OAM DMA", HRAM
hOAMDMA: ds DMA_ROUTINE_END - DMA_ROUTINE ; Reserve space to copy the routine to
    

SECTION "Header", ROM0[$100] ; Make room for the header
    jp INIT

    ds $150 - @, 0

;****************************************************************************************************************************************************
;*	Program Start
;****************************************************************************************************************************************************

SECTION "Program Start", ROM0
INIT:
    ei
    call COPY_DMA_ROUTINE
    call WAIT_VBLANK
    call LCDC_OFF

    ;call LOAD_FONT
    
    call MAP_CLEAR
    call OAM_CLEAR

    ld hl, _SCRN0
    ld de, level1_map_data
    ld bc, level1_tile_map_size
    call MEMCPY

    ld hl, $9000
    ld de, level1_tile_data
    ld bc, level1_tile_data_size
    call MEMCPY

    

    ld hl, $8000
    ld de, player_tile_data
    ld bc, player_tile_data_size
    call MEMCPY


    xor a
    ld [rSCY], a
    ld [rSCX], a
    ld [rNR52], a

    call PLAYER_LOAD

    call LCDC_ON

    ld a, %11100100 ; Init display registers in the first (blank) frame
    ld [rBGP], a
    ld a, %11100100
    ld [rOBP0], a

    call VARS_INIT

MAIN:    
    call WAIT_VBLANK

    ld a, [frameCounter]
    inc a
    ld [frameCounter], a
    ld hl, pSpeed
    cp a, [hl]
    jp nz, MAIN

    ld a, 0
    ld [frameCounter], a

    call INPUT_CHECK

    call PLAYER_UPDATE

    ld  a, HIGH(shadowOAM)
    call hOAMDMA
    jr MAIN

WAIT_VBLANK:
    ld a, [rLY]
    cp 144 				;Check if the LCD is past VBlank
    jr c, WAIT_VBLANK	;rLY >= 144?
    ret

LCDC_OFF:
    xor a
    ld [rLCDC], a		;Set the LCDC off
    ret

LCDC_ON:
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
    ld [rLCDC], a
    ret