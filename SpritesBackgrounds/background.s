;Ale J. Pagan Andujar
;CIIC4082 - Computer Architecture 2

PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
PPUSCROLL = $2005
PPUADDR   = $2006
PPUDATA   = $2007
OAMADDR   = $2003
OAMDMA    = $4014

.segment "HEADER"
.byte $4e, $45, $53, $1a ; Magic string that always begins an iNES header
.byte $02        ; Number of 16KB PRG-ROM banks
.byte $01        ; Number of 8KB CHR-ROM banks
.byte %00000000  ; Horizontal mirroring, no save RAM, no mapper
.byte %00000000  ; No special-case flags set, no mapper
.byte $00        ; No PRG-RAM present
.byte $00        ; NTSC format

.segment "STARTUP"

.segment "CODE"


irq_handler:
  RTI

nmi_handler:
  ; LDA #$00
  ; STA OAMADDR
  ; LDA #$02
  ; STA OAMDMA
  LDA #$00
  STA $2005
  STA $2005
  RTI


reset_handler:
  sei		; disable IRQs
  cld		; disable decimal mode
  ldx #$40
  stx $4017	; disable APU frame IRQ
  ldx #$ff 	; Set up stack
  txs		;  .
  inx		; now X = 0
  stx $2000	; disable NMI
  stx $2001 	; disable rendering
  stx $4010 	; disable DMC IRQs
  LDX #$00
  LDA #$ff
clear_oam:
  STA $0200,X ; set sprite y-positions off the screen
  INX
  INX
  INX
  INX
  BNE clear_oam

main:
  ; write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$01
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes

    load_bg:

    LDA PPUSTATUS
    LDA #$21
    STA PPUADDR
    LDA #$c5
    STA PPUADDR
    
    LDX #$00
    loop:
    LDA full_name, X
    STA PPUDATA
    INX
    CPX #$15
    BNE loop

    ; LDA PPUSTATUS ;A
    ; LDA #$21
    ; STA PPUADDR
    ; LDA #$cc
    ; STA PPUADDR
    ; STX PPUDATA

    ;ATTRIBUTE TABLES
      LDA PPUSTATUS
      LDA #$23
      STA PPUADDR
      LDA #$d9
      STA PPUADDR
      LDA #%00000000
      STA PPUDATA
 

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10000000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever

  full_name:
  .byte $01, $02, $03, $00, $04, $01, $05, $01, $06, $00, $01, $06, $07, $08, $09, $01, $0A, $00, $00, $0b, $0b



.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes: 
.byte $0f, $3c, $16, $30
.byte $0f, $14, $3c, $39
.byte $0f, $0c, $07, $13
.byte $0f, $19, $09, $29

.byte $0f, $2d, $10, $15
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29

sprites:
.byte $70, $00, $00, $80
.byte $70, $06, $00, $88
.byte $78, $07, $00, $80
.byte $78, $08, $00, $88


.segment "CHARS"
  .byte %00000000	; Empty Tile (00)
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %00000000	; A (01)
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte $3C, $7E, $C3, $C3, $FF, $FF, $C3, $C3

  .byte %11000000	; L (02)
  .byte %11000000
  .byte %11000000
  .byte %11000000
  .byte %11000000
  .byte %11000000
  .byte %11111111
  .byte %11111111
  .byte $C0, $C0, $C0, $C0, $C0, $C0, $FF, $FF

  .byte %11111111	; E (03)
  .byte %11111111
  .byte %11000000
  .byte %11111111
  .byte %11111111
  .byte %11000000
  .byte %11111111
  .byte %11111111
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %00000000	;  P (04)
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte %00000000
  .byte $FF, $81, $81, $BF, $A0, $A0, $A0, $E0

  .byte %11111111	; G (05)
  .byte %11111111
  .byte %11000000
  .byte %11001111
  .byte %11000011
  .byte %11000011
  .byte %11111110
  .byte %00111100
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %11000001	; N (06)
  .byte %11100001
  .byte %10110001
  .byte %10011001
  .byte %10001101
  .byte %10000111
  .byte %10000011
  .byte %10000001
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %01111000	; D (07)
  .byte %01000100
  .byte %01000010
  .byte %01000001
  .byte %01000001
  .byte %01000010
  .byte %01000100
  .byte %01111000
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %01000010	; U (08)
  .byte %01000010
  .byte %01000010
  .byte %01000010
  .byte %01000010
  .byte %01000010
  .byte %01111110
  .byte %00000000
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %01111110	; J (09)
  .byte %01111110
  .byte %00011000
  .byte %00011000
  .byte %00011000
  .byte %10011000
  .byte %11111000
  .byte %00111000
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %11111110	; R (0a)
  .byte %10000001
  .byte %11111110
  .byte %10100000
  .byte %10010000
  .byte %10001000
  .byte %10000100
  .byte %10000010
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %0000000	; heart (0b)
  .byte %0011011
  .byte %0100101
  .byte %0100001
  .byte %0010001
  .byte %0001010
  .byte %0000100
  .byte %0000000
  .byte $00, $00, $00, $00, $00, $00, $00, $00