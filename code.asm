MAIN	JSUB	SCANN
	LDA	N
	MUL	#3
	STA	MULTN
	JSUB	PARSE
	LDX	#0
MNLOOP1	RMO	X, A
	COMP	MULTN
	JLT	MJUM
	J	STOP
MJUM	LDA	ARY, X
	STA	NBUF1
	JSUB	FACT
	RMO	X, A
	ADD	#3
	RMO	A, X
	J	MNLOOP1
	J	STOP
FACT	STA	TMPA
	STX	TMPX
	STL	TMPL2
	LDA	#1
	STA	PFLAG
	LDA	#2
	STA	FINDEX
	LDA	#0
	STA	MFLAG
	LDA	NBUF1
	STA	FACTBUF
	STA	PRBUF
FLOOP1	LDA	FINDEX
	COMP	FACTBUF
	JLT	FLOOP2
	JEQ	FLOOP2
	J	FIFNPRI
FIFPRI	LDA	#80
	WD	STDOUT
FIFNPRI LDA	#10
	WD	STDOUT
	LDA	TMPA
	LDX	TMPX
	LDL	TMPL2
	RSUB
FLOOP2	LDA	FACTBUF
	STA	MBUF1
	LDA	FINDEX
	STA	MBUF2
	JSUB	MOD
	LDA	MBUF3
	COMP	#0
	JEQ	FLOOP3
	JLT	FLOOP3
	LDA	FINDEX
	ADD	#1
	STA	FINDEX
	COMP	PRBUF
	JEQ	FIFPRI
	J	FLOOP1
FLOOP3	LDA	MFLAG
	COMP	#0
	JEQ	FCON1
	LDA	#42
	WD	STDOUT
FCON1	LDA	#1
	STA	MFLAG
	LDA	FACTBUF
	DIV	FINDEX
	STA	FACTBUF
	LDA	FINDEX
	STA	NBUF1
	JSUB	NTOA
	JSUB	REVERS
	JSUB	PRINT2
	LDA	#0
	STA	PFLAG
	J	FLOOP2
ATON	STX	TMPX
	STA	TMPA
	STT	TMPT
	LDT	SLEN1
	LDX	#0
	LDA	#0
	STA	NBUF1
ALOOP	LDA	NBUF1
	MUL	#10
	STA	NBUF1
	LDA	#0
	LDCH	SBUF1, X
	SUB	ZERO
	ADD	NBUF1
	STA	NBUF1
	TIXR	T
	JLT	ALOOP
	LDA	TMPA
	LDT	TMPT
	LDX	TMPX
	RSUB
MOD	STA	TMPA
	LDA	MBUF1
MLOOP1	COMP	MBUF2
	JGT	MLOOP2
	JEQ	MLOOP2
	STA	MBUF3
	LDA	TMPA
	RSUB
MLOOP2	SUB	MBUF2
	J	MLOOP1
NTOA	STX	TMPX
	STA	TMPA
	STL	TMPL
	STT	TMPT
	LDX	#0
	LDA	#0
	STA	SLEN1
	LDA	#10
	STA	MBUF2
	LDA	NBUF1
NLOOP1	COMP	#0
	JEQ	NEND
	STA	MBUF1
	JSUB	MOD
	DIV	#10
	RMO	A, T
	LDA	MBUF3
	ADD	ZERO
	STCH	SBUF1, X
	LDA	SLEN1
	ADD	#1
	STA	SLEN1
	RMO	X, A
	ADD	#1
	RMO	A, X
	RMO	T, A
	J	NLOOP1
NEND	LDA	TMPA
	LDT	TMPT
	LDX	TMPX
	LDL	TMPL
	RSUB
PARSE	STX	TMPX
	STL	TMPL
	STA	TMPA
	LDA	#0
	STA	PTRBUF
PLOOP3	LDA	#0
	STA	SLEN1
	LDX	#0
PLOOP1	TD	STDIN
	RD	STDIN
	STCH	CBUF
	JSUB	ISNUM
	STCH	SBUF1, X
	TIX	#0
	COMP	SPACE
	JEQ	PLOOP2
	COMP	ENTER
	JEQ	PLOOP2
	LDA	SLEN1
	ADD	#1
	STA	SLEN1
	J	PLOOP1
PLOOP2	LDA	PTRBUF
	RMO	A, X
	JSUB	ATON
	LDA	NBUF1
	COMP	#999
	JGT	EROVR
	COMP	#2
	JLT	EROVR
	STA	ARY, X
	RMO	X, A
	ADD	#3
	STA	PTRBUF
	COMP	MULTN
	JGT	ERNUM
	LDCH	CBUF
	COMP	ENTER
	JEQ	PEND
	J	PLOOP3
PEND	LDA	PTRBUF
	COMP	MULTN
	JLT	ERNUM
	JGT	ERNUM
	LDX	TMPX
	LDL	TMPL
	LDA	TMPA
	RSUB
REVERS	STT	TMPT
	STA	TMPA
	STS	TMPS
	STX	TMPX
	LDT	#0
	LDA	SLEN1
	SUB	#1
	RMO	A, S
RLOOP	COMP	SLEN1
	JEQ	REND
	RMO	T, X
	LDCH	SBUF1, X
	STCH	CBUF
	RMO	S, X
	SUBR	T, X
	LDCH	CBUF
	STCH	SBUF2, X
	RMO	T, A
	ADD	#1
	RMO	A, T
	J	RLOOP
REND	LDT	TMPT
	LDA	TMPA
	LDS	TMPS
	LDX	TMPX
	RSUB
ISNUM	STA	TMPA
	LDCH	CBUF
	COMP	ENTER
	JEQ	IEND
	COMP	SPACE
	JEQ	IEND
	COMP	#48
	JLT	ERFOM
	COMP	#57
	JGT	ERFOM
IEND	LDA	TMPA
	RSUB	
PRINT2	STA	TMPA
	STX	TMPX
	LDX	#0
PRLOOP1	LDCH	SBUF2, X
	WD	STDOUT
	TIX	SLEN1
	JLT	PRLOOP1
	LDA	TMPA
	LDX	TMPX
	RSUB
SCANN	STL	TMPL
	LDA	#0
	LDX	#0
	STA	SLEN1
	TD	STDIN
SCLOOP1	RD	STDIN
	STCH	SBUF1, X
	COMP	ENTER
	JEQ	SCEND	
	LDA	SLEN1
	ADD	#1
	STA	SLEN1
	TIX	#10
	JEQ	EROVR
	J	SCLOOP1
SCEND	JSUB	ATON
	LDA	NBUF1
	STA	N
	COMP	#1
	JLT	EROVR
	COMP	#10
	JGT	EROVR
	LDL	TMPL
	RSUB
PRINTE	LDX	#0
	LDA	#0
ERLOP1	LDCH	ERSTR, X
	TIX	#0
	WD	STDOUT
	COMP	EOS
	JEQ	EREND
	J	ERLOP1
EREND	LDA	ENTER
	WD	STDOUT
	RSUB
EROVR	JSUB	PRINTE
	J	STOP
ERFOM	JSUB	PRINTE
	J	STOP
ERNUM	JSUB	PRINTE
	J	STOP
STOP	J	STOP
MULTN	RESW	1
N	RESW	1
ARY	RESW	10
CBUF	RESB	1
SLEN1	WORD	3
SBUF1	RESB	10
SBUF2	RESB	10
NBUF1	WORD	6
MBUF1	WORD	12
MBUF2	WORD	3
MBUF3	RESW	1
PTRBUF	RESW	1
ILEN	RESW	1
TMPA	RESW	1
TMPX	RESW	1
TMPL	RESW	1
TMPS	RESW	1
TMPT	RESW	1
TMPL2	RESW	1
ZERO	WORD	48
STDOUT	BYTE	1
STDIN	BYTE	0
SPACE	WORD	32
ENTER	WORD	10
PFLAG	RESW	1
MFLAG	RESW	1
FINDEX	RESW	1
FACTBUF	RESW	1
PRBUF	RESW	1
EOS	WORD	33
ERSTR	BYTE	C'ERROR OCCUR!'
