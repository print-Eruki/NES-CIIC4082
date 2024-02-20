;Ale J. Pagan Andujar
;CIIC4082 - Computer Architecture 2

.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
  LDA #$00
  STA $2005
  STA $2005
  RTI
.endproc

.export reset_handler
.proc reset_handler
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
.endproc

.export main
.proc main
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

    ;NAMETABLES 
    ; Ale J Pagan Andujar
    ;STORE ALL THE A`s
    LDA PPUSTATUS ;A
    LDA #$21
    STA PPUADDR
    LDA #$c5
    STA PPUADDR
    LDX #$04
    STX PPUDATA

    LDA PPUSTATUS ;A
    LDA #$21
    STA PPUADDR
    LDA #$cc
    STA PPUADDR
    STX PPUDATA

    LDA PPUSTATUS ;A
    LDA #$21
    STA PPUADDR
    LDA #$ce
    STA PPUADDR
    STX PPUDATA

    LDA PPUSTATUS ;A
    LDA #$21
    STA PPUADDR
    LDA #$d1
    STA PPUADDR
    STX PPUDATA

    LDA PPUSTATUS ;A
    LDA #$21
    STA PPUADDR
    LDA #$d6
    STA PPUADDR
    STX PPUDATA

    LDA PPUSTATUS ;L
    LDA #$21
    STA PPUADDR
    LDA #$c6
    STA PPUADDR
    LDX #$0f
    STX PPUDATA

    LDA PPUSTATUS ;E 
    LDA #$21
    STA PPUADDR
    LDA #$c7
    STA PPUADDR
    LDX #$08
    STX PPUDATA

    LDA PPUSTATUS ;J
    LDA #$21
    STA PPUADDR
    LDA #$c9
    STA PPUADDR
    LDX #$0D
    STX PPUDATA

    LDA PPUSTATUS ;J
    LDA #$21
    STA PPUADDR
    LDA #$d5
    STA PPUADDR
    STX PPUDATA

    LDA PPUSTATUS ;P
    LDA #$21
    STA PPUADDR
    LDA #$cb
    STA PPUADDR
    LDX #$13
    STX PPUDATA

    LDA PPUSTATUS ;G
    LDA #$21
    STA PPUADDR
    LDA #$cd
    STA PPUADDR
    LDX #$0a
    STX PPUDATA
    
    ; store all the N`s
    LDA PPUSTATUS ;N
    LDA #$21
    STA PPUADDR
    LDA #$cf
    STA PPUADDR
    LDX #$11
    STX PPUDATA

    LDA PPUSTATUS ;N
    LDA #$21
    STA PPUADDR
    LDA #$d2
    STA PPUADDR
    STX PPUDATA

    LDA PPUSTATUS ;D
    LDA #$21
    STA PPUADDR
    LDA #$d3
    STA PPUADDR
    LDX #$07
    STX PPUDATA

    LDA PPUSTATUS ;U
    LDA #$21
    STA PPUADDR
    LDA #$d4
    STA PPUADDR
    LDX #$18
    STX PPUDATA
    
    LDA PPUSTATUS ;R
    LDA #$21
    STA PPUADDR
    LDA #$d7
    STA PPUADDR
    LDX #$15
    STX PPUDATA

    LDA PPUSTATUS ; heart
    LDA #$21
    STA PPUADDR
    LDA #$db
    STA PPUADDR
    LDX #$30
    STX PPUDATA

    LDA PPUSTATUS ; heart
    LDA #$21
    STA PPUADDR
    LDA #$dc
    STA PPUADDR
    STX PPUDATA

    LDA PPUSTATUS ; heart
    LDA #$21
    STA PPUADDR
    LDA #$dd
    STA PPUADDR
    STX PPUDATA

    ;ATTRIBUTE TABLES
      LDA PPUSTATUS
      LDA #$03
      STA PPUADDR
      LDA #$d9
      STA PPUADDR
      LDA #%00000000
      STA PPUDATA
 

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever
.endproc

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

.segment "CHR"
.incbin "starfield.chr"