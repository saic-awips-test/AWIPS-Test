C MODULE EDEFSG
C-----------------------------------------------------------------------
C
C  THIS ROUTINE IS THE DRIVER ROUTINE FOR COMMANDS SEGDEF AND RESEGDEF.

C  THIS ROUTINE WAS ORIGINALLY WRITTEN BY GERALD N. DAY.
C
      SUBROUTINE EDEFSG (CMND,IDSEG,P,MP,T,MT,TS,MTS,PESP,MPESP,
     *   SPESP,MSPESP,TSESP,MTSESP,TTS,MTTS,MAXD)
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/where'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fctime'
      INCLUDE 'common/fcsegn'
      INCLUDE 'common/fcunit'
      INCLUDE 'common/espfle'
      INCLUDE 'common/espseg'
      INCLUDE 'common/eunit'
      INCLUDE 'common/esprec'
      INCLUDE 'common/edata'
C
      CHARACTER*4 DTYPE,FILETP,EFILETP
      CHARACTER*8 TSID,TSTYPE,ETSTYPE
C
      INTEGER T
C
      DIMENSION P(1),T(1),TS(1),PESP(1),SPESP(1),TSESP(1),TTS(1)
      DIMENSION OLDOPN(2),CMDNAM(4),CMND(2),IDSEG(2),SUBCN(10),SUBCOM(2)
      DIMENSION DUM(2),SBNAME(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/espinit/RCS/edefsg.f,v $
     . $',                                                             '
     .$Id: edefsg.f,v 1.5 2001/06/13 13:05:33 dws Exp $
     . $' /
C    ===================================================================
C
      DATA SBNAME / 4hEDEF,4hSG   /, DEBUG / 4hINIT /, GT / 2hGT /
      DATA CMDNAM / 4hDEFS,4hEG  ,4hREDE,4hFSEG /
      DATA SUBCN  / 4hDEF-,4hTS  ,4hHIST,4hFILE,4hANAL,4hYSIS,4hSTAT,
     1              4hPACK,4hENDS,4hEG   /
C
C
      IOLDOP=IOPNUM
      IOPNUM=0
      DO 10 I=1,2
      OLDOPN(I)=OPNAME(I)
   10 OPNAME(I)=SBNAME(I)
C
      IF(ITRACE.GE.1) WRITE(IODBUG,*) 'ENTER EDEFSG'
C
      IBUG=IFBUG(DEBUG)
      ITYPE=0
      LTSESP=0
      LPESP=0
      LSPESP=0
C
C  FIND LOCATION ON FCSEGSTS
      CALL FLOCSG(IDSEG,IRSEG)
C
C  FILL COMMON/FCSEGN/ AND TS ARRAY
      CALL FGETSG(DUM,IRSEG,MP,P,MT,T,MTS,TS,1,0,IER)
      IF(IER.EQ.0) GO TO 15
      GO TO 999
C
C  CALCULATE AVAILABLE WORK SPACE
   15 NWORK=MAXD-IWKLOC+1
C
C  GET LOCATION OF SEG ON ESP FILE FROM COMMON/FCSEGN/
      ISGREC=IEREC
      IF(CMND(1).NE.CMDNAM(1).OR.CMND(2).NE.CMDNAM(2)) GO TO 30
C
C   DEFINE SEGMENT
      ITYPE=1
      IF(IEREC.EQ.0) GO TO 20
      WRITE(IPR,605) IDSEG
  605 FORMAT('0**ERROR** SEGMENT ',2A4,' IS ALREADY DEFINED.')
      CALL KILLPM
      GO TO 999
   20 CONTINUE
      DO 25 I=1,2
         ID(I)=IDSEG(I)
   25    CONTINUE
C
C   CALCULATE NUMBER OF RECORDS LEFT ON ESPFILE
      NUMREC=MXREC-NXREC+1
C
C   SET NEXT RECORD ON ESPFILE
      ISGREC=NXREC
      GO TO 50
C
C   REDEFINE SEGMENT
   30 ITYPE=2
      IF(IEREC.NE.0) GO TO 40
      WRITE(IPR,610) IDSEG
  610 FORMAT('0**ERROR** SEGMENT ',2A4,' IS NOT DEFINED.')
      CALL KILLPM
      GO TO 999
C
C   READ ESPFILE
   40 CALL ESPRDF (1,1,ISGREC,TSESP,MTSESP,PESP,MPESP,SPESP,MSPESP,IER)
      IF(IER.EQ.0) GO TO 45
      CALL KILLPM
      GO TO 999
C
C   CALCULATE NUMBER OF RECORDS AVAILABLE IN SLOT
C
   45 NUMREC=NSREC-ISGREC
C
C   READ SUBCOMMAND
   50 READ(IN,500) SUBCOM
  500 FORMAT(2A4)
      IF(IBUG.NE.1) GO TO 55
      WRITE(IODBUG,905) ID,ITYPE
  905 FORMAT(1H ,10X,8HSEGMENT=,2A4,6HITYPE=,I5)
      WRITE(IODBUG,910) SUBCOM
  910 FORMAT(1H ,10X,11HSUBCOMMAND ,2A4)
   55 IF(SUBCOM(1).EQ.SUBCN(1).AND.SUBCOM(2).EQ.SUBCN(2)) GO TO 70
C
C   FIRST SUBCOMMAND IS NOT DEF TS
      IF(ITYPE.NE.1) GO TO 60
      WRITE(IPR,615) SUBCOM,SUBCN(1),SUBCN(2)
  615 FORMAT(1H0,10X,10H**ERROR** ,23HTHE FIRST SUBCOMMAND IS,2X,2A4,5X,
     1 12HIT SHOULD BE,2X,2A4)
      CALL KILLPM
      GO TO 999
C
C  CHECK CHECK DATES - IF ESP NOT GT FC CALL ECHKTS
   60 ICRHR=ICRDTE(4)/100
      IF(ICRHR.EQ.0) ICRHR=1
      IEHR=IECKDT(4)/100
      IF(IEHR.EQ.0) IEHR=1
      CALL FCTZC(100,0,TZC)
      CALL JULDA(KJDFC,KHFC,ICRDTE(1),ICRDTE(2),ICRDTE(3),ICRHR,
     1 100,0,TZC)
      CALL JULDA(KJDECK,KHECK,IECKDT(1),IECKDT(2),IECKDT(3),IEHR,
     1 100,0,TZC)
      CALL FDATCK(KJDECK,KHECK,KJDFC,KHFC,GT,ISW)
      IF(ISW.EQ.1) GO TO 90
      CALL ECHKTS(TS,MTS,TSESP,MTSESP,IER)
      IF(IER.EQ.0) GO TO 90
      WRITE(IPR,620) IDSEG
  620 FORMAT(1H0,10X,40H**ERROR** CODE RETURNED FROM ECHKTS FOR ,
     1 15HSEGMENT NUMBER ,2A4)
      WRITE(IPR,625)
  625 FORMAT(1H0,10X,44HALL THE NECESSARY TIME SERIES HAVE NOT BEEN ,
     1 7HDEFINED)
      CALL KILLPM
      GO TO 999
C
C   DEF-TS SUBCOMMAND
C
C   READ TS DEF INFO AND CREATE TTS()
70    IREADC=1
      CALL ETSDEF (TTS,MTTS,TS,MTS,NWORK,
     *   IREADC,TSID,DTYPE,UNITS,ITIME,TSTYPE,EFILETP,ETSTYPE,LOCESP,
     *   IER)
      IF (IER.EQ.1) GO TO 999
      CALL ESPTS (TS,MTS,TTS,MTTS,TSESP,MTSESP,IER)
      IF (IER.EQ.1) GO TO 999
C
C   READ SUBCOMMAND
   80 READ(IN,500) SUBCOM
      IF(IBUG.EQ.1) WRITE(IODBUG,910) SUBCOM
   90 IF(SUBCOM(1).NE.SUBCN(3).OR.SUBCOM(2).NE.SUBCN(4)) GO TO 100
C
C   HISTORICAL FILE COMMAND
C
C   READ HISTORICAL FILE INFO, CREATE FILE, AND UPDATE TSESP()
C
C   BEFORE CALLING ERDHST, CREATE L VARIABLES WHICH WILL SERVE AS
C   PARTITIONS FOR PASSING THE SPACE IN P ARRAY.
C
      L1=1
      L2=L1+3*MXTS
      L3=L2+MXTS
      L4=L3+3*MXTS
      L5=L4+MXTS
      L6=L5+5*MXTS
      L7=L6+MXTS
      L8=L7+MXTS
      L9=L8+MXTS
C SET SPACE FOR QME TIME PERIOD ARRAYS
      MXQ=5
      L10=L9+MXTS
      L11=L10+MXQ
      L12=L11+MXQ
      L13=L12+MXQ
      L14=L13+MXQ
      L15=L14+MXTS
C
      LIMIT=L15+MXTS-1
C
      IF (LIMIT.LE.MP) GO TO 98
C
      WRITE(IPR,95)
   95 FORMAT(1H0,10X,42H**ERROR** P ARRAY EXCEEDED WHILE PREPARING,
     * 38H TO CALL HIST FILE. HIST FILE IGNORED.)
      CALL ERROR
      GO TO 80
C
   98 CALL ERDHST(TSESP,P(L1),
     * P(L2),P(L3),P(L4),P(L5),P(L6),P(L7),P(L8),P(L9),
     * P(L10),P(L11),P(L12),P(L13),MXQ,P(L14),P(L15),IER)
      IF (IER.NE.0) GO TO 999
      GO TO 80
C
  100 IF(SUBCOM(1).NE.SUBCN(5).OR.SUBCOM(2).NE.SUBCN(6)) GO TO 130
C
C   ANALYSIS SUBCOMMAND
C
C   READ ANALYSIS SECTION INPUT AND WRITE PESP()
C
      CALL ERDAN(PESP,MPESP,IER)
      IF(IER.EQ.0) GO TO 80
      WRITE(IPR,110)
110   FORMAT(1HO,44HABOVE ERROR OCCURED IN ERDAN(READ ANALYSIS).,
     * 49H MANY ERROR MESSAGES MAY FOLLOW ALL DUE TO ABOVE.)
      GO TO 999
C
  130 IF(SUBCOM(1).NE.SUBCN(7).OR.SUBCOM(2).NE.SUBCN(8)) GO TO 150
C
C   STATISTICS PACKAGE COMMAND
C
C   READ STATISTICS PACKAGE INPUT AND WRITE SPESP()
C
C     CALL ERDSP(SPESP,MSPESP)
C     GO TO 80
  150 IF(SUBCOM(1).EQ.SUBCN(9).AND.SUBCOM(2).EQ.SUBCN(10)) GO TO 170
      WRITE(IPR,630) SUBCOM
  630 FORMAT(1H0,10X,10H**ERROR** ,2A4,2X,24HIS AN INVALID SUBCOMMAND)
      CALL ERROR
      GO TO 999
C
C  END SEGMENT COMMAND
C
C  SET CREATION DATE
  170 DO 180 I=1,5
         IECKDT(I)=NOW(I)
         IF(ITYPE.EQ.2) GO TO 180
         IECRDT(I)=NOW(I)
  180    CONTINUE
C
C  CALCULATE LENGTH OF ESP FILE
      LENGTH=16+LTSESP+LPESP+LSPESP
      NRECS=LENGTH/LRECL
      IF((NRECS*LRECL).NE.LENGTH) NRECS=NRECS+1
      IF(ITYPE.EQ.2) GO TO 250
C
C  DEFINE
  190 IF(NRECS.LE.NUMREC) GO TO 200
      WRITE(IPR,635) ID
  635 FORMAT(1H0,10X,18H**ERROR** SEGMENT ,2A4,2X,
     1 51HNOT DEFINED, NOT ENOUGH SPACE ON THE PARAMETER FILE)
      CALL ERROR
      GO TO 999
C
C  CALCULATE NEXT AVAILABLE WRITE LOCATION ON FILE
  200 NSREC=NXREC+NRECS
C
C  WRITE SEG INFO
      CALL ESPWTF(ISGREC,TSESP,MTSESP,PESP,MPESP,SPESP,MSPESP,IER)
      IF(IER.EQ.0) GO TO 220
      CALL KILLPM
      GO TO 999
C
C  SET NEXT AVAILABLE WRITE LOCATION
  220 NXREC=NSREC
      ESPDAT(1)=MXREC+.01
      ESPDAT(2)=NXREC+.01
      ESPDAT(3)=LRECL+.01
      CALL UWRITT(KEPARM,1,ESPDAT,IERR)
C
C  UPDATE VALUE OF IEREC ON FC FILE FCSEGSTS
      IEREC=ISGREC
      CALL UWRITT(KFSGST,IRSEG,IDSEGN,IERR)
      WRITE(IPR,640) IDSEG
  640 FORMAT(1H0,30X,8HSEGMENT ,2A4,17H HAS BEEN DEFINED)
      GO TO 999
C
C  REDEFINE
  250 IF(NRECS.GT.NUMREC) GO TO 270
C
C  WRITE SEG INFO IN SAME LOCATION
      CALL ESPWTF(ISGREC,TSESP,MTSESP,PESP,MPESP,SPESP,MSPESP,IER)
      IF(IER.EQ.0) GO TO 260
      CALL KILLPM
      GO TO 999
C
260   CALL UPCLOS(KEPARM,' ',ISTAT)
      WRITE(IPR,640) IDSEG
      GO TO 999
C
C  DELETE OLD SEG DEFINITION
  270 CALL EDELSG(0,ISGREC,IDSEG,1)
C
C  CALCULATE NUMBER OF RECS LEFT ON FILE
      NUMREC=MXREC-NXREC+1
      ISGREC=NXREC
C
C  TREAT LIKE SEG DEFINITION
      GO TO 190
C
  999 IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
C
      RETURN
C
      END
