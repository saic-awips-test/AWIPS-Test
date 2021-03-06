C MODULE MATCHN
C----------------------------------------------------------------------
C
C
C     DESC - THIS SUBROUTINE PERFORMS THE MATCHNG MOD
C
      SUBROUTINE MATCHN(D,MD,TS,MTS,NCARDS,MODCRD,IIDATE,LLDATE,
     1  IHZERO)
C
      LOGICAL FIRST
      CHARACTER*8 TSID,BLANK8,MODNAM
C
      INCLUDE 'ufreex'
      INCLUDE 'common/ionum'
      INCLUDE 'common/fctime'
      INCLUDE 'common/fctim2'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fpwarn'
      INCLUDE 'common/fmodft'
      INCLUDE 'common/flarys'
C
      DIMENSION D(MD),TS(MTS),VALUES(480),DNAME(2)
      DIMENSION OLDOPN(2),MODCRD(20,NCARDS)
      DIMENSION NTEMP(20)
      real temp1(480)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_mods/RCS/matchn.f,v $
     . $',                                                             '
     .$Id: matchn.f,v 1.5 1998/07/02 20:36:27 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA ISLASH/4H/   /,BLANK8/'        '/
      DATA DTYPE/4HMAT /
      DATA DMAT/4HMAT /
      DATA MODNAM/'MATCHNG '/
C
      CALL FSTWHR(8HMATCHN  ,0,OLDOPN,IOLDOP)
C
C     SET DEBUG FLAG
C
      IBUG=IFBUG(4HMODS)+IFBUG(4HMATC)
C
      IF (IBUG.GT.0) WRITE(IODBUG,10) IIDATE,LLDATE
   10 FORMAT(1H0,10X,'*** SUBROUTINE MATCHN ENTERED *** - IIDATE,',
     1 'LLDATE = ',I11,2X,I11,2X,I11)
C
C
      IDATE=IABS(IIDATE)
      LDATE=IABS(LLDATE)
C
C   CHECK IF DATE IS LESS THAN OR EQUAL TO LASTCMPDATE OR LSTCMPDY VALUE
C
      ICOMP=((LDACPD-1)*24)+LHRCPD
      IF ((IDATE.LE.LDATE).AND.(IDATE.LE.ICOMP)) GOTO 20
      IF (LDATE.EQ.ICOMP) GOTO 20
         IF(MODWRN.EQ.0)GO TO 680
         ITYPE=4
         CALL MODS1(NCARDS,36,MODNAM,MODCRD,ITYPE)
         GOTO 680
C
C     SEE IF DATE IS WITHIN RUN PERIOD
C
   20 ISTHR=(IDA-1)*24+IHZERO
      IENHR=(LDA-1)*24+LHR
C
c      IF(IENHR.GE.IDATE.AND.ISTHR.LE.IDATE)GO TO 40
       if(ienhr.ge.idate) goto 40
C
C     START DATE FOR CHANGES AFTER ALLOWABLE WINDOW
C
   25 CALL MDYH2(IDA,IHZERO,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
      CALL MDYH2(LDA,LHR,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
      IXDA=IDATE/24+1
      IXHR=IDATE-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM3,ID3,IY3,IH3,DUM1,DUM2,MODTZC)
C
      IF(MODWRN.EQ.1)
     .WRITE(IPR,30)IM3,ID3,IY3,IH3,MODTZC,IM1,ID1,IY1,IH1,MODTZC,
     1IM2,ID2,IY2,IH2,MODTZC
   30 FORMAT(1H0,10X,'**WARNING** THE STARTING DATE FOR CHANGES ',
     1 'ENTERED IN THE ',
     1 'MATCHNG MOD (',I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/11X,
     2 'IS NOT WITHIN THE CURRENT RUN PERIOD (',I2,1H/,I2,
     3 1H/,I4,1H-,I2,1X,A4,4H TO ,I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/
     4 11X,'THESE CHANGES WILL BE IGNORED.')
      IF(MODWRN.EQ.1)CALL WARN
      GO TO 680
C
C     CALL SUBROUTINE TO READ VALUES
C
   40 MXVALS=480
C
C     INITIALIZE LOCAL VARIABLES
C
      IFLAG=0
      CALL UMEMOV(MODCRD(1,NRDCRD),NTEMP(1),20)
C
C     READ CARD - IF COMMAND LEAVE - IF COMMAND AND 1ST CARD ERROR
C
      FIRST=.TRUE.
      IF(NRDCRD.EQ.NCARDS)GO TO 60
C
   50 IF(NRDCRD.EQ.NCARDS)GO TO 680
C
      TSID=BLANK8
      IDATE=IABS(IIDATE)
      LDATE=IABS(LLDATE)
C
      IF(MISCMD(NCARDS,MODCRD).EQ.0)GO TO 80
C
      IF(.NOT.FIRST)GO TO 680
C
C     HAVE FOUND COMMAND AS FIRST SUBSEQUENT CARD - ERROR
C
   60 IF(MODWRN.EQ.1)WRITE(IPR,70)
   70 FORMAT(1H0,10X,'**WARNING** NO SUBSEQUENT CARDS FOUND FOR THE ',
     1 'MATCHNG MOD.  PROCESSING CONTINUES.')
      GO TO 670
C
   80 FIRST=.FALSE.
C
C     CALL SUBROUTINE TO READ VALUES
C
      NFLD=1
      NRDCRD=NRDCRD+1
C
      CALL MRDVAL(NCARDS,MODCRD,NFLD,MXVALS,NVALS,VALUES,ISTAT)
C
      IF(IBUG.GT.0)WRITE(IODBUG,90)ISTAT,FIRST,NVALS
   90 FORMAT(11X,'**IN MATCHN** AFTER CALL TO MRDVAL - ISTAT=',I3,
     1 ', FIRST=',L4,', NVALS=',I2)
      IF(IBUG.GT.0.AND.NVALS.GT.0.AND.ISTAT.NE.-1)WRITE(IODBUG,100)
     1 (VALUES(I),I=1,NVALS)
  100 FORMAT(11X,'VALUES='/(11X,10G10.2))
C
C     ISTAT RETURNED FROM MRDVAL MEANS
C       =0, VALUES READ OK, NO ADDITIONAL FIELDS ON CARD
C       =2, VALUES READ OK, ADDITIONAL FIELDS ON CARD
C       =-1, NO VALUES ENTERED
C       ELSE, TOO MANY VALUES ENTERED C 
      IF (ISTAT.EQ.0) GOTO 400
      IF (ISTAT.EQ.2) GOTO 140
      IF (ISTAT.EQ.-1) GOTO 120
C
      IF (MODWRN.EQ.0) GOTO 180
      WRITE(IPR,110) MXVALS,NVALS,(MODCRD(I,NRDCRD),I=1,20)
  110 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - MORE THAN ',
     1 I3,' VALUES ENTERED.'/11X,'THE FIRST ',I3,' VALUES ENTERED WILL',
     2 ' BE USED.'/11X,'THE CURRENT CARD IMAGE IS : ',20A4)
      CALL WARN
      GO TO 400
C
  120 IF (MODWRN.EQ.0) GOTO 50
      WRITE(IPR,130) (MODCRD(I,NRDCRD),I=1,20)
  130 FORMAT(1H0,10X,'**WARNING** ',
     1  'NO VALUES ENTERED ON A SUBSEQUENT CARD FOR MATCHNG MOD',/,
     2  11X,'THE CURRENT MOD CARD IMAGE IS : ',20A4)
      GO TO 670
C
C     HAVE ADDITIONAL FIELDS - LOOK FOR A SLASH (/) AND
C     AN TIME SERIES ID - REPROCESS CURRENT FIELD TO SEE IF A SLASH
C
  140 ISTRT=-1
      NCHAR=1
      ICKDAT=0
C
      CALL UFIEL2(NCARDS,MODCRD,NFLD,ISTRT,LEN,ITYPE,NREP,INTGER,REAL,
     1  NCHAR,IFIELD,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,ISTAT)
C
      IF(IFIELD.EQ.ISLASH)GO TO 160
C
      IF(MODWRN.EQ.1)
     .WRITE(IPR,150)(MODCRD(I,NRDCRD),I=1,20)
  150 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - A SLASH ',
     1 'WAS NOT FOUND WHERE EXPECTED ON THE FOLLOWING CARD'/
     2 11X,20A4/11X,'NO CHANGES ENTERED ON THIS CARD WILL BE MADE')
      GO TO 670
C
C     NOW READ TIME SERIES ID
C
  160 ISTRT=-3
      NCHAR=2
      ICKDAT=0
C
      CALL UFIEL2(NCARDS,MODCRD,NFLD,ISTRT,LEN,ITYPE,NREP,INTGER,REAL,
     1  NCHAR,TSID,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,ISTAT)
C
      IF(ISTRT.NE.-2)GO TO 180
      IF(MODWRN.EQ.0)GO TO 50
      WRITE(IODBUG,170)(MODCRD(I,NRDCRD),I=1,20)
  170 FORMAT(11X,'** WARNING ** NO TIME SERIES ID ENTERED ',
     1 'AFTER A SLASH ON THE FOLLOWING MOD CARD'/11X,20A4/
     2 11X,'THIS CARD IS IGNORED.')
      GO TO 670
C
C     FIND STARTING LOCATION IN D ARRAY FOR THIS TIME SERIES ID
C
  180 LOCD=0
      ITIME=6
      CALL FINDTS(TSID,DTYPE,ITIME,LOCD,LOCTS,DIMN)
C
      IF(LOCD.GT.0)GO TO 200
C
C     SHOULD NEVER GET HERE - MEANS PROBLEM IN TS ARRAY
C
      IF (MODWRN.EQ.1) WRITE(IPR,190) TSID,(MODCRD(I,NRDCRD),I=1,20)
  190 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - CANNOT FIND ',
     1 'TIME SERIES ID ',A8,' IN THE TS ARRAY.',/,11X,'THE CURRENT ',
     2 'CARD IMAGE IS : ',20A4)
      GO TO 670
C
C     CHECK TIME PERIOD AGAINST RUN PERIOD - PRINT WARNING ONLY IF
C     ENTIRE PERIOD BEING CHANGED IS OUTSIDE OF RUN PERIOD
C
C     GET TIME INTERVAL FOR RES-SNGL OPERATION FROM POSITIONS 6
C     AND 7 OF THE TS ARRAY
C
  200 CONTINUE
      IDT=TS(LOCTS+5)
      NVPDT=TS(LOCTS+6)
C
c      IF (LDATE.EQ.ICOMP) GOTO 220
c      IFLAG=0
c      NUMVAL=((LDATE-IDATE)/IDT)+1
c      IF (NUMVAL.NE.NVALS) IFLAG=1
c      IF (NUMVAL.GE.NVALS) GOTO 220
  210 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - ONLY ',I3,
     1' VALUES ARE USED BASE ON THE DATES ON THE MOD CARD AND THE ',
     2/25X,'LISTCMPDY VALUE.',/11X,'THE CURRENT CARD IMAGE IS: ',
     3'  ',20A4)
c      NVALS=NUMVAL
C
C     IF START HOUR NOT ENTERED - USE DEFAULT VALUE OF 12Z
C     IF START HOUR ENTERED - SET TO CLOSEST DT OF TIME SERIES
C
C     IF HOUR ENTERED IIDATE LESS THAN ZERO
C
c220   CONTINUE
      IF (IDATE.GT.ISTHR) GOTO 234
C
      NDEL=((ISTHR-IDATE+(IDT/2))/IDT) + 1
      IDATE=ISTHR
      DO 221 III=1,MXVALS
         TEMP1(III)=0.0
  221 CONTINUE
      JJ=0
      DO 222 IIII=NDEL+1,NVALS
         TEMP1(JJ+1)=VALUES(IIII)
         JJ=JJ+1
  222 CONTINUE
C
      CALL UMEMOV(TEMP1,VALUES,MXVALS)
      NVALS=JJ
C
      if (nvals.gt.0) goto 231 
C
      IF (LDATE.LT.ISTHR) THEN
         IDATE=IABS(IIDATE)
         GOTO 25
         ENDIF
c
      IF (MODWRN.EQ.0) GOTO 680
c
      IXDA=(IABS(IIDATE)/24)+1
      IXHR=IABS(IIDATE)-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
c
      CALL MDYH2(IDA,IHZERO,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
C
      WRITE(IPR,223)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC
  223 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - THERE ARE NO ',
     1'VALUES AFTER RESETTING THE START DATE ON THE MOD CARD (',I2,
     2'/',I2,'/',I4,'-'I2,1X,A4,')',/,25X,'TO THE STARTRUN ',
     3'TECHNIQUE (',I2,'/',I2,'/',I4,'-',I2,1X,A4,')')
      GOTO 680
c
  231 if(modwrn.eq.0) goto 234
c
      IXDA=(IABS(IIDATE)/24)+1
      IXHR=IABS(IIDATE)-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
C
      CALL MDYH2(IDA,IHZERO,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
      WRITE(IPR,232)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC,NDEL
  232 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - START DATE (',I2,
     1  '/',I2,'/',I4,'-',I2,1X,A4,') IS BEFORE START RUN DATE (',I2,
     2  '/',I2,'/',I4,'-',I2,1X,A4,')'/,25X,'THE FIRST ',I4,' VALUE(S)',
     3  ' BEFORE AND AT START DATE ON THE MOD CARD ARE IGNORED.')
      CALL WARN
c    
c
  234 continue
c
      IF (LDATE.GE.ICOMP) GOTO 238 
c
      nslect=((ldate-idate+(idt/2))/idt)+1
      n1=nslect
      nvalso=nvals
      if(nslect.gt.nvals) nslect=nvals
      DO 235 LL=1,MXVALS
         TEMP1(LL)=0.0
  235 CONTINUE
      KK=0
      do 236 lll=1,nslect
c      DO 366 LLL=1,NOFF
         TEMP1(KK+1)=VALUES(LLL)
         KK=KK+1
  236 CONTINUE
C
      CALL UMEMOV(TEMP1,VALUES,MXVALS)
      NVALS=KK
C
      if(nvalso.le.n1) goto 238 
      IF (MODWRN.EQ.0) GOTO 238 
c
      ndiff=nvalso-n1
c
      IXDA=ICOMP/24+1
      IXHR=ICOMP-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
c
      IXDA=LDATE/24+1
      IXHR=LDATE-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
C
      WRITE(IPR,237)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC,ndiff
  237 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - LSTCMPDY (',I2,'/',
     1  I2,'/',I4,'-',I2,1X,A4,') IS BEYOND VALID DATE (',I2,'/',I2,
     2  '/',I4,'-',I2,1X,A4,')'/,25X,'THE ',I2,' VALUE(S) AFTER VALID ',
     3  'DATE ARE IGNORED.')
C
      CALL WARN
c
C     IF START HOUR NOT ENTERED - USE DEFAULT VALUE OF 12Z
C     IF START HOUR ENTERED - SET TO CLOSEST DT OF TIME SERIES
C
C     IF HOUR ENTERED IIDATE LESS THAN ZERO
c
  238 continue
c
      IF(IIDATE.LT.0)GO TO 239
C
C     HOUR NOT ENTERED - IDATE SHOULD BE DIVISIBLE BY 24
C
      JSTHR=IDATE
      GO TO 245
C
  239 CONTINUE
C
C     HOUR ENTERED - SET TO NEAREST DT
C
      JSTHR=MISTDT(IDATE,IDT)
C
  245 CONTINUE
C
C     NOW COMPUTE ENDING HOUR FOR TIME SERIES VALUES ENTERED
C
      ISPAN=IDT*(((NVALS-1)/NVPDT)*NVPDT)
      JENHR=JSTHR+ISPAN
C
C  GET LOCATIONS TO START CHANGES AND NUMBER OF VALUES TO MOVE
C
      CALL FDCODE(DTYPE,UNITS,DIMS,MISALW,NVPDT,TSCALE,NADINF,IERR)
      IF(IERR.EQ.0) GOTO 250
      IF(MODWRN.EQ.1) GOTO 50
      WRITE(IPR,500)DTYPE
      CALL WARN
      GOTO 50
C
  250 CALL MLOCCH(8HMATCHNG  ,ISTHR,IENHR,JSTHR,JENHR,
     1 TSID,DTYPE,IDT,NVALS,NVPDT,LOCD,IBUG,
     2 IOFFST,LDSTRT,NMOVE,ISTART,ISTATT)
C
      IF(ISTATT.EQ.1)GO TO 50
C
      IF (IFLAG.EQ.0) GOTO 260
      WRITE (IPR,210) NMOVE,(MODCRD(IX,NRDCRD),IX=1,20)
C
C     GET UNITS CONVERSION FACTORS IF NEEDED
C
  260 CONTINUE
      IF(IUMGEN.EQ.0)CALL FCONVT(UNITS,DIMS,EUNITS,XMULT,XADD,IER)
C
      IGOTO = (IUMGEN*4 + MISALW*2)/2 + 1
C
C     GO TO ONE OF FOUR CASES
C      IGOTO = 1,    UNITS CONVERSION, MISSING NOT ALLOWED
C              2,    UNITS CONVERSION, MISSING ALLOWED
C              3, NO UNITS CONVERSION, MISSING NOT ALLOWED
C              4, NO UNITS CONVERSION, MISSING ALLOWED
C
      IF(IBUG.GT.0)WRITE(IODBUG,270)NMOVE,TSID,DTYPE,IDT,LDSTRT,
     1 IOFFST,IGOTO
  270 FORMAT(11X,'ABOUT TO MOVE ',I4,' VALUES INTO TIME SERIES ',
     1 2A4,1X,A4,I3/11X,'LDSTRT,IOFFST,IGOTO ='/
     2 5X,I11,I7,I6)
C
      GO TO (350,380,290,330) , IGOTO
C
      IF(MODWRN.EQ.1)
     .WRITE(IPR,280)IUMGEN,MISALW
  280 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - ILLEGAL VALUE ',
     1 'FOR IUMGEN (',I5,') OR MISALW (',I5,').'/11X,
     2 'NO VALUES CHANGED.')
      GO TO 670
C
  290 DO 310 I=1,NMOVE
      IF(IFMSNG(VALUES(IOFFST+I)).EQ.0)GO TO 310
      IF(MODWRN.EQ.1)
     .WRITE(IPR,300)I,TSID,DTYPE,IDT,DTYPE
  300 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - VALUE NUMBER ',
     1 I3,' FOR TIME SERIES ',2A4,1X,A4,I3,' IS A MISSING VALUE.'/
     2 11X,'MISSING VALUES ARE NOT ALLOWED FOR DATA TYPE ',A4,1H./
     3 11X,'NO VALUES WILL BE CHANGED FOR THIS TIME SERIES.')
      GO TO 670
  310 CONTINUE
C
      DO 320 I=1,NMOVE
  320 D(LDSTRT+I)=VALUES(IOFFST+I)
      GO TO 50
C
  330 DO 340 I=1,NMOVE
  340 D(LDSTRT+I)=VALUES(IOFFST+I)
      GO TO 50
C
  350 DO 360 I=1,NMOVE
      IF(IFMSNG(VALUES(IOFFST+I)).EQ.0)GO TO 360
      IF(MODWRN.EQ.1)
     .WRITE(IPR,300)I,TSID,DTYPE,IDT,DTYPE
      GO TO 670
  360 CONTINUE
C
      DO 370 I=1,NMOVE
  370 D(LDSTRT+I)=(VALUES(IOFFST+I)-XADD)/XMULT
      GO TO 50
C
  380 DO 390 I=1,NMOVE
      TEMP=VALUES(IOFFST+I)
      IF(IFMSNG(TEMP).EQ.0)TEMP=(TEMP-XADD)/XMULT
  390 D(LDSTRT+I)=TEMP
      goto 50
C
C CHANGE ALL OCCURENCE OF MAT IN THIS SEGMENT
C
  400 continue
c
      loop=0
      NCHNGE=0
      LOCD=0
      LTEMP=1
  410 J=LTEMP
  420 IF(J.GT.LTS) GOTO 440
        IF(TS(J).NE.DMAT) GOTO 430
           LOCD=TS(J+3)
           LTEMP=TS(J-3)
           GOTO 460
  430      J=J+1
        GOTO 420
  440 IF((LTEMP.EQ.1).AND.(MODWRN.EQ.0)) GOTO 50
      IF(LTEMP.GT.1) GOTO 50
      IF(LTEMP.EQ.1) WRITE(IPR,450)
  450 FORMAT(1HO,10X,'**WARNING** THERE IS NO DATA TYPE OF MAT ',
     1               'IN THIS SEGMENT.')
      CALL WARN
      GOTO 50
C
  460 DNAME(1)=TS(J-2)
      DNAME(2)=TS(J-1)
      CALL UMEMOV(DNAME(1),TSID,2)
      DTYPE=TS(J)
      IDT=TS(J+1)
      NVPDT=TS(J+2)
C
c     IF (LDATE.EQ.ICOMP) GOTO 470
      IFLAG=0
c     NUMVAL=((LDATE-IDATE)/IDT)+1
c     IF (NUMVAL.NE.NVALS) IFLAG=1
c     IF (NUMVAL.GE.NVALS) GOTO 470
c     NVALS=NUMVAL
C
      IF (IDATE.GT.ISTHR) GOTO 424
      IF (NCHNGE.GT.0) GOTO 333 
C
      NDEL=((ISTHR-IDATE+(IDT/2))/IDT) + 1
      IDATE=ISTHR
      DO 401 III=1,MXVALS
         TEMP1(III)=0.0
  401 CONTINUE
      JJ=0
      DO 402 IIII=NDEL+1,NVALS
         TEMP1(JJ+1)=VALUES(IIII)
         JJ=JJ+1
  402 CONTINUE
C
      CALL UMEMOV(TEMP1,VALUES,MXVALS)
      NVALS=JJ
C
      if (nvals.gt.0) goto 421
C
      IF (LDATE.LT.ISTHR) THEN
         IDATE=IABS(IIDATE)
         GOTO 25
         ENDIF
c
      IF (MODWRN.EQ.0) GOTO 680
c
      IXDA=(IABS(IIDATE)/24)+1
      IXHR=IABS(IIDATE)-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
c
      CALL MDYH2(IDA,IHZERO,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
C
      WRITE(IPR,223)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC
      GOTO 680
c
  421 continue
c
  333 if(modwrn.eq.0) goto 424
c
      IXDA=(IABS(IIDATE)/24)+1
      IXHR=IABS(IIDATE)-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
      CALL MDYH2(IDA,IHZERO,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
C 
      WRITE(IPR,232)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC,NDEL
      CALL WARN
c
  424 continue
c
      IF (LDATE.GE.ICOMP) GOTO 428
      if (loop.eq.1) goto 429
c
      nslect=((ldate-idate+(idt/2))/idt)+1
      n1=nslect
      nvalso=nvals
      if(nslect.gt.nvals) nslect=nvals
      DO 425 LL=1,MXVALS
         TEMP1(LL)=0.0
  425 CONTINUE
      KK=0
      do 426 lll=1,nslect
c      DO 426 LLL=1,NOFF
         TEMP1(KK+1)=VALUES(LLL)
         KK=KK+1
  426 CONTINUE
C
      CALL UMEMOV(TEMP1,VALUES,MXVALS)
      NVALS=KK
C
      if(nvalso.le.n1) goto 428
      IF (MODWRN.EQ.0) GOTO 428
c
      ndiff=nvalso-n1
c
      IXDA=ICOMP/24+1
      IXHR=ICOMP-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
c
      IXDA=LDATE/24+1
      IXHR=LDATE-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
C
  429 WRITE(IPR,237)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC,ndiff
      loop=1
      CALL WARN
c
  428 continue
c
C     IF START HOUR NOT ENTERED - USE DEFAULT VALUE OF 12Z
C     IF START HOUR ENTERED - SET TO CLOSEST DT OF TIME SERIES
C
C     IF HOUR ENTERED IIDATE LESS THAN ZERO
C
  470 CONTINUE
      IF(IIDATE.LT.0)GO TO 480
C
C     HOUR NOT ENTERED - IDATE SHOULD BE DIVISIBLE BY 24
C
      JSTHR=IDATE
      GO TO 490
C
  480 CONTINUE
C
C     HOUR ENTERED - SET TO NEAREST DT
C
      JSTHR=MISTDT(IDATE,IDT)
C
  490 CONTINUE
C
C     NOW COMPUTE ENDING HOUR FOR TIME SERIES VALUES ENTERED
C
      ISPAN=IDT*(((NVALS-1)/NVPDT)*NVPDT)
      JENHR=JSTHR+ISPAN
C
C  GET LOCATIONS TO START CHANGES AND NUMBER OF VALUES TO MOVE
C
      CALL FDCODE(DTYPE,UNITS,DIMS,MISALW,NVPDT,TSCALE,NADINF,IERR)
      IF(IERR.EQ.0) GOTO 510
      IF(MODWRN.EQ.1) GOTO 50
      WRITE(IPR,500) DTYPE
  500 FORMAT(1H0,10X,'**WARNING** IN MATCHNG MOD - ',A4,' IS ',
     1'NOT VALID DATA TYPE FOR THE FORECAST COMPONENT.')
      CALL WARN
      GOTO 50
C
  510 CALL MLOCCH(8HMATCHNG ,ISTHR,IENHR,JSTHR,JENHR,
     1 TSID,DTYPE,IDT,NVALS,NVPDT,LOCD,IBUG,
     2 IOFFST,LDSTRT,NMOVE,ISTART,ISTATT)
C
      IF(ISTATT.EQ.1)GO TO 50
C
      IF (IFLAG.EQ.0) GOTO 520
      IF (MODWRN.EQ.0) GOTO 520
      WRITE (IPR,210) NMOVE,(MODCRD(IY,NRDCRD),IY=1,20)
      CALL WARN
C
C     GET UNITS CONVERSION FACTORS IF NEEDED
C
  520 CONTINUE
      IF(IUMGEN.EQ.0)CALL FCONVT(UNITS,DIMS,EUNITS,XMULT,XADD,IER)
C
      IGOTO = (IUMGEN*4 + MISALW*2)/2 + 1
C
C     GO TO ONE OF FOUR CASES
C      IGOTO = 1,    UNITS CONVERSION, MISSING NOT ALLOWED
C              2,    UNITS CONVERSION, MISSING ALLOWED
C              3, NO UNITS CONVERSION, MISSING NOT ALLOWED
C              4, NO UNITS CONVERSION, MISSING ALLOWED
C
      IF(IBUG.GT.0)WRITE(IODBUG,530)NMOVE,TSID,DTYPE,IDT,LDSTRT,
     1 IOFFST,IGOTO
  530 FORMAT(11X,'ABOUT TO MOVE ',I4,' VALUES INTO TIME SERIES ',
     1 2A4,1X,A4,I3/11X,'LDSTRT,IOFFST,IGOTO ='/
     2 5X,I11,I7,I6)
C
      GO TO (610,640,550,590) , IGOTO
C
      IF(MODWRN.EQ.1)
     .WRITE(IPR,540)IUMGEN,MISALW
  540 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - ILLEGAL VALUE ',
     1 'FOR IUMGEN (',I5,') OR MISALW (',I5,').'/11X,
     2 'NO VALUES CHANGED.')
      GO TO 670
C
  550 DO 570 I=1,NMOVE
      IF(IFMSNG(VALUES(IOFFST+I)).EQ.0)GO TO 570
      IF(MODWRN.EQ.1)
     .WRITE(IPR,560)I,TSID,DTYPE,IDT,DTYPE
  560 FORMAT(1H0,10X,'** WARNING ** IN MATCHNG MOD - VALUE NUMBER ',
     1 I3,' FOR TIME SERIES ',2A4,1X,A4,I3,' IS A MISSING VALUE.'/
     2 11X,'MISSING VALUES ARE NOT ALLOWED FOR DATA TYPE ',A4,1H./
     3 11X,'NO VALUES WILL BE CHANGED FOR THIS TIME SERIES.')
      GO TO 670
  570 CONTINUE
C
      DO 580 I=1,NMOVE
  580 D(LDSTRT+I)=VALUES(IOFFST+I)
      GO TO 660
C
  590 DO 600 I=1,NMOVE
  600 D(LDSTRT+I)=VALUES(IOFFST+I)
      GO TO 660
C
  610 DO 620 I=1,NMOVE
      IF(IFMSNG(VALUES(IOFFST+I)).EQ.0)GO TO 620
      IF(MODWRN.EQ.1)
     .WRITE(IPR,300)I,TSID,DTYPE,IDT,DTYPE
      GO TO 670
  620 CONTINUE
C
      DO 630 I=1,NMOVE
  630 D(LDSTRT+I)=(VALUES(IOFFST+I)-XADD)/XMULT
      GO TO 660
C
  640 DO 650 I=1,NMOVE
      TEMP=VALUES(IOFFST+I)
      IF(IFMSNG(TEMP).EQ.0)TEMP=(TEMP-XADD)/XMULT
  650 D(LDSTRT+I)=TEMP
      GO TO 660
C
  660 CONTINUE
      NCHNGE=NCHNGE+1
      GOTO 410
C
  670 CONTINUE
      IF(MODWRN.EQ.1)CALL WARN
      GO TO 50
C
  680 CALL FSTWHR(OLDOPN,IOLDOP,OLDOPN,IOLDOP)
C
      IF(IBUG.GT.0)WRITE(IODBUG,690)
  690 FORMAT(11X,'*** LEAVING SUBROUTINE MATCHN ***')
C
      RETURN
      END
