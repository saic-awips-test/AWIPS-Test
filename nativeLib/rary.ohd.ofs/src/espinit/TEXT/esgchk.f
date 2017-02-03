C MEMBER ESGCHK
C  (from old member EESGCHK)
C-----------------------------------------------------------------------
C
C                             LAST UPDATE: 06/08/94.08:40:14 BY $WC20SV
C
C @PROCESS LVL(77)
C
      SUBROUTINE ESGCHK (IFREC,P,MP,T,MT,TS,MTS,PESP,MPESP,SPESP,
     *MSPESP,TSESP,MTSESP,TINDX,MTTS,IPTR,NUMOUT,IERSUM)
C
C ......................................................................
C
C          SEGMENT CHECK ROUTINE
C
C THIS ROUTINE CHECKS TO SEE IF ALL THE TIME SERIES DEFINED FOR THE
C FORECAST PROGRAM HAVE BEEN DEFINED FOR ESP.
C IT ALSO KEEPS TRACK OF TIME SERIES BEING WRITTEN TO ESP FILE AND
C CHECKS THAT ALL TIME SERIES SPECIFIED AS INPUT ON ESP FILE WERE
C PREVIOUSLY DEFINED. AS OUTPUT.
C
C ORIGINALLY BY:   ED VANBLARGAN - HRL - JULY, 1981
C
C ......................................................................
C
C     VARIABLES:
C IFREC -RECORD NUMBER ON FORECAST FILES
C ITSTYP-TIME SERIES TYPE IN TSESP ARRAY
C IPTR  -POINTER FOR LOCATION IN TINDX ARRAY
C IERSUM-SUM OF ANY ERROR CODES RETURNED FROM ROUTINES
C IUPDT -INDICATOR IF WE HAVE UPDATE TS
C NUMOUT-NUMBER OF OUTPUT TS IN TINDX ARRAY
C TINDX -INDEX ARRAY CONTAINING CHARACTERISTICS OF EACH OUTPUT TS
C
C
      INTEGER T(1)
      DIMENSION P(1),TS(1),PESP(1),SPESP(1),TSESP(1),TINDX(1),
     * SBNAME(2),OLDOPN(2)
C
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/espseg'
      INCLUDE 'common/fcsegn'
      INCLUDE 'common/where'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/espinit/RCS/esgchk.f,v $
     . $',                                                             '
     .$Id: esgchk.f,v 1.1 1995/09/17 18:46:40 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA NAME,ESP,SBNAME/4HEINI,4HESP ,4HESGC,4HHK  /
C
C SET UP ERROR TRACE FOR THIS ROUTINE IN COMMON BLK/WHERE/
C
      IOLDOP=IOPNUM
      IOPNUM=0
      DO 10 I=1,2
        OLDOPN(I)=OPNAME(I)
        OPNAME(I)=SBNAME(I)
10    CONTINUE
C
C GET TRACE LEVEL AND DEBUG
C
      IF (ITRACE.GE.1) WRITE(IODBUG,100)
100   FORMAT(1H0,14HESGCHK ENTERED)
      IBUG=IFBUG(NAME)
C
C INITIAL VALUES
C
      IER=0
C
C CALL FGETSG TO GET SEGMENT (AS DEFINED BY RECORD NUMBER)
C FROM FILE AND PUT NECESSARY INFO INTO COMMON BLOCK FCSEGN.
C
      CALL FGETSG(DUM,IFREC,MP,P,MT,T,MTS,TS,1,0,IER)
C
      IERSUM=IER
C
      IF (IER.EQ.0) GO TO 110
      WRITE(IPR,200) IER,IFREC
200   FORMAT(1H0,10X,'**ERROR** ROUTINE FGETSG RETURNED',
     *13H ERROR CODE =,I3,12H FOR IFREC =,I5)
      CALL ERROR
      GO TO 1000
C
C CHECK TO BE SURE ESP RECORD NUMBER(IEREC) ASSOCIATED WITH
C FORECAST COMPONENT RECORD NUMBER(IFREC) IS GREATER THAN 1.
C
110   IF (IEREC.GE.1) GO TO 300
      WRITE(IPR,220) IDSEGN,IFREC
220   FORMAT(1H0,10X,43H**ERROR** ESP RECORD NUMBER WAS LESS THAN 1,
     *13H FOR SEGMENT ,2A4,37H ON FORECAST COMPONENT RECORD NUMBER ,I3,
     */ 21X,50HTHE SEGMENT PROBABLY HAS NOT BEEN DEFINED FOR ESP.)
      IERSUM=IERSUM+1
      CALL ERROR
      GO TO 1000
C
C .................DEBUG TIME.....................................
C
300   IF (IBUG.NE.0) WRITE(IODBUG,310) IFREC,IEREC
310   FORMAT(1H0,13HESGCHK DEBUG: / 1X,6HIFREC=,I6,8H  IEREC=,I6)
C ................................................................
C
C CALL ESPRDF TO FILL COMMON BLK ESPSEG AND TO FILL TSESP ARRAY.
C ALSO PUT SEGMENT NAME(ID) INTO ISEG IN CB/WHERE/
C
      CALL ESPRDF(1,1,IEREC,TSESP,MTSESP,PESP,MPESP,SPESP,MSPESP,IER)
C
      ISEG(1)=ID(1)
      ISEG(2)=ID(2)
C
      WRITE(IPR,315) ID
315   FORMAT(1H0,5X,17HCHECK ON SEGMENT ,2A4)
C
      IERSUM=IERSUM+IER
      IF (IER.NE.0) WRITE(IPR,320) IER,IEREC
320   FORMAT(1H0,10X,'**ERROR** ROUTINE ESPRDF RETURNED',
     *18H WITH ERROR CODE =,I3,18H FOR RECORD NUMBER,I5)
C
C CHECK SEGMENT ID'S FOR ESP (ON CB/ESPSEGN/) AND FORECAST (CB/FCSEGN).
C
      IF(ID(1).EQ.IDSEGN(1).AND.ID(2).EQ.IDSEGN(2)) GO TO 350
      IERSUM=IERSUM+1
      WRITE(IPR,340) ID,IDSEGN
340   FORMAT(1H0,10X,26H**ERROR** ESP SEGMENT ID -,2A4,5H- AND,
     *21H FORECAST SEGMENT ID-,2A4,19H- ARE NOT THE SAME.)
      CALL ERROR
C
C COMPARE ESP CHECK AND FORECAST CREATION DATES TO BE SURE ESP DATE IS
C AFTER FORECAST DATE. IF NOT, CALL ECHKTS TO COMPARE TS ARRAYS
C TO BE SURE TIME SERIES ARE DEFINED.
C
350   IFCDAT=ICRDTE(3)*10000 + ICRDTE(1)*100 + ICRDTE(2)
      IESDAT=IECKDT(3)*10000 + IECKDT(1)*100 + IECKDT(2)
C
      IF (IESDAT.GT.IFCDAT) GO TO 500
      IF (IESDAT.LT.IFCDAT) GO TO 360
C
C IF DATES ARE EQUAL, CHECK HOURS AND MINUTES
C
      IFCMIN=ICRDTE(4)*10000
      IESMIN=IECKDT(4)*10000
      IF (IESMIN.GT.IFCMIN) GO TO 500
C
360   CALL ECHKTS(TS,MTS,TSESP,MTSESP,IER)
C
      IERSUM=IERSUM+IER
      IF (IER.NE.0) WRITE(IPR,400) ID
400   FORMAT(1H0,15X,37HTHE TIME SERIES DEFINED IN FCINIT AND,
     *23H ESPINIT DO NOT COMPARE / 22X,13H FOR SEGMENT ,2A4)
C
C .....................DEBUG TIME........................
C
500   IF (IBUG.EQ.0) GO TO 520
C
      WRITE(IODBUG,450) ID,IEREC,IDSEGN,IFREC,
     *  IFCDAT,IFCMIN,IESDAT,IESMIN,
     *  NUMOUT,IPTR
450   FORMAT(1H0,3HID=,2A4,8H  IEREC=,I5,9H  IDSEGN=,2A4,8H  IFREC=,I5,
     *  9H  IFCDAT=,I8,9H  IFCMIN=,I8,9H  IESDAT=,I8,9H  IESMIN=,I8,
     */ 10X,9H  NUMOUT=,I3,7H  IPTR=,I4)
C
      WRITE(IODBUG,930) (TSESP(I),I=1,LTSESP)
930   FORMAT(1X,12HTSESP ARRAY: / 7(1X,G15.7))
C
      WRITE(IODBUG,940) (TSESP(I),I=1,LTSESP)
940   FORMAT(1X,12HTSESP ARRAY: / 7(12X,A4))
C ........................................................
C
C
C LOOP THRU TSESP ARRAY AND KEEP TRACK OF ALL OUPUT TIME SERIES (TO ESP
C FILE) IN AN INDEX ARRAY. THEN IF  AN INPUT TS IS ENCOUNTERED CHECK
C THIS INDEX ARRAY TO MAKE SURE THE TS WAS PREVIOSLY SPECIFIED AS
C OUTPUT. IF NOT, WRITE A WARNING.
C
520   NEX=1
C
C GO TO NEXT TS LOCATION AND GETT TS TYPE(ITSTYP). CHECK
C FOR END OF ARRAY (ITSTYP=0).
C
550   ITSTYP=TSESP(NEX)
      IUPDT=0
      IF (ITSTYP.LE.0) GO TO 999
C
C FIRST, CHECK IF WE HAVE UPDATE TS(ITSTYP=2) SINCE UPDATE HAS AN
C INPUT AND OUTPUT TS AND EITHER,BOTH, OR NONE MAY BE ON ESP FILE.
C
C THEN, CHECK TO SEE IF THIS TS USES ESP FILE. IF NOT, GO TO NEXT TS.
C IF SO, GO TO SPECIFIED LOCATION IN PROG FOR THIS TS TYPE.
C FOR INTERNAL TS (ITSTYP=4) JUST GO TO NEXT TS.
C
      IF (ITSTYP.EQ.2) GO TO 700
      IF (ITSTYP.EQ.4) GO TO 900
      IF (TSESP(NEX+9).NE.ESP) GO TO 900
C
      GO TO(600,700,800,900),ITSTYP
C
      IERSUM=1
      WRITE(IPR,570) ITSTYP
570   FORMAT(1H0,10X,41H**ERROR** INVALID T.S. TYPE INDICATOR=,I4,
     * ' IMPOSSIBLE GOTO.')
      CALL ERROR
      GO TO 900
C
C === INPUT TIME SERIES ===
C
C FOR INPUT TS GO THRU INDX ARRAY AND SEE IF TTHE INPUT TS MATCHES
C UP WITH ANY PREVIOUSLY DEFINED OUTPUT TS IN ARRAY.  IF NO MATCH
C IS FOUND WRITE A WARNING.
C
C ALSO, IF INPUT TS HAS NO MATCH IN TINDX, SEE IF IT IS UPDATE TS
C (IUPDT=1) IF SO, RETURN TO UPDATE TS LOOP.
C
600   IF (NUMOUT.LE.0) GO TO 655
C
C NESTLED LOOP FOLLOWS. OUTER LOOP GOES THRU NUMBER OF OUTPUT TS.
C INNER LOOP CHECKS THE TS ID, DATA TYPE, TIME INTERVAL, AND DESCRIPTOR
C FOR INPUT TS AGAINST EAC OUTPUT TS.   NOTE: MUST MAKE TIME INT
C TO INTEGER FOR COMPARISON.
C
      DO 650 N=1,NUMOUT
C
        DO 630 I=1,7
          IF (I.EQ.4) GO TO 620
          IF (TSESP(NEX+11+I).NE.TINDX(N*7+I-7)) GO TO 650
          GO TO 630
C
620       IDTIN =TSESP(NEX+15)
          IDTOUT=TINDX(N*7-3)
          IF (IDTIN.NE.IDTOUT) GO TO 650
630     CONTINUE
C
        GO TO 900
C
650   CONTINUE
C
C AT THIS POINT NO MATCHES HAVE BEEN FOUND. CHECK IF IT WAS UPDATE TS
C
655   WRITE(IPR,690) (TSESP(NEX+11+I),I=1,7)
690   FORMAT(1H0,10X,43H**WARNING** THE FOLLOWING INPUT TIME SERIES,
     *58H HAS NOT BEEN DEFINED AS OUTPUT ON THE ESP (SCRATCH) FILE;
     */ 23X,4HID= ,2A4,7H DTYP= ,A4,6H IDT= ,F3.0,13H DESCRIPTOR= ,3A4
     */ 23X,55HCHECK TO BE SURE THIS TIME SERIES IS ON PERMANENT FILE.)
      CALL WARN
C
      IERSUM=1
      IF (IUPDT.EQ.1) GO TO 710
      GO TO 900
C
C === UPDATE TIME SERIES ===
C
C FOR UPDATE TS WE HAVE AN INPUT(IN EXTERNAL INFO) AND OUTPUT TS (IN ESP
C INFO). FIRST, SEE IF INPUT TS IS AN ESP FILE TYPE, IF SO, GO TO INPUT
C LOOP ABOVE TO CHECK IT.
C THEN, SEE IF OUTPUT TS IS AN ESP FILE TYPE, IF SO, ENTER IT IN TINDX
C ARRAY IF AND ONLY IF THE INPUT TS WAS NOT AN ESP TYPE OR THE INPUT TS
C WAS NOT FOUND IN TINDX ARRAY(NOTE THAT IN THIS CASE,AN UPDATE TS WITH
C NO MATCH IN TINDX ARRAY, THE INPUT TS LOOP WILL COME TO THE OUTPUT TS
C SECTION OF THE UPDATE TS LOOP).
C
700   IUPDT=1
      IF (TSESP(NEX+9).EQ.ESP) GO TO 600
C
710   NV=TSESP(NEX+11)
      NADD=TSESP(NEX+12+NV)
      IOUTFL=TSESP(NEX+14+NV+NADD)
      IF (IOUTFL.NE.ESP) GO TO 900
C
      DO 750 I=1,7
        TINDX(IPTR+I)=TSESP(NEX+15+NV+NADD+I)
750   CONTINUE
C
      NUMOUT=NUMOUT+1
      IPTR=IPTR+7
      GO TO 900
C
C === OUTPUT TIME SERIES ===
C
C FOR OUTPUT TS PUT ITS IDENTIFIERS INTO INDEX ARRAY. 4 IDENTIFIERS
C ARE PUT IN USING 7 ELEMENTS: TSID(2), DATYPE, TIME INTERVAL, AND
C DESCRIPTOR(3).
C
800   DO 850 I=1,7
        TINDX(IPTR+I)=TSESP(NEX+11+I)
850   CONTINUE
C
      NUMOUT=NUMOUT+1
      IPTR=IPTR+7
      GO TO 900
C
C NOW DONE WITH THIS TIME SERIES. SET NEX=NEXT TS LOCATION. IF
C STILL WITHIN ARRAY LENGTH(LTSESP) LOOP BACK UP TO NEXT TS,
C OTHERWISE RETURN.
C
900   NEX=TSESP(NEX+1)
      IF (NEX.LE.LTSESP) GO TO 550
C
C
C ..................DEBUG TIME .....................................
C
999   IF (IBUG.EQ.0) GO TO 1000
C
      WRITE(IODBUG,910) NUMOUT,IPTR
910   FORMAT(1H0,7HNUMOUT=,I5,1X,5HIPTR=,I5)
C
      IF (IPTR.GT.0) WRITE(IODBUG,920) (TINDX(I),I=1,IPTR)
920   FORMAT(1X,12HTINDX ARRAY: / 4(2X,2A4,1X,A4,F4.0,1X,3A4))
C ......................................................................
C
C CHANGE ERROR TRACE BACK THE WAY IT WAS
C
1000  IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
C
      RETURN
      END