	DEVICE ZXSPECTRUM48
	
	org $7FFF
start:
	ld a,2
	call 5633
loop	ld de,string
	ld bc,eostr-string
	call 8252
	jp loop

string defb 'Wesolych Swiat!'
       defb 13
eostr equ $

	SAVETAP "hello.tap", start
