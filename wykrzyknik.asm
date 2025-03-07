	DEVICE ZXSPECTRUM48
	
	ORG $8000
start:
	ld a,2
	call 5633
	ld de,string
	ld bc,eostr-string
	call 8252
	ret

string defb 22,21,31,'!'
eostr equ $

	SAVESNA "wykrzyknik.sna",start
