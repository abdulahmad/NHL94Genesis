; Z80 sound driver: the program the main CPU uploads to Z80 RAM at $0000 (file $5E0C-$765C in MAIN.BIN, Z80 address 0 = $5E0C).
; Rows are the exact bytes; the comment is the Z80 instruction at that Z80 address.
Z80SoundDriver
	dc.b	$C3,$00,$06		; $0000 jp Z80Start
	dc.b	$00		; $0003 nop
	dc.b	$C3,$51,$10		; $0004 jp Z80IrqReturn
	dc.b	$00		; $0007 nop
	dc.b	$C3,$51,$10		; $0008 jp Z80IrqReturn
	dc.b	$00		; $000B nop
	dc.b	$C3,$51,$10		; $000C jp Z80IrqReturn
	dc.b	$00		; $000F nop
	dc.b	$C3,$51,$10		; $0010 jp Z80IrqReturn
	dc.b	$00		; $0013 nop
	dc.b	$C3,$51,$10		; $0014 jp Z80IrqReturn
	dc.b	$00		; $0017 nop
	dc.b	$C3,$51,$10		; $0018 jp Z80IrqReturn
	dc.b	$00		; $001B nop
	dc.b	$C3,$51,$10		; $001C jp Z80IrqReturn
	dc.b	$00		; $001F nop
	dc.b	$18,$4F,$18,$4F,$14,$48,$16,$49,$18,$4B,$00,$00,$00,$00,$00,$00		; $0020 data
	dcb.b	$5D0,0		; $0030 zero fill
; Reset entry: interrupts off, stack at $1FFE, initialises the YM2612, tables and DAC state, then falls into the main loop.
Z80Start
	dc.b	$F3		; $0600 di
	dc.b	$31,$FE,$1F		; $0601 ld sp,$1FFE
	dc.b	$ED,$46		; $0604 im 0
	dc.b	$CD,$F8,$08		; $0606 call Z80InitNoteTables
	dc.b	$D9		; $0609 exx
	dc.b	$11,$01,$40		; $060A ld de,$4001
	dc.b	$21,$00,$40		; $060D ld hl,$4000
	dc.b	$D9		; $0610 exx
	dc.b	$FD,$21,$00,$40		; $0611 ld iy,$4000
	dc.b	$CD,$7A,$08		; $0615 call Z80MailboxInit
	dc.b	$CD,$FE,$07		; $0618 call Z80YmLoadRegisters
	dc.b	$CD,$58,$08		; $061B call Z80YmTimerSetup
	dc.b	$CD,$53,$08		; $061E call Z80YmTimerSetupEntry
	dc.b	$CD,$DD,$07		; $0621 call Z80YmKeyOffAll
	dc.b	$CD,$BB,$08		; $0624 call Z80ClearChannelTables
	dc.b	$3E,$3F		; $0627 ld a,$3F
	dc.b	$32,$BB,$00		; $0629 ld ($00BB),a
; Main loop: feeds the DAC, then waits for a command in the mailbox at $0031 and dispatches it.
Z80MainLoop
	dc.b	$CD,$53,$10		; $062C call Z80DacService
	dc.b	$3A,$31,$00		; $062F ld a,($0031)
	dc.b	$B7		; $0632 or a
	dc.b	$28,$F7		; $0633 jr z,Z80MainLoop
	dc.b	$3A,$32,$00		; $0635 ld a,($0032)
	dc.b	$1F		; $0638 rra
	dc.b	$1F		; $0639 rra
	dc.b	$E6,$1C		; $063A and $1C
	dc.b	$32,$40,$06		; $063C ld ($0640),a
	dc.b	$18,$00		; $063F jr $0641
	dc.b	$C3,$61,$06		; $0641 jp $0661
	dc.b	$00,$C3,$D4,$06,$00,$C3,$D4,$07,$00,$C3,$40,$07,$00,$C3,$96,$07		; $0644 data
	dc.b	$00,$C3,$D4,$07,$00,$C3,$B2,$07,$00,$C3,$D4,$07,$00		; $0654 data
	dc.b	$3A,$32,$00		; $0661 ld a,($0032)
	dc.b	$E6,$0F		; $0664 and $0F
	dc.b	$47		; $0666 ld b,a
	dc.b	$3A,$35,$00		; $0667 ld a,($0035)
	dc.b	$80		; $066A add a,b
	dc.b	$32,$98,$00		; $066B ld ($0098),a
	dc.b	$CD,$19,$09		; $066E call Z80GetChannelByte
	dc.b	$32,$95,$00		; $0671 ld ($0095),a
	dc.b	$CD,$23,$09		; $0674 call Z80FindNoteEntry
	dc.b	$DD,$22,$96,$00		; $0677 ld ($0096),ix
	dc.b	$DD,$7E,$00		; $067B ld a,(ix+0)
	dc.b	$FE,$07		; $067E cp $07
	dc.b	$20,$12		; $0680 jr nz,$0694
	dc.b	$3A,$33,$00		; $0682 ld a,($0033)
	dc.b	$C6,$02		; $0685 add a,$02
	dc.b	$4F		; $0687 ld c,a
	dc.b	$06,$00		; $0688 ld b,$00
	dc.b	$DD,$09		; $068A add ix,bc
	dc.b	$DD,$7E,$00		; $068C ld a,(ix+0)
	dc.b	$32,$95,$00		; $068F ld ($0095),a
	dc.b	$18,$E0		; $0692 jr $0674
	dc.b	$3A,$33,$00		; $0694 ld a,($0033)
	dc.b	$32,$9B,$00		; $0697 ld ($009B),a
	dc.b	$CD,$53,$10		; $069A call Z80DacService
	dc.b	$21,$C8,$00		; $069D ld hl,$00C8
	dc.b	$DD,$21,$D4,$00		; $06A0 ld ix,$00D4
	dc.b	$3A,$BB,$00		; $06A4 ld a,($00BB)
	dc.b	$47		; $06A7 ld b,a
	dc.b	$0E,$00		; $06A8 ld c,$00
	dc.b	$CD,$53,$10		; $06AA call Z80DacService
	dc.b	$CB,$38		; $06AD srl b
	dc.b	$38,$0E		; $06AF jr c,$06BF
	dc.b	$3A,$98,$00		; $06B1 ld a,($0098)
	dc.b	$DD,$BE,$00		; $06B4 cp (ix+0)
	dc.b	$20,$06		; $06B7 jr nz,$06BF
	dc.b	$3A,$9B,$00		; $06B9 ld a,($009B)
	dc.b	$BE		; $06BC cp (hl)
	dc.b	$28,$0B		; $06BD jr z,$06CA
	dc.b	$23		; $06BF inc hl
	dc.b	$DD,$23		; $06C0 inc ix
	dc.b	$0C		; $06C2 inc c
	dc.b	$79		; $06C3 ld a,c
	dc.b	$FE,$06		; $06C4 cp $06
	dc.b	$20,$E2		; $06C6 jr nz,$06AA
	dc.b	$18,$04		; $06C8 jr $06CE
	dc.b	$79		; $06CA ld a,c
	dc.b	$CD,$46,$09		; $06CB call Z80YmKeyOn
	dc.b	$CD,$8D,$08		; $06CE call Z80MailboxPop
	dc.b	$C3,$2C,$06		; $06D1 jp Z80MainLoop
	dc.b	$3A,$32,$00		; $06D4 ld a,($0032)
	dc.b	$E6,$0F		; $06D7 and $0F
	dc.b	$47		; $06D9 ld b,a
	dc.b	$3A,$35,$00		; $06DA ld a,($0035)
	dc.b	$80		; $06DD add a,b
	dc.b	$32,$98,$00		; $06DE ld ($0098),a
	dc.b	$CD,$19,$09		; $06E1 call Z80GetChannelByte
	dc.b	$32,$95,$00		; $06E4 ld ($0095),a
	dc.b	$CD,$23,$09		; $06E7 call Z80FindNoteEntry
	dc.b	$DD,$22,$96,$00		; $06EA ld ($0096),ix
	dc.b	$CD,$53,$10		; $06EE call Z80DacService
	dc.b	$DD,$7E,$00		; $06F1 ld a,(ix+0)
	dc.b	$FE,$00		; $06F4 cp $00
	dc.b	$20,$15		; $06F6 jr nz,$070D
	dc.b	$CD,$0C,$0A		; $06F8 call $0A0C
	dc.b	$FE,$FF		; $06FB cp $FF
	dc.b	$20,$03		; $06FD jr nz,$0702
	dc.b	$C3,$3A,$07		; $06FF jp $073A
	dc.b	$32,$94,$00		; $0702 ld ($0094),a
	dc.b	$CD,$53,$10		; $0705 call Z80DacService
	dc.b	$CD,$9E,$0A		; $0708 call $0A9E
	dc.b	$18,$2D		; $070B jr $073A
	dc.b	$FE,$03		; $070D cp $03
	dc.b	$20,$12		; $070F jr nz,$0723
	dc.b	$CD,$1F,$0E		; $0711 call $0E1F
	dc.b	$FE,$05		; $0714 cp $05
	dc.b	$20,$22		; $0716 jr nz,$073A
	dc.b	$32,$94,$00		; $0718 ld ($0094),a
	dc.b	$CD,$53,$10		; $071B call Z80DacService
	dc.b	$CD,$35,$0E		; $071E call $0E35
	dc.b	$18,$17		; $0721 jr $073A
	dc.b	$FE,$07		; $0723 cp $07
	dc.b	$20,$13		; $0725 jr nz,$073A
	dc.b	$3A,$33,$00		; $0727 ld a,($0033)
	dc.b	$C6,$02		; $072A add a,$02
	dc.b	$4F		; $072C ld c,a
	dc.b	$06,$00		; $072D ld b,$00
	dc.b	$DD,$09		; $072F add ix,bc
	dc.b	$DD,$7E,$00		; $0731 ld a,(ix+0)
	dc.b	$32,$95,$00		; $0734 ld ($0095),a
	dc.b	$C3,$E7,$06		; $0737 jp $06E7
	dc.b	$CD,$8D,$08		; $073A call Z80MailboxPop
	dc.b	$C3,$2C,$06		; $073D jp Z80MainLoop
	dc.b	$3A,$32,$00		; $0740 ld a,($0032)
	dc.b	$E6,$0F		; $0743 and $0F
	dc.b	$47		; $0745 ld b,a
	dc.b	$3A,$35,$00		; $0746 ld a,($0035)
	dc.b	$80		; $0749 add a,b
	dc.b	$32,$98,$00		; $074A ld ($0098),a
	dc.b	$3A,$33,$00		; $074D ld a,($0033)
	dc.b	$FE,$01		; $0750 cp $01
	dc.b	$20,$11		; $0752 jr nz,$0765
	dc.b	$3A,$98,$00		; $0754 ld a,($0098)
	dc.b	$C6,$80		; $0757 add a,$80
	dc.b	$6F		; $0759 ld l,a
	dc.b	$26,$02		; $075A ld h,$02
	dc.b	$3A,$34,$00		; $075C ld a,($0034)
	dc.b	$77		; $075F ld (hl),a
	dc.b	$CD,$32,$0F		; $0760 call $0F32
	dc.b	$18,$2B		; $0763 jr $0790
	dc.b	$FE,$07		; $0765 cp $07
	dc.b	$20,$27		; $0767 jr nz,$0790
	dc.b	$3A,$98,$00		; $0769 ld a,($0098)
	dc.b	$C6,$00		; $076C add a,$00
	dc.b	$6F		; $076E ld l,a
	dc.b	$26,$03		; $076F ld h,$03
	dc.b	$3A,$34,$00		; $0771 ld a,($0034)
	dc.b	$77		; $0774 ld (hl),a
	dc.b	$3A,$98,$00		; $0775 ld a,($0098)
	dc.b	$CD,$19,$09		; $0778 call Z80GetChannelByte
	dc.b	$32,$95,$00		; $077B ld ($0095),a
	dc.b	$CD,$53,$10		; $077E call Z80DacService
	dc.b	$CD,$23,$09		; $0781 call Z80FindNoteEntry
	dc.b	$DD,$22,$96,$00		; $0784 ld ($0096),ix
	dc.b	$CD,$53,$10		; $0788 call Z80DacService
	dc.b	$CD,$FD,$0F		; $078B call $0FFD
	dc.b	$18,$00		; $078E jr $0790
	dc.b	$CD,$8D,$08		; $0790 call Z80MailboxPop
	dc.b	$C3,$2C,$06		; $0793 jp Z80MainLoop
	dc.b	$3A,$32,$00		; $0796 ld a,($0032)
	dc.b	$E6,$0F		; $0799 and $0F
	dc.b	$47		; $079B ld b,a
	dc.b	$3A,$35,$00		; $079C ld a,($0035)
	dc.b	$80		; $079F add a,b
	dc.b	$C6,$00		; $07A0 add a,$00
	dc.b	$6F		; $07A2 ld l,a
	dc.b	$26,$02		; $07A3 ld h,$02
	dc.b	$3A,$33,$00		; $07A5 ld a,($0033)
	dc.b	$77		; $07A8 ld (hl),a
	dc.b	$CD,$8D,$08		; $07A9 call Z80MailboxPop
	dc.b	$CD,$53,$10		; $07AC call Z80DacService
	dc.b	$C3,$2C,$06		; $07AF jp Z80MainLoop
	dc.b	$3A,$32,$00		; $07B2 ld a,($0032)
	dc.b	$E6,$0F		; $07B5 and $0F
	dc.b	$47		; $07B7 ld b,a
	dc.b	$3A,$35,$00		; $07B8 ld a,($0035)
	dc.b	$80		; $07BB add a,b
	dc.b	$32,$98,$00		; $07BC ld ($0098),a
	dc.b	$C6,$00		; $07BF add a,$00
	dc.b	$6F		; $07C1 ld l,a
	dc.b	$26,$04		; $07C2 ld h,$04
	dc.b	$3A,$33,$00		; $07C4 ld a,($0033)
	dc.b	$77		; $07C7 ld (hl),a
	dc.b	$CD,$53,$10		; $07C8 call Z80DacService
	dc.b	$CD,$32,$0F		; $07CB call $0F32
	dc.b	$CD,$8D,$08		; $07CE call Z80MailboxPop
	dc.b	$C3,$2C,$06		; $07D1 jp Z80MainLoop
	dc.b	$CD,$8D,$08		; $07D4 call Z80MailboxPop
	dc.b	$CD,$DD,$07		; $07D7 call Z80YmKeyOffAll
	dc.b	$C3,$2C,$06		; $07DA jp Z80MainLoop
; Writes key-off for every FM channel (register $28).
Z80YmKeyOffAll
	dc.b	$21,$00,$40		; $07DD ld hl,$4000
	dc.b	$11,$01,$40		; $07E0 ld de,$4001
	dc.b	$3E,$06		; $07E3 ld a,$06
	dc.b	$CD,$3E,$11		; $07E5 call Z80YmWaitReady
	dc.b	$36,$28		; $07E8 ld (hl),$28
	dc.b	$12		; $07EA ld (de),a
	dc.b	$3D		; $07EB dec a
	dc.b	$FA,$F5,$07		; $07EC jp m,$07F5
	dc.b	$FE,$03		; $07EF cp $03
	dc.b	$28,$F8		; $07F1 jr z,$07EB
	dc.b	$18,$F0		; $07F3 jr $07E5
	dc.b	$CD,$53,$10		; $07F5 call Z80DacService
	dc.b	$3E,$3F		; $07F8 ld a,$3F
	dc.b	$32,$BB,$00		; $07FA ld ($00BB),a
	dc.b	$C9		; $07FD ret
; Loads the initial YM2612 register values from two tables (parts 1 and 2).
Z80YmLoadRegisters
	dc.b	$01,$2F,$08		; $07FE ld bc,$082F
	dc.b	$21,$00,$40		; $0801 ld hl,$4000
	dc.b	$11,$01,$40		; $0804 ld de,$4001
	dc.b	$0A		; $0807 ld a,(bc)
	dc.b	$03		; $0808 inc bc
	dc.b	$FE,$FF		; $0809 cp $FF
	dc.b	$28,$09		; $080B jr z,$0816
	dc.b	$CD,$3E,$11		; $080D call Z80YmWaitReady
	dc.b	$77		; $0810 ld (hl),a
	dc.b	$0A		; $0811 ld a,(bc)
	dc.b	$03		; $0812 inc bc
	dc.b	$12		; $0813 ld (de),a
	dc.b	$18,$F1		; $0814 jr $0807
	dc.b	$01,$4A,$08		; $0816 ld bc,$084A
	dc.b	$21,$02,$40		; $0819 ld hl,$4002
	dc.b	$11,$03,$40		; $081C ld de,$4003
	dc.b	$0A		; $081F ld a,(bc)
	dc.b	$03		; $0820 inc bc
	dc.b	$FE,$FF		; $0821 cp $FF
	dc.b	$28,$09		; $0823 jr z,$082E
	dc.b	$CD,$3E,$11		; $0825 call Z80YmWaitReady
	dc.b	$77		; $0828 ld (hl),a
	dc.b	$0A		; $0829 ld a,(bc)
	dc.b	$03		; $082A inc bc
	dc.b	$12		; $082B ld (de),a
	dc.b	$18,$F1		; $082C jr $081F
	dc.b	$C9		; $082E ret
	dc.b	$22,$00,$27,$00,$28,$00,$28,$01,$28,$02,$28,$04,$28,$05,$28,$06		; $082F data
	dc.b	$2B,$00,$90,$00,$94,$00,$98,$00,$9C,$00,$FF,$90,$00,$94,$00,$98		; $083F data
	dc.b	$00,$9C,$00,$FF		; $084F data
; Second entry into the timer setup (register $27 / DAC enable).
Z80YmTimerSetupEntry
	dc.b	$C9		; $0853 ret
	dc.b	$9F,$BF,$DF,$FF		; $0854 data
; Sets YM2612 register $27 (timer/channel 3 mode) and the DAC state words.
Z80YmTimerSetup
	dc.b	$21,$00,$40		; $0858 ld hl,$4000
	dc.b	$CD,$3E,$11		; $085B call Z80YmWaitReady
	dc.b	$36,$27		; $085E ld (hl),$27
	dc.b	$23		; $0860 inc hl
	dc.b	$36,$30		; $0861 ld (hl),$30
	dc.b	$2B		; $0863 dec hl
	dc.b	$CD,$3E,$11		; $0864 call Z80YmWaitReady
	dc.b	$36,$26		; $0867 ld (hl),$26
	dc.b	$23		; $0869 inc hl
	dc.b	$36,$FE		; $086A ld (hl),$FE
	dc.b	$2B		; $086C dec hl
	dc.b	$CD,$3E,$11		; $086D call Z80YmWaitReady
	dc.b	$36,$27		; $0870 ld (hl),$27
	dc.b	$23		; $0872 inc hl
	dc.b	$3E,$0A		; $0873 ld a,$0A
	dc.b	$77		; $0875 ld (hl),a
	dc.b	$32,$A1,$00		; $0876 ld ($00A1),a
	dc.b	$C9		; $0879 ret
; Clears the command mailbox at $0030 ($41 bytes).
Z80MailboxInit
	dc.b	$21,$30,$00		; $087A ld hl,$0030
	dc.b	$36,$FF		; $087D ld (hl),$FF
	dc.b	$23		; $087F inc hl
	dc.b	$0E,$41		; $0880 ld c,$41
	dc.b	$3E,$00		; $0882 ld a,$00
	dc.b	$77		; $0884 ld (hl),a
	dc.b	$23		; $0885 inc hl
	dc.b	$0D		; $0886 dec c
	dc.b	$20,$FB		; $0887 jr nz,$0884
	dc.b	$32,$30,$00		; $0889 ld ($0030),a
	dc.b	$C9		; $088C ret
; Takes the next command out of the mailbox into $0032 onward.
Z80MailboxPop
	dc.b	$3E,$FF		; $088D ld a,$FF
	dc.b	$32,$30,$00		; $088F ld ($0030),a
	dc.b	$21,$32,$00		; $0892 ld hl,$0032
	dc.b	$DD,$21,$36,$00		; $0895 ld ix,$0036
	dc.b	$3A,$31,$00		; $0899 ld a,($0031)
	dc.b	$3D		; $089C dec a
	dc.b	$28,$0F		; $089D jr z,$08AE
	dc.b	$CB,$27		; $089F sla a
	dc.b	$CB,$27		; $08A1 sla a
	dc.b	$4F		; $08A3 ld c,a
	dc.b	$DD,$7E,$00		; $08A4 ld a,(ix+0)
	dc.b	$77		; $08A7 ld (hl),a
	dc.b	$DD,$23		; $08A8 inc ix
	dc.b	$23		; $08AA inc hl
	dc.b	$0D		; $08AB dec c
	dc.b	$20,$F6		; $08AC jr nz,$08A4
	dc.b	$3A,$31,$00		; $08AE ld a,($0031)
	dc.b	$3D		; $08B1 dec a
	dc.b	$32,$31,$00		; $08B2 ld ($0031),a
	dc.b	$3E,$00		; $08B5 ld a,$00
	dc.b	$32,$30,$00		; $08B7 ld ($0030),a
	dc.b	$C9		; $08BA ret
; Clears the channel work tables at $0200-$04FF.
Z80ClearChannelTables
	dc.b	$21,$00,$02		; $08BB ld hl,$0200
	dc.b	$3E,$00		; $08BE ld a,$00
	dc.b	$0E,$80		; $08C0 ld c,$80
	dc.b	$77		; $08C2 ld (hl),a
	dc.b	$23		; $08C3 inc hl
	dc.b	$0D		; $08C4 dec c
	dc.b	$20,$FB		; $08C5 jr nz,$08C2
	dc.b	$21,$80,$02		; $08C7 ld hl,$0280
	dc.b	$3E,$00		; $08CA ld a,$00
	dc.b	$0E,$80		; $08CC ld c,$80
	dc.b	$77		; $08CE ld (hl),a
	dc.b	$23		; $08CF inc hl
	dc.b	$0D		; $08D0 dec c
	dc.b	$20,$FB		; $08D1 jr nz,$08CE
	dc.b	$21,$00,$03		; $08D3 ld hl,$0300
	dc.b	$3E,$7F		; $08D6 ld a,$7F
	dc.b	$0E,$80		; $08D8 ld c,$80
	dc.b	$77		; $08DA ld (hl),a
	dc.b	$23		; $08DB inc hl
	dc.b	$0D		; $08DC dec c
	dc.b	$20,$FB		; $08DD jr nz,$08DA
	dc.b	$21,$80,$03		; $08DF ld hl,$0380
	dc.b	$3E,$40		; $08E2 ld a,$40
	dc.b	$0E,$80		; $08E4 ld c,$80
	dc.b	$77		; $08E6 ld (hl),a
	dc.b	$23		; $08E7 inc hl
	dc.b	$0D		; $08E8 dec c
	dc.b	$20,$FB		; $08E9 jr nz,$08E6
	dc.b	$21,$00,$04		; $08EB ld hl,$0400
	dc.b	$3E,$40		; $08EE ld a,$40
	dc.b	$0E,$80		; $08F0 ld c,$80
	dc.b	$77		; $08F2 ld (hl),a
	dc.b	$23		; $08F3 inc hl
	dc.b	$0D		; $08F4 dec c
	dc.b	$20,$FB		; $08F5 jr nz,$08F2
	dc.b	$C9		; $08F7 ret
; Fills the note/volume tables at $0100 and $0200.
Z80InitNoteTables
	dc.b	$3E,$7F		; $08F8 ld a,$7F
	dc.b	$32,$00,$01		; $08FA ld ($0100),a
	dc.b	$3E,$04		; $08FD ld a,$04
	dc.b	$32,$01,$01		; $08FF ld ($0101),a
	dc.b	$3E,$18		; $0902 ld a,$18
	dc.b	$32,$02,$01		; $0904 ld ($0102),a
	dc.b	$3E,$4B		; $0907 ld a,$4B
	dc.b	$32,$03,$01		; $0909 ld ($0103),a
	dc.b	$21,$04,$01		; $090C ld hl,$0104
	dc.b	$3E,$FF		; $090F ld a,$FF
	dc.b	$0E,$FC		; $0911 ld c,$FC
	dc.b	$77		; $0913 ld (hl),a
	dc.b	$23		; $0914 inc hl
	dc.b	$0D		; $0915 dec c
	dc.b	$20,$FB		; $0916 jr nz,$0913
	dc.b	$C9		; $0918 ret
; Reads a byte from the channel table at $0200 indexed by A.
Z80GetChannelByte
	dc.b	$C6,$00		; $0919 add a,$00
	dc.b	$6F		; $091B ld l,a
	dc.b	$26,$02		; $091C ld h,$02
	dc.b	$7E		; $091E ld a,(hl)
	dc.b	$CD,$53,$10		; $091F call Z80DacService
	dc.b	$C9		; $0922 ret
; Searches the table at $0100 ($40 entries) for the value in A.
Z80FindNoteEntry
	dc.b	$E5		; $0923 push hl
	dc.b	$21,$00,$01		; $0924 ld hl,$0100
	dc.b	$0E,$40		; $0927 ld c,$40
	dc.b	$BE		; $0929 cp (hl)
	dc.b	$20,$0A		; $092A jr nz,$0936
	dc.b	$23		; $092C inc hl
	dc.b	$23		; $092D inc hl
	dc.b	$46		; $092E ld b,(hl)
	dc.b	$23		; $092F inc hl
	dc.b	$4E		; $0930 ld c,(hl)
	dc.b	$C5		; $0931 push bc
	dc.b	$DD,$E1		; $0932 pop ix
	dc.b	$18,$0E		; $0934 jr $0944
	dc.b	$CD,$53,$10		; $0936 call Z80DacService
	dc.b	$23		; $0939 inc hl
	dc.b	$23		; $093A inc hl
	dc.b	$23		; $093B inc hl
	dc.b	$23		; $093C inc hl
	dc.b	$0D		; $093D dec c
	dc.b	$20,$E9		; $093E jr nz,$0929
	dc.b	$DD,$21,$00,$00		; $0940 ld ix,$0000
	dc.b	$E1		; $0944 pop hl
	dc.b	$C9		; $0945 ret
; Writes the key on/off register ($28) for the channel in A.
Z80YmKeyOn
	dc.b	$47		; $0946 ld b,a
	dc.b	$21,$00,$40		; $0947 ld hl,$4000
	dc.b	$FE,$03		; $094A cp $03
	dc.b	$38,$01		; $094C jr c,$094F
	dc.b	$3C		; $094E inc a
	dc.b	$CD,$3E,$11		; $094F call Z80YmWaitReady
	dc.b	$36,$28		; $0952 ld (hl),$28
	dc.b	$23		; $0954 inc hl
	dc.b	$77		; $0955 ld (hl),a
	dc.b	$78		; $0956 ld a,b
	dc.b	$C6,$38		; $0957 add a,$38
	dc.b	$6F		; $0959 ld l,a
	dc.b	$3E,$12		; $095A ld a,$12
	dc.b	$CE,$00		; $095C adc a,$00
	dc.b	$67		; $095E ld h,a
	dc.b	$3A,$BB,$00		; $095F ld a,($00BB)
	dc.b	$B6		; $0962 or (hl)
	dc.b	$32,$BB,$00		; $0963 ld ($00BB),a
	dc.b	$CD,$53,$10		; $0966 call Z80DacService
	dc.b	$C9		; $0969 ret
	dc.b	$3A,$94,$00,$C6,$40,$6F,$3E,$12,$CE,$00,$67,$3A,$BB,$00,$A6,$32		; $096A data
	dc.b	$BB,$00,$C9,$C9,$3A,$94,$00,$C6,$BC,$6F,$26,$00,$3A,$95,$00,$77		; $097A data
	dc.b	$CD,$53,$10,$3A,$94,$00,$C6,$C2,$6F,$26,$00,$DD,$7E,$00,$77,$CD		; $098A data
	dc.b	$53,$10,$3A,$94,$00,$C6,$C8,$6F,$26,$00,$3A,$33,$00,$77,$CD,$53		; $099A data
	dc.b	$10,$3A,$94,$00,$C6,$CE,$6F,$26,$00,$3A,$34,$00,$77,$CD,$53,$10		; $09AA data
	dc.b	$3A,$94,$00,$C6,$E0,$6F,$26,$00,$DD,$7E,$01,$77,$CD,$53,$10,$3A		; $09BA data
	dc.b	$98,$00,$47,$3A,$94,$00,$C6,$D4,$6F,$26,$00,$70,$CD,$53,$10,$3A		; $09CA data
	dc.b	$98,$00,$C6,$80,$6F,$26,$05,$DD,$7E,$22,$77,$3A,$98,$00,$C6,$80		; $09DA data
	dc.b	$6F,$26,$04,$36,$80,$3A,$98,$00,$C6,$00,$6F,$26,$05,$36,$00,$3A		; $09EA data
	dc.b	$94,$00,$C6,$E6,$6F,$26,$00,$DD,$7E,$00,$B7,$20,$04,$DD,$7E,$1D		; $09FA data
	dc.b	$77,$C9,$CD,$53,$10,$AF,$32,$99,$00,$DD,$CB,$23,$46,$28,$23,$3A		; $0A0A data
	dc.b	$BB,$00,$47,$3A,$95,$00,$0E,$00,$16,$06,$21,$BC,$00,$CB,$38,$38		; $0A1A data
	dc.b	$0C,$BE,$20,$09,$3E,$FF,$32,$99,$00,$79,$C3,$9D,$0A,$0C,$23,$15		; $0A2A data
	dc.b	$20,$EB,$3A,$BB,$00,$B7,$28,$0A,$47,$3E,$00,$CB,$18,$38,$54,$3C		; $0A3A data
	dc.b	$18,$F9,$CD,$53,$10,$DD,$7E,$01,$DD,$21,$E0,$00,$0E,$00,$DD,$BE		; $0A4A data
	dc.b	$00,$38,$2F,$28,$2D,$0C,$DD,$BE,$01,$38,$27,$28,$25,$0C,$DD,$BE		; $0A5A data
	dc.b	$02,$38,$1F,$28,$1D,$0C,$CD,$53,$10,$DD,$BE,$03,$38,$14,$28,$12		; $0A6A data
	dc.b	$0C,$DD,$BE,$04,$38,$0C,$28,$0A,$0C,$DD,$BE,$05,$38,$04,$28,$02		; $0A7A data
	dc.b	$18,$0C,$79,$32,$94,$00,$CD,$46,$09,$3A,$94,$00,$18,$05,$CD,$53		; $0A8A data
	dc.b	$10,$3E,$FF,$C9,$CD,$7E,$09,$3A,$99,$00,$B7,$28,$03,$C3,$3F,$0B		; $0A9A data
	dc.b	$DD,$23,$DD,$23,$3A,$94,$00,$FE,$03,$38,$07,$C6,$B1,$21,$02,$40		; $0AAA data
	dc.b	$18,$05,$C6,$B4,$21,$00,$40,$CD,$3E,$11,$77,$23,$36,$00,$3A,$94		; $0ABA data
	dc.b	$00,$FE,$05,$20,$0B,$21,$00,$40,$CD,$3E,$11,$36,$2B,$23,$36,$00		; $0ACA data
	dc.b	$3A,$94,$00,$FE,$03,$38,$07,$C6,$2D,$21,$02,$40,$18,$05,$C6,$30		; $0ADA data
	dc.b	$21,$00,$40,$0E,$18,$CD,$53,$10,$DD,$56,$00,$DD,$23,$CD,$3E,$11		; $0AEA data
	dc.b	$77,$23,$C6,$04,$72,$2B,$0D,$20,$EC,$3A,$94,$00,$FE,$03,$38,$04		; $0AFA data
	dc.b	$C6,$AD,$18,$02,$C6,$B0,$DD,$56,$00,$CD,$3E,$11,$77,$23,$72,$CD		; $0B0A data
	dc.b	$53,$10,$CD,$B9,$0C,$DD,$2A,$96,$00,$3A,$94,$00,$FE,$03,$38,$07		; $0B1A data
	dc.b	$C6,$B1,$21,$02,$40,$18,$05,$C6,$B4,$21,$00,$40,$CD,$3E,$11,$77		; $0B2A data
	dc.b	$23,$DD,$7E,$1B,$77,$CD,$61,$0B,$3A,$99,$00,$B7,$20,$15,$21,$00		; $0B3A data
	dc.b	$40,$3A,$94,$00,$FE,$03,$38,$01,$3C,$DD,$B6,$1D,$CD,$3E,$11,$36		; $0B4A data
	dc.b	$28,$23,$77,$CD,$6A,$09,$C9,$DD,$2A,$96,$00,$3A,$94,$00,$C6,$C8		; $0B5A data
	dc.b	$6F,$26,$00,$7E,$DD,$86,$1E,$32,$9B,$00,$CD,$53,$10,$AF,$32,$9A		; $0B6A data
	dc.b	$00,$3A,$98,$00,$C6,$00,$6F,$26,$04,$7E,$FE,$40,$28,$32,$07,$CB		; $0B7A data
	dc.b	$7F,$28,$16,$D6,$80,$07,$DD,$46,$1F,$CD,$48,$11,$79,$32,$9A,$00		; $0B8A data
	dc.b	$3A,$9B,$00,$80,$32,$9B,$00,$18,$17,$4F,$3E,$7F,$91,$07,$DD,$46		; $0B9A data
	dc.b	$20,$CD,$48,$11,$AF,$91,$32,$9A,$00,$3A,$9B,$00,$98,$32,$9B,$00		; $0BAA data
	dc.b	$CD,$53,$10,$DD,$7E,$21,$B7,$28,$52,$47,$3A,$98,$00,$C6,$80,$6F		; $0BBA data
	dc.b	$26,$02,$7E,$B7,$28,$45,$07,$CD,$48,$11,$CD,$53,$10,$3A,$98,$00		; $0BCA data
	dc.b	$C6,$80,$6F,$26,$04,$7E,$CB,$7F,$28,$19,$D6,$80,$07,$5F,$16,$00		; $0BDA data
	dc.b	$CD,$5A,$11,$3A,$9A,$00,$82,$32,$9A,$00,$3A,$9B,$00,$89,$32,$9B		; $0BEA data
	dc.b	$00,$18,$18,$57,$3E,$7F,$92,$5F,$16,$00,$CD,$5A,$11,$3A,$9A,$00		; $0BFA data
	dc.b	$92,$32,$9A,$00,$3A,$9B,$00,$99,$32,$9B,$00,$CD,$53,$10,$DD,$7E		; $0C0A data
	dc.b	$1C,$B7,$28,$2C,$CB,$7F,$20,$13,$07,$47,$3A,$9A,$00,$80,$32,$9A		; $0C1A data
	dc.b	$00,$3A,$9B,$00,$CE,$00,$32,$9B,$00,$18,$15,$47,$3E,$80,$90,$07		; $0C2A data
	dc.b	$47,$3A,$9A,$00,$90,$32,$9A,$00,$3A,$9B,$00,$DE,$00,$32,$9B,$00		; $0C3A data
	dc.b	$CD,$53,$10,$3A,$9B,$00,$CB,$27,$C6,$78,$6F,$3E,$11,$CE,$00,$67		; $0C4A data
	dc.b	$7E,$32,$B3,$00,$32,$B5,$00,$4F,$23,$7E,$32,$B4,$00,$E6,$07,$47		; $0C5A data
	dc.b	$32,$B6,$00,$11,$0F,$01,$CD,$5A,$11,$CD,$53,$10,$6A,$61,$ED,$4B		; $0C6A data
	dc.b	$B5,$00,$37,$3F,$ED,$42,$45,$3A,$9A,$00,$CD,$48,$11,$CD,$53,$10		; $0C7A data
	dc.b	$48,$06,$00,$2A,$B3,$00,$09,$E5,$C1,$3A,$94,$00,$FE,$03,$38,$07		; $0C8A data
	dc.b	$C6,$A1,$21,$02,$40,$18,$05,$C6,$A4,$21,$00,$40,$CD,$3E,$11,$77		; $0C9A data
	dc.b	$23,$D6,$04,$70,$2B,$CD,$3E,$11,$77,$23,$71,$CD,$53,$10,$C9,$3A		; $0CAA data
	dc.b	$98,$00,$C6,$00,$6F,$26,$03,$7E,$CB,$27,$FE,$FE,$38,$0D,$3A,$94		; $0CBA data
	dc.b	$00,$C6,$CE,$6F,$26,$00,$46,$CB,$20,$18,$13,$47,$3A,$94,$00,$C6		; $0CCA data
	dc.b	$CE,$6F,$26,$00,$7E,$CB,$27,$FE,$FE,$28,$03,$CD,$48,$11,$CD,$53		; $0CDA data
	dc.b	$10,$78,$32,$9C,$00,$DD,$2A,$96,$00,$DD,$7E,$09,$C6,$C8,$6F,$3E		; $0CEA data
	dc.b	$12,$CE,$00,$67,$46,$3A,$9C,$00,$CD,$48,$11,$78,$CB,$3F,$C6,$48		; $0CFA data
	dc.b	$6F,$3E,$12,$CE,$00,$67,$7E,$32,$A0,$00,$CD,$53,$10,$DD,$2A,$96		; $0D0A data
	dc.b	$00,$DD,$7E,$1A,$E6,$07,$FE,$04,$30,$03,$C3,$AD,$0D,$DD,$7E,$08		; $0D1A data
	dc.b	$C6,$C8,$6F,$3E,$12,$CE,$00,$67,$46,$3A,$9C,$00,$CD,$48,$11,$78		; $0D2A data
	dc.b	$CB,$3F,$C6,$48,$6F,$3E,$12,$CE,$00,$67,$7E,$32,$9E,$00,$CD,$53		; $0D3A data
	dc.b	$10,$DD,$2A,$96,$00,$DD,$7E,$1A,$E6,$07,$FE,$05,$38,$55,$DD,$7E		; $0D4A data
	dc.b	$07,$C6,$C8,$6F,$3E,$12,$CE,$00,$67,$46,$3A,$9C,$00,$CD,$48,$11		; $0D5A data
	dc.b	$78,$CB,$3F,$C6,$48,$6F,$3E,$12,$CE,$00,$67,$7E,$32,$9F,$00,$CD		; $0D6A data
	dc.b	$53,$10,$DD,$2A,$96,$00,$DD,$7E,$1A,$E6,$07,$FE,$07,$20,$24,$DD		; $0D7A data
	dc.b	$7E,$06,$C6,$C8,$6F,$3E,$12,$CE,$00,$67,$46,$3A,$9C,$00,$CD,$48		; $0D8A data
	dc.b	$11,$78,$CB,$3F,$C6,$48,$6F,$3E,$12,$CE,$00,$67,$7E,$32,$9D,$00		; $0D9A data
	dc.b	$CD,$53,$10,$3A,$94,$00,$FE,$03,$30,$08,$C6,$4C,$4F,$21,$00,$40		; $0DAA data
	dc.b	$18,$06,$C6,$49,$4F,$21,$02,$40,$CD,$53,$10,$DD,$2A,$96,$00,$DD		; $0DBA data
	dc.b	$7E,$1A,$E6,$07,$47,$CD,$3E,$11,$71,$23,$3A,$A0,$00,$77,$2B,$CD		; $0DCA data
	dc.b	$53,$10,$0D,$0D,$0D,$0D,$78,$FE,$04,$38,$35,$CD,$3E,$11,$71,$23		; $0DDA data
	dc.b	$3A,$9E,$00,$77,$2B,$CD,$53,$10,$0D,$0D,$0D,$0D,$78,$FE,$05,$38		; $0DEA data
	dc.b	$1F,$CD,$3E,$11,$71,$23,$3A,$9F,$00,$77,$2B,$CD,$53,$10,$0D,$0D		; $0DFA data
	dc.b	$0D,$0D,$78,$FE,$07,$20,$09,$CD,$3E,$11,$71,$23,$3A,$9D,$00,$77		; $0E0A data
	dc.b	$C9,$C9,$C9,$C9,$C9,$3A,$BB,$00,$CB,$6F,$20,$08,$3A,$E5,$00,$DD		; $0E1A data
	dc.b	$BE,$01,$38,$04,$3E,$05,$18,$02,$3E,$FF,$C9,$CD,$7E,$09,$3E,$05		; $0E2A data
	dc.b	$CD,$46,$09,$21,$00,$40,$CD,$3E,$11,$36,$2B,$23,$36,$80,$21,$02		; $0E3A data
	dc.b	$40,$DD,$7E,$02,$CD,$3E,$11,$36,$B6,$23,$77,$DD,$7E,$03,$32,$93		; $0E4A data
	dc.b	$00,$3E,$01,$32,$92,$00,$21,$00,$40,$11,$01,$40,$CD,$3E,$11,$3A		; $0E5A data
	dc.b	$A1,$00,$E6,$FE,$36,$27,$12,$3A,$CD,$00,$CB,$3F,$E6,$FE,$C6,$A3		; $0E6A data
	dc.b	$4F,$3E,$0E,$CE,$00,$47,$CD,$3E,$11,$0A,$03,$36,$24,$12,$CD,$3E		; $0E7A data
	dc.b	$11,$0A,$36,$25,$12,$CD,$3E,$11,$3A,$A1,$00,$F6,$05,$32,$A1,$00		; $0E8A data
	dc.b	$36,$27,$12,$D9,$01,$4A,$18,$D9,$C9,$F8,$00,$F8,$01,$F8,$02,$F8		; $0E9A data
	dc.b	$03,$F9,$00,$F9,$01,$F9,$02,$F9,$03,$FA,$00,$FA,$01,$FA,$02,$FA		; $0EAA data
	dc.b	$03,$FB,$00,$FB,$01,$FB,$02,$FB,$03,$FC,$00,$FC,$01,$FC,$02,$FC		; $0EBA data
	dc.b	$03,$FD,$00,$FD,$01,$FD,$02,$FD,$03,$FE,$00,$FE,$01,$FE,$02,$FE		; $0ECA data
	dc.b	$03,$FF,$00,$FF,$01,$FF,$02,$FF,$03,$3A,$98,$00,$C6,$00,$6F,$26		; $0EDA data
	dc.b	$03,$7E,$3C,$4F,$06,$00,$CB,$21,$CB,$10,$3A,$D3,$00,$3C,$5F,$16		; $0EEA data
	dc.b	$00,$CB,$23,$CB,$12,$CD,$5A,$11,$41,$4A,$DD,$21,$C8,$13,$21,$00		; $0EFA data
	dc.b	$80,$16,$80,$DD,$74,$00,$DD,$2B,$37,$3F,$ED,$42,$15,$20,$F4,$CD		; $0F0A data
	dc.b	$53,$10,$DD,$21,$C8,$13,$21,$00,$80,$16,$80,$DD,$74,$00,$DD,$23		; $0F1A data
	dc.b	$09,$15,$20,$F7,$CD,$53,$10,$C9,$3A,$98,$00,$CD,$19,$09,$32,$95		; $0F2A data
	dc.b	$00,$CD,$23,$09,$DD,$22,$96,$00,$3E,$00,$32,$94,$00,$CD,$53,$10		; $0F3A data
	dc.b	$3A,$94,$00,$C6,$40,$6F,$3E,$12,$CE,$00,$67,$3A,$BB,$00,$A6,$28		; $0F4A data
	dc.b	$2C,$3A,$94,$00,$C6,$D4,$6F,$26,$00,$3A,$98,$00,$BE,$20,$1E,$2A		; $0F5A data
	dc.b	$96,$00,$7E,$B7,$20,$05,$CD,$61,$0B,$18,$12,$FE,$01,$20,$05,$CD		; $0F6A data
	dc.b	$1B,$0E,$18,$09,$FE,$02,$20,$05,$CD,$1D,$0E,$18,$00,$3A,$94,$00		; $0F7A data
	dc.b	$3C,$32,$94,$00,$FE,$06,$20,$B5,$C9,$3A,$98,$00,$CD,$19,$09,$32		; $0F8A data
	dc.b	$95,$00,$CD,$23,$09,$DD,$22,$96,$00,$3E,$00,$32,$94,$00,$CD,$53		; $0F9A data
	dc.b	$10,$3A,$94,$00,$C6,$40,$6F,$3E,$12,$CE,$00,$67,$3A,$BB,$00,$A6		; $0FAA data
	dc.b	$28,$35,$3A,$94,$00,$C6,$D4,$6F,$26,$00,$3A,$98,$00,$BE,$20,$27		; $0FBA data
	dc.b	$C6,$80,$6F,$26,$02,$7E,$B7,$28,$1E,$2A,$96,$00,$7E,$B7,$20,$05		; $0FCA data
	dc.b	$CD,$61,$0B,$18,$12,$FE,$01,$20,$05,$CD,$1B,$0E,$18,$09,$FE,$02		; $0FDA data
	dc.b	$20,$05,$CD,$1D,$0E,$18,$00,$3A,$94,$00,$3C,$32,$94,$00,$FE,$06		; $0FEA data
	dc.b	$20,$AC,$C9,$3E,$00,$32,$94,$00,$CD,$53,$10,$3A,$94,$00,$C6,$40		; $0FFA data
	dc.b	$6F,$3E,$12,$CE,$00,$67,$3A,$BB,$00,$A6,$28,$2F,$3A,$94,$00,$C6		; $100A data
	dc.b	$D4,$6F,$26,$00,$3A,$98,$00,$BE,$20,$21,$2A,$96,$00,$7E,$B7,$20		; $101A data
	dc.b	$05,$CD,$B9,$0C,$18,$15,$FE,$01,$20,$05,$CD,$1C,$0E,$18,$0C,$FE		; $102A data
	dc.b	$02,$20,$05,$CD,$1E,$0E,$18,$03,$CD,$E3,$0E,$3A,$94,$00,$3C,$32		; $103A data
	dc.b	$94,$00,$FE,$06,$20,$B2,$C9		; $104A data
; Interrupt vector target: reti.
Z80IrqReturn
	dc.b	$ED,$4D		; $1051 reti
; Feeds the next PCM sample to the YM2612 DAC (register $2A); called from every wait loop.
Z80DacService
	dc.b	$D9		; $1053 exx
	dc.b	$CB,$46		; $1054 bit 0,(hl)
	dc.b	$28,$73		; $1056 jr z,$10CB
	dc.b	$08		; $1058 ex af,af'
	dc.b	$3A,$A1,$00		; $1059 ld a,($00A1)
	dc.b	$F6,$10		; $105C or $10
	dc.b	$CB,$7E		; $105E bit 7,(hl)
	dc.b	$20,$FC		; $1060 jr nz,$105E
	dc.b	$36,$27		; $1062 ld (hl),$27
	dc.b	$12		; $1064 ld (de),a
	dc.b	$0A		; $1065 ld a,(bc)
	dc.b	$03		; $1066 inc bc
	dc.b	$B7		; $1067 or a
	dc.b	$28,$11		; $1068 jr z,$107B
	dc.b	$FE,$FF		; $106A cp $FF
	dc.b	$28,$26		; $106C jr z,$1094
	dc.b	$FE,$FE		; $106E cp $FE
	dc.b	$28,$4D		; $1070 jr z,$10BF
	dc.b	$CB,$7E		; $1072 bit 7,(hl)
	dc.b	$20,$FC		; $1074 jr nz,$1072
	dc.b	$36,$2A		; $1076 ld (hl),$2A
	dc.b	$12		; $1078 ld (de),a
	dc.b	$18,$4F		; $1079 jr $10CA
	dc.b	$CB,$7E		; $107B bit 7,(hl)
	dc.b	$20,$FC		; $107D jr nz,$107B
	dc.b	$36,$27		; $107F ld (hl),$27
	dc.b	$3A,$A1,$00		; $1081 ld a,($00A1)
	dc.b	$E6,$FA		; $1084 and $FA
	dc.b	$12		; $1086 ld (de),a
	dc.b	$32,$A1,$00		; $1087 ld ($00A1),a
	dc.b	$3A,$BB,$00		; $108A ld a,($00BB)
	dc.b	$F6,$20		; $108D or $20
	dc.b	$32,$BB,$00		; $108F ld ($00BB),a
	dc.b	$18,$36		; $1092 jr $10CA
	dc.b	$3A,$92,$00		; $1094 ld a,($0092)
	dc.b	$B7		; $1097 or a
	dc.b	$28,$03		; $1098 jr z,$109D
	dc.b	$0B		; $109A dec bc
	dc.b	$18,$2D		; $109B jr $10CA
	dc.b	$3A,$A2,$00		; $109D ld a,($00A2)
	dc.b	$B7		; $10A0 or a
	dc.b	$20,$0E		; $10A1 jr nz,$10B1
	dc.b	$3C		; $10A3 inc a
	dc.b	$32,$A2,$00		; $10A4 ld ($00A2),a
	dc.b	$3E,$02		; $10A7 ld a,$02
	dc.b	$32,$92,$00		; $10A9 ld ($0092),a
	dc.b	$01,$49,$16		; $10AC ld bc,$1649
	dc.b	$18,$B4		; $10AF jr $1065
	dc.b	$3D		; $10B1 dec a
	dc.b	$32,$A2,$00		; $10B2 ld ($00A2),a
	dc.b	$3E,$03		; $10B5 ld a,$03
	dc.b	$32,$92,$00		; $10B7 ld ($0092),a
	dc.b	$01,$48,$14		; $10BA ld bc,$1448
	dc.b	$18,$A6		; $10BD jr $1065
	dc.b	$0B		; $10BF dec bc
	dc.b	$3A,$92,$00		; $10C0 ld a,($0092)
	dc.b	$B7		; $10C3 or a
	dc.b	$20,$04		; $10C4 jr nz,$10CA
	dc.b	$3E,$01		; $10C6 ld a,$01
	dc.b	$18,$E7		; $10C8 jr $10B1
	dc.b	$08		; $10CA ex af,af'
	dc.b	$D9		; $10CB exx
	dc.b	$C9		; $10CC ret
	dc.b	$21,$00,$40,$CB,$4E,$28,$59,$3A,$A1,$00,$F6,$20,$CD,$3E,$11,$36		; $10CD data
	dc.b	$27,$23,$77,$3E,$00,$32,$98,$00,$CD,$53,$10,$3A,$98,$00,$C6,$80		; $10DD data
	dc.b	$6F,$26,$05,$46,$3A,$98,$00,$C6,$00,$6F,$26,$05,$7E,$80,$77,$CB		; $10ED data
	dc.b	$3F,$CB,$3F,$CB,$3F,$CB,$3F,$C6,$2E,$6F,$3E,$11,$CE,$00,$67,$46		; $10FD data
	dc.b	$3A,$98,$00,$C6,$80,$6F,$26,$04,$78,$BE,$28,$04,$70,$CD,$93,$0F		; $110D data
	dc.b	$3A,$98,$00,$3C,$32,$98,$00,$FE,$80,$20,$BD,$3E,$00,$32,$94,$00		; $111D data
	dc.b	$C9,$00,$20,$40,$60,$80,$A0,$C0,$E0,$FF,$E0,$C0,$A0,$80,$60,$40		; $112D data
	dc.b	$20		; $113D data
; Waits until the YM2612 busy flag (bit 7 at $4000) clears.
Z80YmWaitReady
	dc.b	$E5		; $113E push hl
	dc.b	$21,$00,$40		; $113F ld hl,$4000
	dc.b	$CB,$7E		; $1142 bit 7,(hl)
	dc.b	$20,$FC		; $1144 jr nz,$1142
	dc.b	$E1		; $1146 pop hl
	dc.b	$C9		; $1147 ret
	dc.b	$2E,$00,$67,$48,$06,$00,$3E,$08,$29,$30,$01,$09,$3D,$20,$F9,$E5		; $1148 data
	dc.b	$C1,$C9,$C5,$E1,$01,$00,$00,$FD,$21,$00,$00,$3E,$10,$FD,$29,$ED		; $1158 data
	dc.b	$6A,$30,$04,$FD,$19,$ED,$4A,$3D,$20,$F3,$E5,$C1,$FD,$E5,$D1,$C9		; $1168 data
	dc.b	$84,$02,$AA,$02,$D3,$02,$FE,$02,$2B,$03,$5C,$03,$8F,$03,$C5,$03		; $1178 data
	dc.b	$FE,$03,$3B,$04,$7B,$04,$C0,$04,$84,$0A,$AA,$0A,$D3,$0A,$FE,$0A		; $1188 data
	dc.b	$2B,$0B,$5C,$0B,$8F,$0B,$C5,$0B,$FE,$0B,$3B,$0C,$7B,$0C,$C0,$0C		; $1198 data
	dc.b	$84,$12,$AA,$12,$D3,$12,$FE,$12,$2B,$13,$5C,$13,$8F,$13,$C5,$13		; $11A8 data
	dc.b	$FE,$13,$3B,$14,$7B,$14,$C0,$14,$84,$1A,$AA,$1A,$D3,$1A,$FE,$1A		; $11B8 data
	dc.b	$2B,$1B,$5C,$1B,$8F,$1B,$C5,$1B,$FE,$1B,$3B,$1C,$7B,$1C,$C0,$1C		; $11C8 data
	dc.b	$84,$22,$AA,$22,$D3,$22,$FE,$22,$2B,$23,$5C,$23,$8F,$23,$C5,$23		; $11D8 data
	dc.b	$FE,$23,$3B,$24,$7B,$24,$C0,$24,$84,$2A,$AA,$2A,$D3,$2A,$FE,$2A		; $11E8 data
	dc.b	$2B,$2B,$5C,$2B,$8F,$2B,$C5,$2B,$FE,$2B,$3B,$2C,$7B,$2C,$C0,$2C		; $11F8 data
	dc.b	$84,$32,$AA,$32,$D3,$32,$FE,$32,$2B,$33,$5C,$33,$8F,$33,$C5,$33		; $1208 data
	dc.b	$FE,$33,$3B,$34,$7B,$34,$C0,$34,$84,$3A,$AA,$3A,$D3,$3A,$FE,$3A		; $1218 data
	dc.b	$2B,$3B,$5C,$3B,$8F,$3B,$C5,$3B,$FE,$3B,$3B,$3C,$7B,$3C,$C0,$3C		; $1228 data
	dc.b	$01,$02,$04,$08,$10,$20,$40,$80,$FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F		; $1238 data
	dc.b	$7F,$74,$68,$60,$5A,$55,$51,$4D,$4A,$47,$44,$42,$40,$3E,$3C,$3A		; $1248 data
	dc.b	$38,$37,$35,$34,$32,$31,$30,$2F,$2D,$2C,$2B,$2A,$29,$28,$27,$27		; $1258 data
	dc.b	$26,$25,$24,$23,$22,$22,$21,$20,$20,$1F,$1E,$1E,$1D,$1C,$1C,$1B		; $1268 data
	dc.b	$1B,$1A,$1A,$19,$19,$18,$17,$17,$16,$16,$16,$15,$15,$14,$14,$13		; $1278 data
	dc.b	$13,$12,$12,$12,$11,$11,$10,$10,$10,$0F,$0F,$0E,$0E,$0E,$0D,$0D		; $1288 data
	dc.b	$0D,$0C,$0C,$0C,$0B,$0B,$0B,$0A,$0A,$0A,$09,$09,$09,$09,$08,$08		; $1298 data
	dc.b	$08,$07,$07,$07,$07,$06,$06,$06,$06,$05,$05,$05,$04,$04,$04,$04		; $12A8 data
	dc.b	$03,$03,$03,$03,$02,$02,$02,$02,$02,$01,$01,$01,$01,$00,$00,$00		; $12B8 data
	dc.b	$FF,$F8,$F0,$E6,$DE,$D6,$D0,$C8,$C0,$BA,$B2,$AC,$A6,$A0,$9A,$94		; $12C8 data
	dc.b	$90,$8A,$86,$80,$7C,$78,$74,$6E,$6A,$68,$64,$60,$5C,$58,$56,$52		; $12D8 data
	dc.b	$50,$4C,$4A,$48,$46,$44,$42,$40,$3C,$3A,$38,$36,$34,$32,$31,$30		; $12E8 data
	dc.b	$2E,$2C,$2A,$29,$28,$26,$25,$24,$22,$21,$20,$1F,$1E,$1D,$1C,$1B		; $12F8 data
	dc.b	$1A,$19,$18,$17,$16,$15,$15,$14,$13,$12,$12,$11,$11,$10,$10,$0F		; $1308 data
	dc.b	$0F,$0E,$0E,$0D,$0D,$0C,$0C,$0C,$0B,$0B,$0A,$0A,$0A,$0A,$09,$09		; $1318 data
	dc.b	$08,$08,$08,$07,$07,$07,$06,$06,$06,$06,$05,$05,$05,$05,$05,$04		; $1328 data
	dc.b	$04,$04,$04,$04,$04,$03,$03,$03,$03,$02,$02,$02,$01,$01,$01,$00		; $1338 data
	dcb.b	$300,0		; $1348 zero fill
	dc.b	$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $1648 data
	dcb.b	$1F1,0		; $1658 zero fill
	dc.b	$FF,$FE,$03,$00,$C0,$00,$00		; $1849 data
