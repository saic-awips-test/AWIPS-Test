C MODULE RPRDDT
C-----------------------------------------------------------------------
C
C  ROUTINE TO READ A TIME SERIES FROM THE PROCESSED DATA BASE.
C
      SUBROUTINE RPRDDT (ITSID,ITYPE,JHOUR,ITSTEP,NUM,IUNITS,RMISS,
     *   LTSDAT,TSDAT,JFPTR,LIWORK,IWORK,IFUT,ISTA)
C
C  ARGUMENT LIST:
C
C       NAME     TYPE   I/O   DIM   DESCRIPTION
C       ------   ----   ---   ---   -----------
C       ITSID      A     I     2    TIME SERIES ID
C       ITYPE      A     I     1    DATA TYPE
C       JHOUR      I     I     1    JULIAN HOUR OF FIRST TIME PERIOD
C       ITSTEP     I     I     1    TIME STEP DESIRED
C       NUM        I     I     1    NUMBER OF TIME STEPS DESIRED
C       IUNITS     A     I     1    DESIRED UNITS
C       RMISS      R     I     1    MISSING VALUE FILLER
C       LTSDAT     I     I     1    SIZE OF ARRAY TSDAT
C       TSDAT      R     O   LTSDAT DATA ARRAY
C       JFPTR      I    I/O    1    JULIAN HOUR OF FIRST FUTURE DATA
C                                   IF NOT 0, IS HOUR CALLER WANTS
C                                   IF 0, GIVE FIRST FUTURE AFTER REG
C       LIWORK     I     I     1    SIZE OF ARRAY IWORK
C       IWORK      I    I/O  LIWORK WORK ARRAY
C       ISTA       I     O     1    STATUS INDICATOR:
C                                     0=NORMAL RETURN
C                                     1=TIME SERIES NOT FOUND
C                                     2=NOT ENOUGH DATA - RMISS USED
C                                     3=INVALID TIME STEP
C                                     4=INVALID UNITS CONVERSION
C                                     5=FILE READ/WRITE ERROR
C                                     6=ARRAY IWORK TOO SMALL
C                                     7=INVALID JHOUR
C                                     8=ARRAY TSDAT TOO SMALL
C
      INCLUDE 'uio'
      INCLUDE 'udebug'
      INCLUDE 'hclcommon/hdflts'
      INCLUDE 'prdcommon/pdftbl'
      INCLUDE 'prdcommon/ptsctl'
      INCLUDE 'prdcommon/pdatas'
      INCLUDE 'prdcommon/ptsicb'
      INCLUDE 'prdcommon/punits'
      INCLUDE 'prdcommon/preads'
C
      DIMENSION TSDAT(LTSDAT),IWORK(LIWORK)
      DIMENSION ITSID(2),IXBUF(4),INUM(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/db_prdrw/RCS/rprddt.f,v $
     . $',                                                             '
     .$Id: rprddt.f,v 1.3 2003/03/14 16:50:14 dws Exp $
     . $' /
C    ===================================================================
C
      DATA LSAME/4HSAME/
C
C
      IF (IPRTR.GT.0) WRITE (IOGDB,410)
C
      ISTA=0
C
      JFPTR=0
      IXTYPE=ITYPE
C
C  CHECK IF PROCESSING FUTURE TIME SERIES
      IF (IFUT.EQ.0) GO TO 10
C
C  GET REGULAR TYPE
      CALL PFDTYP (ITYPE,INDX)
      IF (INDX.EQ.0) GO TO 390
      INDX=DATFIL(7,INDX)
      IF (INDX.LE.0) GO TO 390
      IXTYPE=DATFIL(1,INDX)
C
C  CHECK IF RECORD IS IN IN-CORE BUFFER
10    CALL PGTSIC (ITSID,IXTYPE,INDXD)
      IF (INDXD.EQ.0) GO TO 40
      NWDS=TSICBU(INDXD)+TSICBU(INDXD+3)
      IF (NWDS.GT.LIWORK) GO TO 20
         CALL UMEMOV (TSICBU(INDXD),IWORK,NWDS)
         GO TO 80
C
C  WORK ARRAY TOO SMALL
20    IF (IPRDB.GT.0) WRITE (IOGDB,420) LIWORK,NWDS
30    ISTA=6
      GO TO 400
C
C  CHECK FOR VALID DATA TYPE
40    CALL PFDTYP (IXTYPE,INDXT)
      IF (INDXT.EQ.0) GO TO 380
C
C  GET LOGICAL UNIT NUMBER
      LU=DATFIL(2,INDXT)
      CALL PGETLU (LU,INDEX)
      IF (INDEX.EQ.0) GO TO 380
C
C  CHECK IF NEXT RECORD IS THE ONE
      IF (DATFIL(11,INDXT).EQ.1) GO TO 50
      ISTRT=TSCNTR(5,INDEX)+1
      IF (ISTRT.EQ.2.OR.ISTRT.GE.TSCNTR(3,INDEX)) GO TO 50
      CALL RTSRCD (ISTRT,ITSID,IXTYPE,LU,LIWORK,IWORK,ISTA)
      IF (ISTA.EQ.2) GO TO 50
      IF (ISTA.EQ.1) GO TO 30
      IF (ISTA.NE.0) GO TO 400
C
C  TRY TO PUT TIME SERIES IN IN-CORE BUFFER
      NREC=(IWORK(1)-4+IWORK(4)+(LRECLT-1))/LRECLT
      NWDS=IWORK(1)+IWORK(4)
      CALL PPTSIC (IWORK,NWDS,0,ISTAT)
      IF (ISTAT.NE.0) WRITE (LP,430) IWORK(8),IWORK(9),IWORK(10)
      TSCNTR(5,INDEX)=ISTRT+NREC-1
      IF (IXTYPE.NE.IWORK(10)) GO TO 50
      CALL UNAMCP (ITSID,IWORK(8),ISTAT)
      IF (ISTAT.EQ.0) GO TO 80
C
C  GET RECORD NUMBER FROM INDEX
50    CALL PSERCH (ITSID,IXTYPE,IFREE,IXREC,IXBUF)
      IF (IPRDB.GT.0) WRITE (IOGDB,440) ITSID,IXTYPE,IFREE,IXREC
      IF (IXREC.EQ.0) GO TO 70
C
C  TIME SERIES FOUND
      ISTRT=IXBUF(4)
      IF (IPRDB.GT.0) WRITE (IOGDB,450)ISTRT,ITSID,IXTYPE,LU,LIWORK
      CALL RTSRCD (ISTRT,ITSID,IXTYPE,LU,LIWORK,IWORK,ISTA)
      IF (ISTA.NE.2) GO TO 60
         WRITE (LP,460) ITSID,IXTYPE,ISTRT
         ISTA=1
         GO TO 400
60    IF (ISTA.EQ.1) GO TO 30
      IF (ISTA.NE.0) GO TO 400
C
C  TRY TO PUT TIME SERIES IN IN-CORE BUFFER
      NREC=(IWORK(1)-4+IWORK(4)+(LRECLT-1))/LRECLT
      NUMACC(INDXT)=NUMACC(INDXT)+1
      TSCNTR(5,INDEX)=ISTRT+NREC-1
      NWDS=IWORK(1)+IWORK(4)
      CALL PPTSIC (IWORK,NWDS,0,ISTAT)
      IF (ISTAT.NE.0) WRITE (LP,430) IWORK(8),IWORK(9),IWORK(10)
      GO TO 80
C
70    IF (IPRDB.GT.0) WRITE (IOGDB,470) ITSID,IXTYPE
      ISTA=1
      GO TO 400
C
C  CHECK FOR VALID DATA TIME INTERVAL
80    IF (ITSTEP.LT.IWORK(2)) GO TO 90
         IMULF=ITSTEP/IWORK(2)
         IREM=MOD(ITSTEP,IWORK(2))
         IF (IREM.EQ.0) GO TO 100
90    ISTA=3
      IF (IPRDB.GT.0) WRITE (IOGDB,480) ITSID,IXTYPE,ITSTEP,IWORK(2)
      GO TO 400
C
C  GET VALUE TO CHANGE DATA TIME INTERVAL
100   CALL PFDTYP (IXTYPE,INDXT)
      IDTKEY=DATFIL(6,INDXT)
      IF (IMULF.EQ.1) GO TO 110
      CALL PPIKOF (IDTKEY,IMULF,JHOUR,IWORK)
C
C  CHECK STARTING HOUR
110   IF (JHOUR.GE.0) GO TO 120
         ISTA=7
         GO TO 400
120   IF (IWORK(14).EQ.0) GO TO 130
      IREM=JHOUR-IWORK(14)
      IREM=MOD(IREM,ITSTEP)
      IF (IREM.EQ.0) GO TO 130
      ISTA=3
      IF (IPRDB.GT.0) WRITE (IOGDB,490) ITSID,IXTYPE
      GO TO 400
C
C  GET UNITS CONVERSION FACTORS
130   ISUNIT=IWORK(11)
      IF (IUNITS.EQ.IWORK(11)) GO TO 140
      IF (IUNITS.EQ.LSAME) GO TO 140
C
C  CONVERT DATA
      NVAL=IWORK(5)*IWORK(3)
      IF (NVAL.GT.0) THEN
         CALL UDUCNN (1,ZAPR,IERR)
         IF (IERR.GT.0) THEN
            ISTA=4
            GO TO 400
            ENDIF
         IDUCNV=1
         IPTRV1=IWORK(6)
         CALL UDUCNV (IWORK(11),IUNITS,IDUCNV,NVAL,IWORK(IPTRV1),
     *      IWORK(IPTRV1),IERR)
         IF (IERR.GT.0) THEN
            ISTA=4
            GO TO 400
            ENDIF
         ENDIF
C
C  CHECK IF THIS IS FUTURE RECORD
140   IF (DATFIL(7,INDXT).GE.0) GO TO 150
         K=0
         NVALS=NUM*IWORK(3)
         GO TO 280
150   IF (IPRDB.GT.0) WRITE (IOGDB,500) JHOUR,JFPTR,IWORK(14),
     *   ITSTEP
C
C  FIND STARTING POINT OF DATA IN BUFFER.
C  ISTPT IS STARTING POINT (LATER GETS CHANGED TO OFSET OF DATA BY
C        ADDING LENGTH OF HEADER)
C  NVAL IS NUMBER OF DATA ITEMS IN BUFFER
C  NVALS IS NUMBER OF DATA ITEMS WANTED
C  IFPTR IS COMPUTED POINTER TO FUTURE DATA IN MIXED RECORD
C        (IF REGULAR DATA ONLY, SET TO 0)
      ISTPT=(JHOUR-IWORK(14))/ITSTEP*IWORK(3)
      NVAL=IWORK(3)*IWORK(5)
      NVALS=NUM*IWORK(3)
      IFPTR=(IWORK(7)-IWORK(6))/IWORK(3)*ITSTEP+IWORK(14)
      IF (IWORK(7).EQ.0) IFPTR=0
      K=0
      IFFLG=0
C
C  CHECK WHERE ISTPT FALLS WITHIN DATA
      IF (ISTPT.LT.0) GO TO 180
      IF (ISTPT.GE.NVAL) GO TO 200
      J=1
C
C  ISTPT IS WITHIN DATA IN RECORD
160   K=NVAL-ISTPT
      IF (NVALS.LE.K) GO TO 170
C
C  NEED DATA IN BUFFER AND WILL NEED FUTURE ALSO TO SATISFY NVALS
      ISTPT=ISTPT+IWORK(1)+1
      IF (LTSDAT.GT.0.AND.J.GT.LTSDAT) GO TO 385 
      CALL UMEMOV (IWORK(ISTPT),TSDAT(J),K)
      NVALS=NVALS-K
      K=K+J-1
      GO TO 200
C
C  NVALS IS SATISFIED WITH REGULAR DATA BUT SEE IF WANT SPECIAL FUT
170   ISTPT=ISTPT+IWORK(1)+1
      IF (LTSDAT.GT.0.AND.J.GT.LTSDAT) GO TO 385
      CALL UMEMOV (IWORK(ISTPT),TSDAT(J),NVALS)
C
C  IF NOT MIXED TIME SERIES AND JFPTR GT 0, NEED TO GET FUTURE
      IF (DATFIL(7,INDXT).GT.0.AND.JFPTR.NE.0) GO TO 200
C
C  DID NOT ASK FOR SPECIAL FUTURE - IF NOT MIXED ARE DONE
      IF (IFPTR.EQ.0) GO TO 360
C
C  COMPUTE HOUR WHERE FUTURE STARTS
      IENHR=ITSTEP*NUM+JHOUR
      IF (JHOUR.GT.IFPTR) IFPTR=JHOUR
      IF (IENHR.LE.IFPTR) IFPTR=0
      GO TO 360
C
C  WANT DATA BEFORE EARLIEST IN RECORD - SET SOME TO MISSING
180   K=K+1
      NMISS=-ISTPT
      IF (NMISS.GT.NVALS) NMISS=NVALS
      IF (LTSDAT.GT.0.AND.K.GT.LTSDAT) GO TO 385
      CALL UMEMST (ZAPR,TSDAT(K),NMISS)
      ISTPT=0
      J=NMISS+K
      NVALS=NVALS-NMISS
      ISTA=2
      IF (IFFLG.EQ.0.AND.NVALS.EQ.0) IFPTR=0
      IF (NVALS.EQ.0) GO TO 190
         IF (IFFLG.EQ.1) GO TO 330
         GO TO 160
190   ISTA=2
      GO TO 360
C
C  CHECK FOR SEPARATE FUTURE FILE
200   ILUF=DATFIL(7,INDXT)
      IF (ILUF.EQ.0) GO TO 340
      LUF=DATFIL(2,ILUF)
      ISTRTF=IWORK(15)
      IF (ISTRTF.EQ.0) GO TO 380
      IFTYP=DATFIL(1,ILUF)
      INUM(1)=ISTRTF
      INUM(2)=0
C
C  CHECK IF IN IN-CORE BUFFER
      CALL PGTSIC (INUM,IFTYP,INDXD)
      IF (INDXD.EQ.0) GO TO 210
C
C  FOUND IN IN-CORE BUFFER
      NWDS=TSICBU(INDXD)+TSICBU(INDXD+3)
      IF (NWDS.GT.LIWORK) GO TO 20
      CALL UMEMOV (TSICBU(INDXD),IWORK,NWDS)
      GO TO 230
C
C  NOT FOUND IN IN-CORE BUFFER - GET TIME SERIES
210   CALL RTSRCD (ISTRTF,8H        ,IFTYP,LUF,LIWORK,IWORK,ISTAT)
      IF (ISTAT.NE.2) GO TO 220
         ISTA=1
         GO TO 400
220   IF (ISTAT.EQ.1) GO TO 30
      IF (ISTAT.NE.0) GO TO 380
      NWDS=IWORK(1)+IWORK(4)
C
C  PUT IN IN-CORE BUFFER
      CALL PPTSIC (IWORK,NWDS,ISTRTF,ISTAT)
      IF (ISTAT.NE.0) WRITE (LP,430) IWORK(8),IWORK(9),IWORK(10)
      CALL PGETLU (LUF,INDEXF)
      IF (INDEXF.EQ.0) GO TO 380
C
C  COMPUTE POINTER TO LAST RECORD READ WHEN PUT IN CORE
      NREC=(IWORK(1)-4+IWORK(4)+(LRECLT-1))/LRECLT
      TSCNTR(5,INDEXF)=ISTRTF+NREC-1
C
C  CHECK DATA TIME INTERVAL
230   IF (ITSTEP.LT.IWORK(2)) GO TO 240
         IMULF=ITSTEP/IWORK(2)
         IREM=MOD(ITSTEP,IWORK(2))
         IF (IREM.EQ.0) GO TO 250
240   ISTA=3
      WRITE (LP,480) ITSID,IXTYPE,ITSTEP,IWORK(2)
      GO TO 400
C
C  GET VALUE TO CHANGE DATA TIME INTERVAL
250   IDTKEY=DATFIL(6,ILUF)
      IF (IMULF.EQ.1) GO TO 260
      CALL PPIKOF (IDTKEY,IMULF,JHOUR,IWORK)
C
C  CHECK IF DATA TO BE CONVERTED
260   IF (IUNITS.EQ.IWORK(11)) GO TO 270
      IF (IUNITS.EQ.LSAME.AND.ISUNIT.EQ.IWORK(11)) GO TO 270
C
C  GET CONVERSION FACTORS
      ICUNIT=IUNITS
      IF (ICUNIT.EQ.LSAME) ICUNIT=ISUNIT
C
C  CONVERT DATA
      NVAL=IWORK(3)*IWORK(5)
      IF (NVAL.GT.0) THEN
         CALL UDUCNN (1,ZAPR,IERR)
         IF (IERR.GT.0) THEN
            ISTA=4
            GO TO 400
            ENDIF
         IDUCNV=1
         IPTRV1=IWORK(6)
         CALL UDUCNV (IWORK(11),ICUNIT,IDUCNV,NVAL,IWORK(IPTRV1),
     *      IWORK(IPTRV1),IERR)
         IF (IERR.GT.0) THEN
            ISTA=4
            GO TO 400
            ENDIF
         ENDIF
C
C  CHECK STARTING HOUR
270   IF (IWORK(14).EQ.0) GO TO 280
      IREM=IWORK(14)-JHOUR
      IREM=MOD(IREM,ITSTEP)
      IF (IREM.EQ.0) GO TO 280
         WRITE (LP,490) ITSID,IXTYPE
         GO TO 400
C
C  MOVE FUTURE DATA INTO BUF.
C  NVAL IS NUMBER OF VALUES IN RECORD
C  K IS NUMBER OF VALUES IN BUFFER SO FAR
C  IF JFPTR IS GT 0, NEED TO COMPUTE K RATHER THAN USING IT
C  IFPTR IS HOUR AFTER REGULAR THAT WE NEED - IF IWORK(5)=0, NO FUTURE
C      DATA SO SET TO MISSING
280   NVAL=IWORK(5)*IWORK(3)
      IF (JFPTR.GT.0) GO TO 350
C
290   IFPTR=K/IWORK(3)*ITSTEP+JHOUR
      IF (IWORK(5).EQ.0) GO TO 340
C
      ISTPT=(IFPTR-IWORK(14))/ITSTEP*IWORK(3)
      IF (IPRDB.GT.0) WRITE (IOGDB,510) IFPTR,JFPTR,K,NVAL,NVALS,ISTPT
      IF (ISTPT.GE.NVAL) GO TO 340
      IF (ISTPT.LT.0) GO TO 320
C
310   J=NVALS
      IF (NVALS+ISTPT.GE.NVAL) J=NVAL-ISTPT
      K=K+1
      ISTPT=ISTPT+IWORK(1)+1
      IF (LTSDAT.GT.0.AND.K.GT.LTSDAT) GO TO 385
      CALL UMEMOV (IWORK(ISTPT),TSDAT(K),J)
      IF (J.EQ.NVALS) GO TO 360
C
      K=K+J
      N=NVALS-J
      IF (LTSDAT.GT.0.AND.K.GT.LTSDAT) GO TO 385
      CALL UMEMST (ZAPR,TSDAT(K),N)
      ISTA=2
      GO TO 360
C
320   IFFLG=1
      GO TO 180
C
330   ISTPT=0
      K=J-1
      GO TO 310
C
C  ALL FUTURE DATA IS MISSING
340   K=K+1
      IF (LTSDAT.GT.0.AND.K.GT.LTSDAT) GO TO 385
      CALL UMEMST (ZAPR,TSDAT(K),NVALS)
      ISTA=2
      IF (IFPTR.EQ.0) IFPTR=JHOUR+(K-1)/IWORK(3)*ITSTEP
      IF (JHOUR.GT.IFPTR) IFPTR=JHOUR
      GO TO 360
C
C  USER HAS CHOSEN SPECIFIC FUTURE DATA (JFPTR)
C  CHECK FOR LESS THAN BEGINNING OF FUTURE OR GREATER THAN END -
C     IF IT IS, RESET TO END OF REGULAR DATA
350   IREM=JFPTR-IWORK(14)
      IF (IWORK(14).EQ.0) IREM=JFPTR-NHOPDB
      IREM=MOD(IREM,ITSTEP)
      IF (IREM.NE.0) JFPTR=JFPTR-IREM
      IF (JFPTR.LT.IWORK(14)) GO TO 290
C
C  IF FUTURE POINTER LEAVES A GAP AFTER REGULAR, RESET TO END OF REG
C  IENHR IS LAST HOUR OF REGULAR DATA IN BUFFER
C  JFPTR IS FIRST HOUR OF FUTURE DATA WANTED
C  IWORK(3) IS NUMBER OF VALS PER DT
C  IWORK(14) IS START HOUR OF REGULAR DATA ON FILE
C  ITSTEP IS DT OF TIME SERIES
C  K IS NUMBER OF VALUES MOVED INTO BUFFER - CURRENTLY IS
C      NUMBER OF REGULAR DATA VALUES MOVED IN
      IENHR=(K*ITSTEP)/IWORK(3)+JHOUR
      IF (IPRDB.GT.0) WRITE (IOGDB,520) K,ITSTEP,IWORK(3),IENHR
      IF (JFPTR.GE.IENHR+ITSTEP) GO TO 290
C
C  RECOMPUTE K TO BE POSITION FOR JFPTR
C  RECOMPUTE NVALS TO ADD NUMBER OF VALUES THAT K IS 'BACKED UP'
      KOLD=K
      K=(JFPTR-JHOUR)/ITSTEP*IWORK(3)
      NVALS=NVALS+KOLD-K
      GO TO 290
C
C  RESET JFPTR IN CASE CHANGED
360   JFPTR=IFPTR
C
C  CONVERT MISSING DATA VALUES TO MISSING VALUE FILLER
      NVALS=NUM*IWORK(3)
      DO 370 I=1,NVALS
C         IF (TSDAT(I).LE.ZAPR) TSDAT(I)=RMISS
C LC changed if statement to allow values less than -999 but not equal to -999
         IF ((TSDAT(I).LT.-998.99).AND.(TSDAT(I).GT.-999.01))THEN 
            TSDAT(I)=RMISS
         ENDIF
370      CONTINUE
      GO TO 400
C
C  SYSTEM ERROR
380   IF (IPRDB.GT.0) WRITE (IOGDB,530) ITSID,IXTYPE
      ISTA=5
      GO TO 400
C
C  TSDAT ARRAY TOO SMALL
385   IF (IPRDB.GT.0) WRITE (IOGDB,535) ITSID,IXTYPE
      ISTA=8
      GO TO 400
C
C  INVALID TYPE
390   IF (IPRDB.GT.0) WRITE (IOGDB,540) ITYPE
      ISTA=1
C
400   IF (IPRTR.GT.0) WRITE (IOGDB,550) ISTA
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
410   FORMAT (' *** ENTER RPRDDT')
420   FORMAT ('0**ERROR** IN RPRDDT - WORK ARRAY TOO SMALL. ',
     *   'DIMENSION IF WORK ARRAY IS ',I5,'. ',I5,
     *   ' WORDS NEEDED.')
430   FORMAT ('0**WARNING** TIME SERIES ',2A4,1X,A4,' NOT PUT IN CORE')
440   FORMAT (' PSERCH CALLED - ITSID=',2A4,
     *   3X,'IXTYPE=',A4,3X,'IFREE=',I7,3X,'IXREC=',I7)
450   FORMAT (' BEFORE CALLING RTSRCD - ISTRT=',I7,3X,
     *   'ITSID=',2A4,3X,'IXTYPE=',A4,3X,'LU=',I4,3X,'LIWORK=',I7)
460   FORMAT ('0**ERROR** IN RPRDDT - TIME SERIES ',2A4,1X,A4,
     *   ' NOT FOUND AT RECORD ',I8,' EVEN THOUGH INDEX POINTS HERE.')
470   FORMAT ('0**ERROR** IN RPRDDT - TIME SERIES ',2A4,1X,A4,
     *   ' NOT FOUND.')
480   FORMAT ('0**ERROR** IN RPRDDT - INVALID TIME INTERVAL FOR',
     *   ' TIME SERIES ',3A4,'. ',I2,' WAS PASSED. ',I2,' IS CORRECT.')
490   FORMAT ('0**ERROR** IN RPRDDT - STARTING HOUR NOT A ',
     *   'VALID TIME STEP FOR TIME SERIES ',2A4,1X,A4,'.')
500   FORMAT (' RPRDDT, JHOUR=',I8,' JFPTR=',I8,' IWORK(14)=',I8,
     *   ' ITSTEP=',I8)
510   FORMAT (' IFPTR=',I8,3X,'JFPTR=',I8,3X,'K=',I8,3X,'NVAL=',I3,3X,
     *   'NVALS=',I3,3X,'ISTPT=',I8)
520   FORMAT (' K=',I8,3X,'ITSTEP=',I8,3X,'IWK3=',I8,3X,
     *   'IENHR=',I8)
530   FORMAT ('0**ERROR** IN RPRDDT - SYSTEM ERROR FOR TIME ',
     *   'SERIES ',2A4,1X,A4,'.')
535   FORMAT ('0**ERROR** IN RPRDDT - TSDAT ARRAY TOO SMALL FOR ',
     *   'TIME SERIES ',2A4,1X,A4,'.')
540   FORMAT ('0**ERROR** IN RPRDF - ',A4,' IS AN INVALID TYPE OR ',
     *   'HAS NO FUTURE TYPE.')
550   FORMAT (' *** EXIT RPRDDT - ISTA=',I2)
C
      END
