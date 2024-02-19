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
  LDX #$27
  STX PPUADDR
  LDX #$01
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes

  ; write sprite data
;   LDX #$00
; load_sprites:
;   LDA sprites,X
;   STA $0200,X
;   INX
;   CPX #$10
;   BNE load_sprites

	; write nametables
	; big stars first
	; LDA PPUSTATUS
	; LDA #$21
	; STA PPUADDR
	; LDA #$6c
	; STA PPUADDR
	; LDX #$00
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$21
	; STA PPUADDR
	; LDA #$57
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$22
	; STA PPUADDR
	; LDA #$23
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$23
	; STA PPUADDR
	; LDA #$52
	; STA PPUADDR
	; STX PPUDATA

	; ; next, small star 1
	; LDA PPUSTATUS
	; LDA #$20
	; STA PPUADDR
	; LDA #$74
	; STA PPUADDR
	; LDX #$2d
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$21
	; STA PPUADDR
	; LDA #$43
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$21
	; STA PPUADDR
	; LDA #$5d
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$21
	; STA PPUADDR
	; LDA #$73
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$22
	; STA PPUADDR
	; LDA #$2f
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$22
	; STA PPUADDR
	; LDA #$f7
	; STA PPUADDR
	; STX PPUDATA

	; ; finally, small star 2
	; LDA PPUSTATUS
	; LDA #$20
	; STA PPUADDR
	; LDA #$f1
	; STA PPUADDR
	; LDX #$2e
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$21
	; STA PPUADDR
	; LDA #$a8
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$22
	; STA PPUADDR
	; LDA #$7a
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$23
	; STA PPUADDR
	; LDA #$44
	; STA PPUADDR
	; STX PPUDATA

	; LDA PPUSTATUS
	; LDA #$23
	; STA PPUADDR
	; LDA #$7c
	; STA PPUADDR
	; STX PPUDATA

	; ; finally, attribute table
	; ; LDA PPUSTATUS
	; ; LDA #$23
	; ; STA PPUADDR
	; ; LDA #$c3
	; ; STA PPUADDR
	; ; LDA #%00000000
	; ; STA PPUDATA

	; LDA PPUSTATUS
	; LDA #$23
	; STA PPUADDR
	; LDA #$e0
	; STA PPUADDR
	; LDA #%0000000
	; STA PPUDATA

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
.byte $0f, $12, $23, $27
.byte $0f, $2b, $3c, $39
.byte $0f, $0c, $07, $13
.byte $0f, $19, $09, $29

.byte $0f, $2d, $10, $15
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29

; sprites:
; .byte $70, $00, $00, $80
; .byte $70, $06, $00, $88
; .byte $78, $07, $00, $80
; .byte $78, $08, $00, $88

.segment "CHR"
.incbin "FullName.chr"