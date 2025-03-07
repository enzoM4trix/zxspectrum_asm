    DEVICE ZXSPECTRUM48

   ; org $8000
   org $7FFF

start:
        ld a,71         ;bialy ink (7) black paper (0), bright (64)
        ld (23693),a
        xor a
        call 8859       ;ustal staly kolor ramki

; set up the graphics

        ld hl,blocks    ;adres of user-defined graphics data
        ld (23675),hl
            
;ok let's start the game

        call 3503       ;rom rutyna - czysci ekran, otwiera kanal 2

;initialise coorinates

        ld hl,21+15*256 ;load hl pair with coords
        ld (plx),hl     ;set player coords

        call basexy     ;set the x and y pos of player
        call splayr      ;show player base symbol

;this is main loop

mloop   equ $

;delete the player

        call basexy
        call wspace     ;display space over player

;Przesuwanie postaci zanim sie go z nowu narysuje

        ld bc,31     ;klawiatura rzad 1-5/joystick port 2
        in a,(c)        ;see what keys are pressed
        rra             ;outermost bit = key 1
        push af         ;remember the value
        call c,mpl     ;jesli  zostal nacisniety przesun w lewo
        pop af          ;restore accumulator
        rra             ;nastepny bit (value 2) = key 2
        push af         ;remember the value
        call c,mpr     ;jesli zostal wcisniety przesun w prawo mpr to procedura
        pop af          ;restore accumulator
        rra             ;next bit (value 4) = key 3
        push af         ;remember the value
        call c,mpd     ;wywolanie procedury przesun w dol
        pop af          ;restore accumulator
        rra             ;next bit (value 8) reads key 4
        call c,mpu     ;wcisniety to przesun do gory

;teraz kiedy jest przesuniety mozna go narysowac jeszcze raz

        call basexy     ;set x and y pozycje playera
        call splayr     ;show player
        halt            ;delay
;wroc d glownej petli
        jp mloop

; PROCEDURY
;move player left
mpl     ld hl,ply       ;remember, y is the horizontal coord!
        ld a,(hl)       ;what's the current walue?
        cp 31           ;is it zero?
        ret z           ;yes- we can't go any further left
        inc (hl)        ;subtract 1 from y coordinate
        ret
        
;move player right
mpr     ld hl,ply       ;remember, y is the horizontal coord!
        ld a,(hl)       ;what's the current value?
        and a           ;is it at the tight edge (31)?
        ret z           ;yes - we can go no further then
        dec (hl)        ;subtract 1 from x coordinate
        ret

;move player up

mpu     ld hl,plx       ;remember, y is the horizontal coord!
        ld a,(hl)       ;what's the current value?
        cp 4            ;is it at the upper limit (4)?
        ret z           ;yes - we can go no further then
        dec (hl)        ;subtract 1 from x coordinate
        ret

;move player down

mpd     ld hl,plx       ;remember, y is the horizontal coord!
        ld a,(hl)       ;what's the current value?
        cp 21           ;is it already at the bottom (21)?
        ret z           ;yes - we can go no further then
        inc (hl)        ;subtract 1 from x coordinate
        ret

;set up the x and y coordinates for the player's gunbase position
;this routine is called prior to display and deletion of gunbase

basexy  ld a,22         ;AT code
        rst 16
        ld a,(plx)      ;player vertical coord
        rst 16          ;set vertical position of player
        ld a,(ply)      ;player's horizontal position
        rst 16          ;set the horizontal coord
        ret
        
;show player at current print position

splayr  ld a,69         ;cyan ink (5) on plack paper (0) bright (64)
        ld (23695),a    ;set out temporary screen colors
        ld a,144        ;ASCII code for user defined graphic 'A'
        rst 16          ;draw player
        ret

wspace  ld a,71         ;white ink(7) on black paper (0) bright (64)
        ld (23695),a    ;set our temporary screen colors
        ld a,32         ;SPACE character
        rst 16          ;display space
        ret
    
plx     defb 0          ;player's x coordinate
ply     defb 0          ;player's y coordinate

;UDG graphics
blocks  defb 16,16,56,56,124,124,254,254    ;player base
   
        ;SAVESNA "postac.sna", start
        SAVETAP "postacKempston.tap", start