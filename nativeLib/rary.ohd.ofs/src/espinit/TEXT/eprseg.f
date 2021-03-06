C MEMBER EPRSEG
C  (from old member EEPRSEG
C
      SUBROUTINE EPRSEG(IFREC,P,MP,T,MT,TS,MTS,PESP,MPESP,SPESP,
     *  MSPESP,TSESP,MTSESP,IPUNCH)
C
C ...................................................................
C
C          PRINT SEGMENT INFO SUBROUTINE
C
C THIS IS THE DRIVER ROUTINE FOR PRINTING INFO ABOUT A SEGMENT AS
C DEFINED BY THE FORECAST RECORD NUM(IFREC).
C PROCEDURE IS TO CALL FGETSG TO GET ESP RECORD NUM(IEREC) AND THEN
C CALL ESPRDF TO STORE THE SEGMENT INFO IN THE ESP ARRAYS AND
C COMMON BLK ESPSEG. THEN CALL THE ROUTINES TO PRINT THE INFO
C IN THE ARRAYS
C
C ORIGINALLY BY  ED VANBLARGAN - HRL - 1981
C
C .....................................................................
C
      INTEGER T(1), DUM(2)
      DIMENSION SBNAME(2),OLDOPN(2),P(1),TS(1),PESP(1),SPESP(1),TSESP(1)
C
      INCLUDE 'common/fcsegn'
      INCLUDE 'common/espseg'
      INCLUDE 'common/ionum'
      INCLUDE 'common/where'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/esprec'
      INCLUDE 'common/eunit'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/espinit/RCS/eprseg.f,v $
     . $',                                                             '
     .$Id: eprseg.f,v 1.2 2002/02/11 20:16:27 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA SBNAME,NAME/4HEPRS,4HEG  ,4HEPRT/
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
      IF(ITRACE.GE.1) WRITE(IODBUG,900)
  900 FORMAT(1H ,17H** EPRSEG ENTERED)
      IBUG=IFBUG(NAME)
C
C CALL FGETSG TO GET SEGMENT (AS DEFINED BY RECORD NUM,IFREC)
C INFO FROM FORECAST COMPONENT AND PUT INTO COMMON BLK FCSEGN.
C
      CALL FGETSG(DUM,IFREC,MP,P,MT,T,MTS,TS,1,0,IER)
C
      IF(IER.EQ.0) GO TO 200
      WRITE(IPR,100) IER,IFREC
100   FORMAT(1H0,10X,36H**ERROR** SUBROUTINE FGETSG RETURNED,
     *13H ERROR CODE =,I3,32H. EPRSEG QUITS FOR RECORD NUMBER,I5)
      CALL ERROR
      GO TO 999
C
C CHECK TO BE SURE ESP RECORD NUMBER(IEREC) ASSOCIATED WITH THIS
C SEGMENT IS GREATER THAN 1
C
200   IF (IEREC.GE.1) GO TO 300
      WRITE(IPR,220) IEREC,IFREC,IDSEGN
220   FORMAT(///,10X,35H*** NOTE *** ESP RECORD NUMBER WAS ,I6,
     *  /,10X,38H FOR FORECAST COMPONENT RECORD NUMBER ,I4,
     *  /,10X,42H ESP FILES CANNOT BE ACCESSED FOR SEGMENT ,2A4,/)
      GO TO 999
C
C CALL ESPRDF TO FILL COMMON BLK ESPSEG AND TO FILL ESP ARRAYS.
C THEN PUT SEGMENT NAME(ID) INTO ISEG IN CB/WHERE/.
C
300   CALL ESPRDF(1,1,IEREC,TSESP,MTSESP,PESP,MPESP,SPESP,MSPESP,IER)
C
      ISEG(1)=ID(1)
      ISEG(2)=ID(2)
C
      IF(IER.EQ.0) GO TO 400
      WRITE(IPR,320) IER,IEREC
320   FORMAT(1H0,10X,36H**ERROR** SUBROUTINE ESPRDF RETURNED,
     *  18H WITH ERROR CODE =,I3,18H FOR RECORD NUMBER,I5)
      CALL ERROR
      GO TO 999
C
C  CHECK WHETHER PUNCH OR PRINT IS DESIRED
C
400   IF (IPUNCH.EQ.1) GO TO 500
C
C CALL THE PRINT ROUTINES: EPRHD(PRINT HEADER), EPRTS(PRINT TSESP
C ARRAY), EPRP(PRINT PESP ARRAY)
C
      CALL EPRHD
C
      CALL EPRTS(TSESP,LTSESP)
C
      CALL EPRP(PESP,LPESP)
C
C     CALL EPRSP(SPESP,LSPESP)
C
C
      GO TO 999
C
C CALL THE PUNCH ROUTINE
C
500   CALL EPUNCH(PESP,MPESP,TSESP,MTSESP)
C
999   IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
C
      RETURN
      END
