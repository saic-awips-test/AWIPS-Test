C MEMBER PM0726
C  (from old member FCPM0726)
C
      SUBROUTINE PM0726(WORK,IUSEW,LEFTW,NP07,
     .                  LENDSU,JDEST,IERR)
C---------------------------------------------------------------------
C  SUBROUTINE TO READ AND INTERPRET PARAMETER INPUT FOR S/U #07
C    POOL ELEVATION VS. DISCHARGE
C---------------------------------------------------------------------
C  JTOSTROWSKI - HRL - MARCH 1983
C----------------------------------------------------------------
C
      INCLUDE 'common/comn26'
C
C
      INCLUDE 'common/err26'
C
C
      INCLUDE 'common/fld26'
C
C
      INCLUDE 'common/mult26'
C
C
      INCLUDE 'common/rc26'
C
C
      INCLUDE 'common/read26'
C
C
      INCLUDE 'common/suid26'
C
C
      INCLUDE 'common/suin26'
C
C
      INCLUDE 'common/suky26'
C
C
      INCLUDE 'common/warn26'
C
      DIMENSION INPUT(2,4),LINPUT(4),VALUE(100),IP(4),
     . RVAL(100),WORK(1)
      LOGICAL ENDFND,CRVOK,NEEDRC,ALLOK,RCOK,TIMEOK,NEEDTM
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_res/RCS/pm0726.f,v $
     . $',                                                             '
     .$Id: pm0726.f,v 1.2 1996/07/12 13:17:30 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA INPUT/4HPOOL,4HVSQ ,4HLINE,4HAR  ,
     .           4HCURV,4HE   ,4HRULE,4HTIME/
      DATA LINPUT/2,2,2,2/
      DATA NINPUT/4/
      DATA NDINPU/2/
C
      DATA PQCODE/1070.01/
C
C  INITIALIZE LOCAL VARIABLES AND COUNTERS
C
      INPQ = 1
      NP07 = 0
      CRVOK = .FALSE.
      RCOK = .TRUE.
      TIMEOK = .TRUE.
      NEEDTM = .FALSE.
      RTIME = -999.0
      NEEDRC = .FALSE.
      ALLOK = .TRUE.
      CODEPQ = PQCODE + SULEVL
C
C  NOW PROCESS INPUT UP TO 'ENDP', LOOKING FOR 'POOLVSQ'(REQUIRED),
C   AND 'CURVE' (OPTIONAL - ONLY NEEDED IF ANY ELEVATION IN POOL.VS.Q
C   CURVE EQUALS -999.0)
C
C
      DO 3 I = 1,NINPUT
           IP(I) = 0
    3 CONTINUE
C
      IERR = 0
C
C  PARMS FOUND, LOOKING FOR ENDP
C
      LPOS = LSPEC + NCARD + 1
      LASTCD = LENDSU
      IBLOCK = 1
C
    5 IF (NCARD .LT. LASTCD) GO TO 8
           CALL STRN26(59,1,SUKYWD(1,7),3)
           IERR = 99
           GO TO 9
    8 NUMFLD = 0
      CALL UFLD26(NUMFLD,IERF)
      IF(IERF .GT. 0 ) GO TO 9000
      NUMWD = (LEN -1)/4 + 1
      IDEST = IKEY26(CHAR,NUMWD,SUKYWD,LSUKEY,NSUKEY,NDSUKY)
      IF (IDEST.EQ.0) GO TO 5
C
C  IDEST = 7 IS FOR ENDP
C
      IF (IDEST.EQ.7.OR.IDEST.EQ.8) GO TO 9
          CALL STRN26(59,1,SUKYWD(1,7),3)
          JDEST = IDEST
          IERR = 89
    9 LENDP = NCARD
C
C  ENDP CARD OR TS OR CO FOUND AT LENDP,
C  ALSO ERR RECOVERY IF NEITHER ONE OF THEM FOUND.
C
C
      IBLOCK = 2
      CALL POSN26(MUNI26,LPOS)
      NCARD = LPOS - LSPEC -1
C
   10 CONTINUE
      NUMFLD = 0
      CALL UFLD26(NUMFLD,IERF)
      IF(IERF .GT. 0) GO TO 9000
      NUMWD = (LEN -1)/4 + 1
      IDEST = IKEY26(CHAR,NUMWD,INPUT,LINPUT,NINPUT,NDINPU)
      IF(IDEST .GT. 0) GO TO 50
      IF(NCARD .GE. LENDP) GO TO 900
C
C  NO VALID KEYWORD FOUND
C
      CALL STER26(1,1)
      ALLOK = .FALSE.
      GO TO 10
C
C  NOW SEND CONTROL TO PROPER LOCATION FOR PROCESSING EXPECTED INPUT
C
   50 CONTINUE
      GO TO (100,200,300,400) , IDEST
C
C----------------------------------------------------------------------
C  'POOLVSQ' KEYWORD IS EXPECTED HERE. IF NOT FOUND, SIGNAL ERROR
C
  100 CONTINUE
      IP(1) = IP(1) + 1
      IF (IP(1).GT.1) CALL STER26(39,1)
C
C  GO GET LIST OF VALUES FOR DEFINING THE POOL VS Q CURVE
C
C
      NVAL=100
      CALL GLST26(1,1,X,VALUE,X,NVAL,CRVOK)
      IF (.NOT.CRVOK) GO TO 10
C
C  FOUR CHECKS MUST BE MADE ON THE CURVE:
C   1) THE TOTAL NO. OF VALUES INPUT MUST BE EVEN (PAIRS OF VALUES ARE
C      NEEDED,
C   2) ALL DISCHARGES MUST BE .GE. ZERO,
C   3) THE ELEVATIONS MUST BE BETWEEN THE DEFINED BOUNDARIES OF THE ELEV
C      VS STORAGE CURVE,
C   4) THE ELEVATIONS MUST BE IN ASCENDING ORDER.
C
      IF (MOD(NVAL,2).EQ.0) GO TO 120
C
      CALL STER26(40,1)
      GO TO 10
C
  120 CONTINUE
      NHALF = NVAL/2
      NSEC = NHALF + 1
C
C  SEE IF DISCHARGES ARE POSITIVE
C
      DO 125 I=NSEC,NVAL
      IF ((VALUE(I)).GE.0.0) GO TO 125
C
      CALL STER26(95,1)
      GO TO 10
C
  125 CONTINUE
C
C  IF ANY ELEVATION IS -999.0, A RULE CURVE IS NEEDED. HOLD ANY VALUE
C  CHECKING UNTIL WE GET THE RULE CURVE.
C  ERROR OUT IF MORE THAN ONE -999.0 ARE ENTERED
C
      NRC = 0
      DO 130 I=1,NHALF
      IF (ABS(VALUE(I)+999.0).GT.0.1) GO TO 130
C
      NEEDRC = .TRUE.
C      GO TO 140
      NRC = NRC+1
C
  130 CONTINUE
      IF (NRC .LE. 1) GO TO 140
      CALL STER26(122,1)
      GO TO 10
C
C  SEE IF ELEVATIONS ARE IN ASCENDING ORDER
C
  140 CONTINUE
      CALL ASCN26(VALUE,NHALF,0,IERA)
      IF (IERA.GT.0) GO TO 10
C
C  SEE IF ELEVATIONS ARE WITHIN BOUNDS OF ELEV VS. STORAGE CURVE
C  IF CURVE WAS NOT DEFINED, CALL IT AN ERROR
C
C
C  CONVERT ELEVATIONS.
C
      DO 155 I=1,NHALF
          IF (VALUE(I).LE.0.0) GO TO 155
          VALUE(I) = VALUE(I)/CONVL
  155 CONTINUE
C
C  CONVERT DISCHARGES.
C
      DO 165 I =NSEC,NVAL
          VALUE(I) = VALUE(I) / CONVL3
  165 CONTINUE
C
      CALL ELST26(VALUE,NHALF,IERST)
      IF (IERST.GT.0) GO TO 10
C
  195 CONTINUE
      CRVOK = .TRUE.
      GO TO 10
C
C   'LINEAR' KEYWORD FOUND, LINEAR INTERPOLATION SCHEME USED
C
  200 CONTINUE
      INPQ = -1
      GO TO 10
C
C-----------------------------------------------------------------------
C  'CURVE' IS NEXT IN LINE. IF NEEDED, BUT 'ENDP' FOUND,
C   CALL IT AN ERROR. IF UNNEEDED, BUT FOUND, ALSO CALL IT AN ERROR.
C   ONLY GOOD SITUATION IS THAT IT'S NEEDED AND IT'S FOUND.
C
  300 CONTINUE
      IP(3) = IP(3) + 1
      IF (IP(3).GT.1) CALL STER26(39,1)
      IF (NEEDRC) GO TO 310
C
C  IF POOLVSQ FOUND AND RULECURVE 'CURVE' IS NOT NEEDED , SIGNAL ERR 60.
C  IF POOLVSQ NOT FOUND, SIGNAL ERR 59 FOR IT. -- IT SHOULD COME
C  BEFORE RULECURVE CARD.
C
           IF(IP(1).GT.0) CALL STRN26(60,1,INPUT(1,IDEST),LINPUT(IDEST))
           IF(IP(1).EQ.0) CALL STRN26(59,1,INPUT(1,1),LINPUT(1))
           RCOK = .FALSE.
           GO TO 10
C
C  READ FIRST FIELD AFTER 'CURVE'. IF IT'S NUMERIC, GET LIST OF
C   NUMBERS FOR DEFINING CURVE
C  IF IT'S CHARACTER, ASSUME A MULTIPLE USE REFERENCE HAS BEEN ENTERED,
C   AND SEE IF SPEC IS VALID.
C
C
  310 CONTINUE
C
      RCOK = .FALSE.
      ELUPR = -999999.
      ELOWR = 999999.
C
      LPOSST = LSPEC + NCARD
      NUMFLD = -2
      CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
      ICTYPE = ITYPE
      IF (ICTYPE.GT.1) GO TO 360
C
C  REPOSITION TO READ FIRST FIELD AFTER 'CURVE'
C
      NEEDTM = .TRUE.
      CALL POSN26(MUNI26,LPOSST)
      NCARD = LPOSST - LSPEC -1
      NUMFLD = 0
      CALL UFLD26(NUMFLD,IERF)
C
C
C GET LIST OF VALUES FOR DEFINING THE RULE CURVE
C
      NRVAL=100
      CALL GLST26(1,1,X,RVAL,X,NRVAL,RCOK)
      IF (.NOT.RCOK) GO TO 10
C
C  FOUR CHECKS MUST BE MADE ON THE CURVE:
C   1) THE TOTAL NO. OF VALUES INPUT MUST BE EVEN (PAIRS OF VALUES ARE
C      NEEDED,
C   2) THE ELEVATIONS MUST BE BETWEEN THE DEFINED BOUNDARIES OF THE ELEV
C      VS STORAGE CURVE,
C   3) THE DATES MUST BE BETWEEN 2 AND 366, AND
C   4) THE DATES MUST BE IN ASCENDIONG ORDER.
C
      IF (MOD(NRVAL,2).EQ.0) GO TO 320
C
      CALL STER26(40,1)
      GO TO 10
C
  320 CONTINUE
      NRHALF = NRVAL/2
      NRSEC = NRHALF + 1
C
C  SEE IF DATES ARE IN ASCENDING ORDER
C
      CALL ASCN26(RVAL,NRHALF,0,IERA)
      IF (IERA.GT.0) GO TO 10
C
C  SEE IF DATES ARE BETWEEN 1 AND 366
C
      DO 340 I=1,NRHALF
      RVAL(I) = RVAL(I)
      IF (1.0.LE.RVAL(I).AND.RVAL(I).LE.366.02) GO TO 340
C
      CALL STER26(64,1)
      GO TO 10
C
  340 CONTINUE
C
C  SEE IF ELEVATIONS ARE WITHIN BOUNDS OF ELEV VS. STORAGE CURVE
C  IF CURVE WAS NOT DEFINED, CALL IT AN ERROR
C
      DO 355 I=NRSEC,NRVAL
      RVAL(I) = RVAL(I)/CONVL
      ELUPR = AMAX1(ELUPR,RVAL(I))
      ELOWR = AMIN1(ELOWR,RVAL(I))
  355 CONTINUE
C
      CALL ELST26(RVAL(NRSEC),NRHALF,IERST)
      IF (IERST.GT.0) GO TO 10
C
C  STORE CODE FOR RULECURVE IN /MULT26/
C
      NMDEF(1) = NMDEF(1) + 1
      DMCODE(NMDEF(1),1) = CODEPQ
C
      GO TO 370
C
C--------------------------------
C  FIRST FIELD AFTER 'CURVE' IS CHARACTER. SEE IF IT'S A VALID S/U ID
C  WITH OR WITHOUT PARENTHESES
C
  360 CONTINUE
      NEEDTM = .FALSE.
      CALL MREF26(1,CODEPQ,LOCWK,LOCCPQ,IERM)
      IF (IERM.GT.0) GO TO 10
C
C  GET THE UPPER AND LOWER BOUNDS OF THE RULE CURVE
C
      CALL BDRC26(WORK,LOCWK,ELUPR,ELOWR,IERC)
      IF (IERC.GT.0) GO TO 10
C
C  NOW MUST CHECK TO SEE IF POOLVSQ SPECS (USING RULE CURVE VALUES)
C  ARE BRACKETED PROPERLY. IF A RULE CURVE ELEVATION IS TO BE USED,
C  THE RANGE OF VALUES MUST FIT WITHIN THE NEXT LOWEST AND NEXT HIGHEST
C  POOL ELEVATIONS IN THE POOLVSQ
C
  370 CONTINUE
      IF (.NOT.CRVOK) GO TO 10
C
C$     NEND = NHALF - 1
C$     DO 380 I=2,NEND
C$     IF (ABS(VALUE(I-1)+999.0).LE.0.1 .OR. ABS(VALUE(I)+999.0).LE.0.1)
C$    & GO TO 380
C      IF  (VALUE(I-1).LT.ELOWR.AND.ELOWR.LT.VALUE(I+1). AND.
C     .     VALUE(I-1).LT.ELUPR.AND.ELUPR.LT.VALUE(I+1)) GO TO 380
C$     IF (ELOWR.GE.VALUE(I-1) .AND. ELUPR.LE.VALUE(I+1)) GO TO 380
C
C$     CALL STRN26(67,1,INPUT(1,1),LINPUT(1))
C$     GO TO 10
C
C$ 380 CONTINUE
C
C  CURVE IS DEFINED OK
C
      RCOK = .TRUE.
      GO TO 10
C
C-----------------------------------------------------------------
C  'RULETIME' KEYWORD EXPECTED. IF FOUND, GET NEXT FIELD ON CARD
C   IF NOT FOUND, STORE VALUES IN WORK USING DEFAULT
C
  400 CONTINUE
C
      IP(4) = IP(4) + 1
      IF (IP(4).GT.1) CALL STER26(39,1)
      IF (NEEDTM) GO TO 410
C
C  'RULETIME' FOUND BUT NOT NEEDED. (I.E. - A REFERENCE TO 'CURVE' WAS
C   FOUND.)
C
      CALL STRN26(60,1,INPUT(1,3),2)
      GO TO 10
C
C  AN INTEGER VALUE ( OR A NULL FIELD) MUST FOLLOW
C
  410 CONTINUE
C
      TIMEOK = .FALSE.
      NUMFLD = -2
      CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.1) GO TO 9000
      IF (IERF.EQ.1) GO TO 450
C
C  SPECIFICATION MUST BE INTEGER
C
      IF (ITYPE.EQ.0) GO TO 420
      CALL STER26(5,1)
      GO TO 10
C
  420 CONTINUE
C
C  RULETIME MUST BE .GE. ZERO
C
      IF (INTEGR.GE.0) GO TO 430
C
      CALL STER26(95,1)
      GO TO 10
C
C  TIME MUST BE MULTIPLE OF OPERATION TIME INTERVAL.
C
  430 CONTINUE
C$     IF (MOD(INTEGR,MINODT).EQ.0) GO TO 440
C
C$     CALL STER26(47,1)
C$     GO TO 10
C
C$ 440 CONTINUE
      RTIME = INTEGR + 0.01
C
C  EVERYTHING IS OK
C
  450 CONTINUE
      TIMEOK = .TRUE.
      GO TO 10
C
C--------------------------------------------------------------------
C  END OF INPUT. STORE VALUES IN WORK ARRAY IF EVERYTHING WAS ENTERED
C  WITHOUT ERROR.
C
  900 CONTINUE
C
      IF (IP(1).EQ.0) CALL STRN26(59,1,INPUT(1,1),LINPUT(1))
      IF (IP(3).EQ.0.AND.NEEDRC) CALL STRN26(59,1,INPUT(1,3),LINPUT(3))
C
      IF (CRVOK.AND.RCOK.AND.TIMEOK.AND.ALLOK) GO TO 1010
      GO TO 9999
C
C  STORE THE POOLVSQ CURVE, AND IF NEEDED THE RULECURVE DEFINITION 'CURV
C  OR THE REFERENCE TO IT, IN THE WORK ARRAY
C
 1010 CONTINUE
C
      PAIR = NVAL/2 + 0.01
      IF (INPQ .LT. 0) PAIR=-PAIR
      CALL FLWK26(WORK,IUSEW,LEFTW,PAIR,501)
C
      DO 1015 I=1,NVAL
      CALL FLWK26(WORK,IUSEW,LEFTW,VALUE(I),501)
 1015 CONTINUE
C
      NP07 = NVAL + 1
C
C  BYPASS RULE CURVE 'CURVE' STORAGE IF ONE IS NOT NEEDED.
C
      IF (.NOT.NEEDRC) GO TO 1040
      IF (ICTYPE.GT.1) GO TO 1030
C
C  CURVE WAS DEFINED IN THIS SCHEME
C
      PAIR = NRVAL/2 + 0.01
      CALL FLWK26(WORK,IUSEW,LEFTW,PAIR,501)
C
C  STORE LOCATION FOR THIS RULE CURVE DEFINITION
C
      IPOWD(NMDEF(1),1) = NPMENT + NP07 + 1
      IWKWD(NMDEF(1),1) = IUSEW
C
C  STORE CURVE DEFINITION
C
      DO 1020 I=1,NRVAL
      CALL FLWK26(WORK,IUSEW,LEFTW,RVAL(I),501)
 1020 CONTINUE
C
C  STORE RULE TIME HERE
C
      CALL FLWK26(WORK,IUSEW,LEFTW,RTIME,501)
      NRVAL = NRVAL + 1
      GO TO 1050
C
C  STORE REFERENCE TO PREVIOUS DEFINITION IN WORK
C
 1030 CONTINUE
      CPQLOC = - (LOCCPQ+0.01)
      NRVAL = 0
      CALL FLWK26(WORK,IUSEW,LEFTW,CPQLOC,501)
      GO TO 1050
C
C  INDICATE THAT RULE CURVE IS NOT NEEDED
C
 1040 CONTINUE
      RCVALU = 0.01
      NRVAL = 0
      CALL FLWK26(WORK,IUSEW,LEFTW,RCVALU,501)
C
 1050 CONTINUE
C
      NP07 = NP07 + NRVAL + 1
      GO TO 9999
C
C--------------------------------------------------------------
C  ERROR IN UFLD26
C
 9000 CONTINUE
      IF (IERF.EQ.1) CALL STER26(19,1)
      IF (IERF.EQ.2) CALL STER26(20,1)
      IF (IERF.EQ.3) CALL STER26(21,1)
      IF (IERF.EQ.4) CALL STER26( 1,1)
C
      IF (NCARD.GE.LASTCD) GO TO 9100
      IF (IBLOCK.EQ.1)  GO TO 5
      IF (IBLOCK.EQ.2)  GO TO 10
C
 9100 USEDUP = .TRUE.
C
 9999 CONTINUE
      RETURN
      END
