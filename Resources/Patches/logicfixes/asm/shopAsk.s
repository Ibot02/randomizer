.equ walletShopSub, walletShopItem+4
.equ boomerangShopItem, walletShopSub+4
.equ boomerangShopSub, boomerangShopItem+4
.equ quiverShopItem, boomerangShopSub+4
.equ quiverShopSub, quiverShopItem+4
.equ getTextOffset, quiverShopSub+4
.thumb
ldrb	r0,[r6,#6]
cmp	r0,#0x64
beq	wallet
cmp	r0,#0x0B
beq	boomerang
cmp	r0,#0x66
beq	quiver
b	vanilla

wallet:
ldr	r0,walletShopItem
ldr	r1,walletShopSub
bl	getText
mov	r1,r3
mov	r2,#0
b	buildText

boomerang:
ldr	r0,boomerangShopItem
ldr	r1,boomerangShopSub
bl	getText
mov	r1,r3
mov	r2,#1
b	buildText

quiver:
ldr	r0,quiverShopItem
ldr	r1,quiverShopSub
bl	getText
mov	r1,r3
mov	r2,#2
b	buildText

buildText:
push	{r4-r7}
ldr	r7,=#0x203F000	@offset
mov	r4,r0		@name
mov	r5,r1		@special
mov	r6,r2		@price
@write the item name to ram
mov	r0,r4
ldr	r3,getTextOffset
mov	lr,r3
.short	0xF800
mov	r1,r7
bl	writeText
mov	r7,r1

@write the special line if any
cmp	r5,#0
beq	nospecial
mov	r0,#0x0A
strb	r0,[r7]
add	r7,#1
mov	r0,r5
ldr	r3,getTextOffset
mov	lr,r3
.short	0xF800
mov	r1,r7
bl	writeText
mov	r7,r1
nospecial:

@write the price to ram
mov	r0,#0x2C
strb	r0,[r7]
add	r7,#1
mov	r0,#0x20
strb	r0,[r7]
add	r7,#1
mov	r0,#0x02
strb	r0,[r7]
add	r7,#1
mov	r0,#0x01
strb	r0,[r7]
add	r7,#1
cmp	r6,#0
beq	is80
cmp	r6,#1
beq	is300
b	is600
is80:
mov	r0,#0x38
strb	r0,[r7]
add	r7,#1
mov	r0,#0x30
strb	r0,[r7]
add	r7,#1
b	doneprice
is300:
mov	r0,#0x33
strb	r0,[r7]
add	r7,#1
mov	r0,#0x30
strb	r0,[r7]
add	r7,#1
strb	r0,[r7]
add	r7,#1
b	doneprice
is600:
mov	r0,#0x36
strb	r0,[r7]
add	r7,#1
mov	r0,#0x30
strb	r0,[r7]
add	r7,#1
strb	r0,[r7]
add	r7,#1
b	doneprice
doneprice:
mov	r0,#0x02
strb	r0,[r7]
add	r7,#1
mov	r0,#0x00
strb	r0,[r7]
add	r7,#1
mov	r0,#0x2E
strb	r0,[r7]
add	r7,#1
mov	r0,#0x0A
strb	r0,[r7]
add	r7,#1

@add a new line if there was no special line
cmp	r5,#0
bne	nonew
mov	r0,#0x0A
strb	r0,[r7]
add	r7,#1
nonew:

@write the buy text to ram
ldr	r0,=#0x2C14
ldr	r3,getTextOffset
mov	lr,r3
.short	0xF800
mov	r1,r7
bl	writeText
mov	r7,r1

@return our special text id
ldr	r0,=#0x2C05
pop	{r4-r7}
b	end

vanilla:
ldr	r3,=#0x8053B68
mov	lr,r3
.short	0xF800

end:
mov	r7,r0
ldr	r3,=#0x8064BBD
bx	r3

writeText:
ldrb	r2,[r0]
strb	r2,[r1]
cmp	r2,#0
beq	endwrite
add	r0,#1
add	r1,#1
b	writeText
endwrite:
bx	lr

getText:
mov	r3,#0
cmp	r0,#0x5C
beq	kinstone
cmp	r0,#0x50
blo	normal
cmp	r0,#0x53
bhi	normal
b	dungeon

normal:
ldr	r1,=#0x0400
orr	r0,r1
bx	lr

dungeon:
cmp	r1,#0x18
blo	normal
cmp	r1,#0x1E
bhi	normal
cmp	r1,#0x18
beq	dws
cmp	r1,#0x19
beq	cof
cmp	r1,#0x1A
beq	fow
cmp	r1,#0x1B
beq	tod
cmp	r1,#0x1C
beq	pow
cmp	r1,#0x1D
beq	dhc
cmp	r1,#0x1E
beq	rc
b	normal
dws:
ldr	r3,=#0x720
b	normal
cof:
ldr	r3,=#0x721
b	normal
fow:
ldr	r3,=#0x722
b	normal
tod:
ldr	r3,=#0x723
b	normal
pow:
ldr	r3,=#0x725
b	normal
dhc:
ldr	r3,=#0x727
b	normal
rc:
ldr	r3,=#0x724
b	normal

kinstone:
cmp	r1,#0x65
blo	normal
cmp	r1,#0x6D
bhi	normal
cmp	r1,#0x65
beq	tornado
cmp	r1,#0x66
beq	tornado
cmp	r1,#0x67
beq	tornado
cmp	r1,#0x68
beq	tornado
cmp	r1,#0x69
beq	tornado
cmp	r1,#0x6A
beq	totem
cmp	r1,#0x6B
beq	totem
cmp	r1,#0x6C
beq	totem
cmp	r1,#0x6D
beq	crown
b	normal
tornado:
ldr	r3,=#0x71A
b	normal
totem:
ldr	r3,=#0x70D
b	normal
crown:
ldr	r3,=#0x717
b	normal

.align
.ltorg
walletShopItem:
@WORD walletShopItem
@WORD walletShopSub
@WORD boomerangShopItem
@WORD boomerangShopSub
@WORD quiverShopItem
@WORD quiverShopSub
@POIN getTextOffset
