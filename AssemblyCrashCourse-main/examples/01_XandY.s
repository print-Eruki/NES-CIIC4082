.export Main
.segment "CODE"

.proc Main
  ; Start by loading the value 5 into both the X and Y registers
  ldx #0
  ldy #255

  ; Incrementing a value of ff will result in 00
  iny

  ; Decrementing a value of 00 will result in FF
  dex

  ; this means that the upper limit and lower limit wrap with each other 255 <-> 0

  ; Increment the value of X twice
  ;inx
  ;inx

  ; Decrement the value of X once
  ;dex

  ; Decrement the value Y twice
  ;dey
  ;dey

  ; Increment the value of Y once
  ;iny

  ; Since we ran 2 increments and 1 decrement on X, it should now equal 6
  ; Since we ran 2 decrements on Y and 1 increment, it should now equal 4
  rts
.endproc
