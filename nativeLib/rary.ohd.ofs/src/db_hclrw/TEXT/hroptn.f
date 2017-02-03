C MEMBER HROPTN
C  (from old member HCLROPTN)
C-----------------------------------------------------------------------
C
C                             LAST UPDATE: 06/28/95.13:05:25 BY $WC20SV
C
C @PROCESS LVL(77)
C
      SUBROUTINE HROPTN (ISTAT)
C
C          ROUTINE:  HROPTN
C
C             VERSION:  1.0.0
C
C                DATE:  9-9-81
C
C              AUTHOR:  SONJA R SIEGEL
C                       DATA SCIENCES INC
C
C***********************************************************************
C
C          DESCRIPTION:
C
C    THIS ROUTINE READS CARDS TO ENTER A RUN-TIME OPTION
C    INTO THE SEQUENTIAL RUN-TIME OPTION FILE.
C
C    ANY INCLUDES ARE EXPANDED.
C
C    RUN-TIME OPTIONS CAN BE FUNCTION SPECIFIC SO ANY TECHNIQUES ARE
C    CHECKED TO SEE IF THEY ARE PART OF THE SPECFIED FUNCTION.
C
C***********************************************************************
C
C          ARGUMENT LIST:
C
C         NAME    TYPE  I/O   DIM   DESCRIPTION
C
C       ISTAT      I     O     1    STATUS 0=OK, >0=ERROR
C
C***********************************************************************
C
C          COMMON:
C
      INCLUDE 'uio'
      INCLUDE 'udebug'
      INCLUDE 'udatas'
      INCLUDE 'ufreei'
      INCLUDE 'common/x'
      INCLUDE 'hclcommon/hword2'
      INCLUDE 'hclcommon/hcomnd'
      INCLUDE 'hclcommon/hindx'
      INCLUDE 'hclcommon/hunits'
C
C***********************************************************************
C
C          DIMENSION AND TYPE DECLARATIONS:
C
      DIMENSION IWORKB(15000),IOPTRC(85000)
      DIMENSION NAME(2),ITSET(60)
      DIMENSION ISVINC(3,10)
      DIMENSION IXBUF(4)
C
      EQUIVALENCE (X(1),IWORKB(1)),(X(15001),IOPTRC(1))
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/db_hclrw/RCS/hroptn.f,v $
     . $',                                                             '
     .$Id: hroptn.f,v 1.1 1995/09/17 18:43:04 dws Exp $
     . $' /
C    ===================================================================
C
C
C***********************************************************************
C
C          DATA:
C
      DATA LMOD/4HMOD /
C
C***********************************************************************
C
C
      MWORKB=15000
      MOPTRC=135000
      MAXSET=60
      MSAVED=10
C
      ISTAT=0
C
C  CHECK SIZE OF WORK ARRAYS
      MINXSZ=MWORKB+MOPTRC
      IF (MX.LT.MINXSZ) THEN
C     NOT ENOUGH ROOM AVALIABLE
         CALL ULINE (LP,2)
         WRITE (LP,10) MINXSZ,MX
10    FORMAT ('0**ERROR** IN HROPTN - ',I6,' WORDS ARE ',
     *   'NEEDED FOR ARRAYS IWORKB AND IOPTRC BUT ONLY ',I6,
     *   ' ARE AVALIABLE.')
         CALL ERROR
         ISTAT=1
         GO TO 555
         ENDIF
      IF (MX.GT.MINXSZ) THEN
C     MORE ROOM AVALIABLE
         CALL ULINE (LP,2)
         WRITE (LP,15) MINXSZ,MX
15    FORMAT ('0**NOTE** IN HROPTN - ',I6,' WORDS ARE ',
     *   'NEEDED FOR ARRAYS IWORKB AND IOPTRC BUT ',I6,
     *   ' ARE AVALIABLE.')
         ENDIF
C
20    NSAVED=0
C
C READ FIRST CARD FROM CARD IMAGE BUFFER
      NNC=1
      CALL HCARDR (NNC,IERR)
      IF (IERR.NE.0) THEN
         ISTAT=IERR
         GO TO 550
         ENDIF
C
C  CHECK FOR OPTION QUALIFIERS
      IFUN=0
      IFIELD=2
      IF (NFIELD.EQ.1) GO TO 70
      J=IFSTRT(IFIELD)
      N=IFSTOP(IFIELD)-J+1
      IF (N.GT.8) N=8
      CALL UMEMST (IBLNK,NAME,2)
      CALL UPACK1 (IBUF(J),NAME,N)
C
C  CHECK FOR LETTERS 'ALL'
      IF (NAME(1).EQ.LALL) GO TO 70
C
C  CHECK IF FUNCTION IS DEFINED
      ITYPE=2
      CALL HGTRCD (ITYPE,NAME,MWORKB,IWORKB,IERR)
      IF (IERR.EQ.0) GO TO 40
      CALL ULINE (LP,2)
      WRITE (LP,30) NAME
30    FORMAT ('0**ERROR** FUNCTION ',2A4,' NOT DEFINED.')
      ISTAT=IERR
      GO TO 550
C
40    IFUN=IWORKB(2)
C
C  SET UP SAVE TECHNIQUE ARRAY
      NTSET=0
      CALL UMEMST (0,ITSET,MAXSET)
C
      IF (IWORKB(9).EQ.0) GO TO 70
      IF (IWORKB(9).LE.MAXSET) GO TO 60
      CALL ULINE (LP,2)
      WRITE (LP,50) MAXSET
50    FORMAT ('0**ERROR** IN HROPTN - MORE THAN ',I3,
     *   'TECHNIQUES IN FUNCTION.')
      ISTAT=1
      GO TO 550
C
60    CALL UMEMOV (IWORKB(10),ITSET,IWORKB(9))
      NTSET=IWORKB(9)
C
70    IFIELD=IFIELD+1
      CALL UMEMST (0,IOPTRC,MOPTRC)
      IOPTRC(2)=IFUN
      NXOPT=2
C
C  CHECK FOR INCLUDES, MODS, TECHNIQUES
80    IF (IFIELD.LE.NFIELD) GO TO 100
90    IF (NCARD.EQ.NNC) GO TO 480
      NNC=NNC+1
      CALL HCARDR (NNC,IERR)
      IF (IERR.NE.0) THEN
         ISTAT=IERR
         GO TO 550
         ENDIF
      IFIELD=1
100   J=IFSTRT(IFIELD)
      NXOPT=NXOPT+1
      NXSAV=NXOPT
      N=IFSTOP(IFIELD)-J+1
C
C  CHECK FOR TECHNIQUE SETTING WITHIN PARENTHESES IN SAME FIELD
      ILP=0
      IRP=0
      CALL HFLPRN (J,IFSTOP(IFIELD),ILP)
      IF (ILP.EQ.0) GO TO 130
      N=ILP-J
      CALL HFRPRN (J,IFSTOP(IFIELD),IRP)
      IF (IRP.EQ.IFSTOP(IFIELD)) GO TO 120
      CALL ULINE (LP,2)
      WRITE (LP,110) IFIELD
110   FORMAT ('0**ERROR** MISSING RIGHT PAREN IN FIELD ',I2,'.')
      ISTAT=1
      GO TO 130
120   IFSTOP(IFIELD)=IFSTOP(IFIELD)-1
130   IF (N.GT.8) N=8
      CALL UMEMST (IBLNK,NAME,2)
      CALL UPACK1 (IBUF(J),NAME,N)
C
C  CHECK FOR INCLUDE
      IF (NAME(1).EQ.LINCLD(1).AND.NAME(2).EQ.IBLNK) GO TO 140
      CALL UNAMCP (NAME,LINCLD,IMATCH)
      IF (IMATCH.NE.0) GO TO 340
C
C  FOUND AN INCLUDE - CHECK FOR NAMED OPTION
140   IFIELD=IFIELD+1
      IF (IFIELD.LE.NFIELD) GO TO 160
      CALL ULINE (LP,2)
      WRITE (LP,150) IFIELD
150   FORMAT ('0**ERROR** OPTION NAME EXPECTED IN FIELD ',I2,'.')
      ISTAT=1
      GO TO 90
160   J=IFSTRT(IFIELD)
      N=IFSTOP(IFIELD)-J+1
      IF (N.GT.8) N=8
      CALL UMEMST (IBLNK,NAME,2)
      CALL UPACK1 (IBUF(J),NAME,N)
      ITYPE=4
      NO=7
C
C  DECREASE NXOPT TO BEGINNING OF THIS OPTION
      NXOPT=NXOPT-1
      IFIELD=IFIELD+1
170   CALL HGTRCD (ITYPE,NAME,MWORKB,IWORKB,IERR)
      IF (IERR.EQ.0) GO TO 180
      ISTAT=1
      GO TO 90
C
C NAMED OPTION IS IN IWORKB
C MOVE IN EACH OPTION - NO PROVISION FOR INCLUDE NOW
C LATER ADD CODE TO WRITE REST OF IWORKB TO FILE AND THEN PROCESS NEW
C INCLUDE
C
180   NW=IWORKB(NO)+1
      IF (IWORKB(NO)) 190,310,320
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  PROCESS AN INCLUDE
C
C  MAKE SURE THERE IS ROOM TO SAVE NAME OF OPTION
190   IF (NSAVED.LT.MSAVED) GO TO 210
      CALL ULINE (LP,2)
      WRITE (LP,200) MSAVED
200   FORMAT ('0**WARNING** INCLUDES NESTED TO MAXIMUM OF ',I3,
     *  ' LEVELS. ADDITIONAL INCLUDES IGNORED.')
      CALL WARN
      NO=NO+1
      GO TO 180
C
C INCREMENT NUMBER OF INCLUDES SAVED
210   NSAVED=NSAVED+1
C
C SAVE NAME OF NAMED OPTION
      IF (IHCLDB.GT.1) WRITE (IOGDB,220) NSAVED,NO
220   FORMAT (' SAVING NAMED OPTION, NSAVED=',I4,' NO=',I4)
      CALL UMEMOV (NAME,ISVINC(1,NSAVED),2)
      ISVINC(3,NSAVED)=NO+1
C
C  GET NEW NAMED OPTION USING INTERNAL OPTION NUMBER
      IF (IHCLDB.GT.1) WRITE (IOGDB,230) IWORKB(NO)
230   FORMAT (' ABOUT TO EXPAND OPTION',I5)
      IOPINX=HINDEX(2,4)-1-IWORKB(NO)
      CALL UREADT (KINDXL,IOPINX,IXBUF,IERR)
      IF (IERR.EQ.0) GO TO 250
      CALL ULINE (LP,2)
      WRITE (LP,240) IERR
240   FORMAT ('0**ERROR** TRYING TO READ LOCAL INDEX FILE - IERR=',I5)
      ISTAT=IERR
      GO TO 550
C
C  READ THE OPTION
250   IF (IXBUF(4).EQ.-IWORKB(NO)) GO TO 270
      CALL ULINE (LP,2)
      WRITE (LP,260) IXBUF,IWORKB(NO)
260   FORMAT ('0**ERROR** INDEX DOES NOT MATCH OPTION - IXBUF=',2A4,
     *        2I5,' IWORKB=',I5)
      ISTAT=1
      GO TO 550
C
270   IOPREC=IXBUF(3)
      IF (IHCLDB.GT.1) WRITE (IOGDB,280) IXBUF
280   FORMAT (' INDEX RECORD FOR OPTION=',2A4,2I5)
      CALL HGTRDN (KDEFNL,IOPREC,IWORKB,MWORKB,ISTAT)
      IF (ISTAT.EQ.0) GO TO 300
      CALL ULINE (LP,2)
      WRITE (LP,290) ISTAT
290   FORMAT ('0**ERROR** IN HGTRDN - HGTRDN ISTAT=',I5)
      GO TO 550
C
300   CALL UMEMOV (IWORKB(4),NAME,2)
      NO=7
      GO TO 180
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF ANY OTHER INCLUDES TO BE COMPLETED
310   IF (NSAVED.EQ.0) GO TO 90
C
C  RESTORE THE NAME
      CALL UMEMOV (ISVINC(1,NSAVED),NAME,2)
      NO=ISVINC(3,NSAVED)
      NSAVED=NSAVED-1
      GO TO 170
C
320   IF (NXOPT+NW.GT.MOPTRC) GO TO 520
      IF (IHCLDB.GT.1) WRITE (IOGDB,330) NXOPT,NO,NW
330   FORMAT (' IN HROPTN - MOVING NAME OPTION,NXOPT=',I4,' NO=',I4,
     *       ' NW=',I4)
      CALL UMEMOV (IWORKB(NO),IOPTRC(NXOPT+1),NW)
      NXOPT=NXOPT+NW
      NO=NO+NW
      GO TO 180
C
C  CHECK FOR MODS
340   IF (NAME(1).NE.LMOD) GO TO 370
C
C  CHECK IDENTIFIERS
      NXOPT=NXOPT+2
      IF (NFIELD.EQ.1) GO TO 360
      CALL ULINE (LP,2)
      WRITE (LP,350)
350   FORMAT ('0**WARNING** IN HROPTN - IDENTIFIERS IGNORED ON MOD ',
     *   'CARD.')
      CALL WARN
C
360   CALL HMODCD (NNC,IOPTRC,NXOPT,MOPTRC,ISTAT)
      IF (ISTAT.NE.0) GO TO 90
      IOPTRC(NXSAV)=NXOPT-NXSAV
      GO TO 90
C
C  CHECK FOR A TECHNIQUE
370   IT=3
      CALL HGTRCD (IT,NAME,MWORKB,IWORKB,IERR)
      IF (IERR.EQ.0) GO TO 390
      CALL ULINE (LP,2)
      WRITE (LP,380) NAME
380   FORMAT ('0**ERROR** TECHNIQUE ',2A4,' NOT DEFINED.')
      ISTAT=IERR
      GO TO 90
C
C  SET UP TECHNIQUE
390   IGL=1
      IF (IWORKB(3).LT.0) IGL=-1
      ITN=IWORKB(2)*IGL
      IF (IOPTRC(2).EQ.0) GO TO 430
C
C MAKE SURE TECHNIQUE VALID FOR FUNCTION
      IF (NTSET.EQ.0) GO TO 410
      DO 400 I=1,NTSET
         IF (ITN.EQ.ITSET(I)) GO TO 430
400      CONTINUE
C
410   CALL ULINE (LP,2)
      WRITE (LP,420) NAME,IFUN
420   FORMAT ('0**ERROR** TECHNIQUE ',2A4,' NOT VALID FOR FUNCTION ',I4,
     *   '.')
      ISTAT=1
       GO TO 90
C
C  CHECK FOR Y N OR INTEGER
430   NXOPT=NXOPT+1
      IOPTRC(NXOPT)=ITN
      IOPTRC(NXOPT+1)=1
      IF (IRP.NE.0) GO TO 440
C
C  SAVE A WORD FOR TECH ON
      IFIELD=IFIELD+1
      NXOPT=NXOPT+1
      GO TO 450
C
440   CALL HCKYNI (ILP,IFIELD,IOPTRC,NXOPT,ISTAT)
C
C  CHECK FOR UNIVERSAL TECHNIQUE (NO IDS ALLOWED)
450   IF (IWORKB(7).EQ.0) GO TO 460
C
C LEAVE WORD FOR 0 IDS
      NXOPT=NXOPT+1
      GO TO 470
C
C  CHECK FOR IDENTIFIERS
460   CALL HCKIDS (IFIELD,IOPTRC,NXOPT,NNC,ISTAT)
C
C  CHECK FOR ARGUMENT VALUE
470   CALL HCKTAG (IWORKB,IFIELD,IOPTRC,NXOPT,NNC,ISTAT)
C
C  SET NUMBER OF WORDS
      IOPTRC(NXSAV)=NXOPT-NXSAV
      GO TO 80
C
C  DONE - SET LAST WORD TO ZERO TO INDICATE END
480   IF (ISTAT.NE.0) GO TO 500
      NXOPT=NXOPT+1
      CALL HWROPT (NXOPT,IOPTRC,ISTAT)
      IF (ISTAT.NE.0) GO TO 500
      CALL ULINE (LP,2)
      WRITE (LP,490)
490   FORMAT ('0**NOTE** RUN-TIME OPTIONS ENTERED.')
      CALL HPRTOG (IOPTRC,IWORKB,MWORKB)
      GO TO 550
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
500   CALL ULINE (LP,2)
      WRITE (LP,510)
510   FORMAT ('0**ERROR** RUN-TIME OPTIONS NOT ENTERED.')
      GO TO 550
C
520   CALL ULINE (LP,2)
      WRITE (LP,540)
540   FORMAT ('0**ERROR** IN HROPTN - RUN-TIME OPTION RECORD TOO ',
     *   'SMALL.')
C
550   IF (IHCLDB.GT.1) WRITE (IOGDB,560) (IOPTRC(J),J=1,NXOPT)
560   FORMAT (' IN HROPTN - IOPTRC=',5I5,(/1X,20I5))
C
555   RETURN
C
      END