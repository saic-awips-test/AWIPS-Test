C MEMBER PM1426
C  (from old member FCPM1426)
C
      SUBROUTINE PM1426(WORK,IUSEW,LEFTW,NP14,NPER,
     .                  LENDSU,JDEST,IERR)
C---------------------------------------------------------------------
C  SUBROUTINE TO READ AND INTERPRET PARAMETER INPUT FOR S/U #14
C    RULE CURVE ADJUSTMENT
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
      DIMENSION INPUT(3,5),LINPUT(5),IP(5),
     . RVAL(100),WORK(1)
      LOGICAL ENDFND,ALLOK,RCOK,QMOK,PDOK,DOK,TIMEOK,NEEDTM
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_res/RCS/pm1426.f,v $
     . $',                                                             '
     .$Id: pm1426.f,v 1.2 1996/07/12 13:19:33 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA INPUT/
     .            4HCURV,4HE   ,4H    ,4HRULE,4HTIME,4H    ,
     .            4HPERI,4HODS ,4H    ,4HELEV,4HDIFF,4H    ,
     .            4HMAXQ,4HI   ,4H    /
      DATA LINPUT/2,2,2,2,2/
      DATA NINPUT/5/
      DATA NDINPU/3/
C
      DATA RACODE/1510.01/
C
C  INITIALIZE LOCAL VARIABLES AND COUNTERS
C
      NP14 = 0
      QMOK = .FALSE.
      RCOK = .FALSE.
      TIMEOK = .TRUE.
      NEEDTM = .FALSE.
      RTIME = -999.0
      PDOK = .FALSE.
      DOK = .FALSE.
      ALLOK = .TRUE.
      NPER = 0
      CODERA = RACODE + SULEVL
C
C  NOW PROCESS INPUT UP TO 'ENDP', LOOKING FOR RULECURVE 'CURVE'
C  (REQUIRED),
C   'PERIODS' (REQUIRED), 'DIFFI' (REQUIRED), AND 'MAXQI' (REQUIRED).
C
C
      DO 3 I = 1,5
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
      GO TO (100,200,300,400,500) , IDEST
C
C-----------------------------------------------------------------------
C  'CURVE' IS REQUIRED. IF NOT FOUND IT IS AN ERROR
C
  100 CONTINUE
      IP(1) = IP(1) + 1
      IF (IP(1).GT.1) CALL STER26(39,1)
C
C  READ FIRST FIELD AFTER 'CURVE'. IF IT'S NUMERIC, GET LIST OF
C   NUMBERS FOR DEFINING CURVE
C  IF IT'S CHARACTER, ASSUME A MULTIPLE USE REFERENCE HAS BEEN ENTERED,
C   AND SEE IF SPEC IS VALID.
C
      LPOSST = LSPEC + NCARD
      NUMFLD = -2
      CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
      ICTYPE = ITYPE
      IF (ICTYPE.GT.1) GO TO 160
C
C  REPOSITION TO READ FIRST FIELD AFTER 'CURVE'
C
      NEEDTM = .TRUE.
      CALL POSN26(MUNI26,LPOSST)
      NCARD = LPOSST - LSPEC -1
      NUMFLD = 0
      CALL UFLD26(NUMFLD,IERF)
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
C   1) THE ELEVATIONS MUST BE BETWEEN THE DEFINED BOUNDARIES OF THE ELEV
C      VS STORAGE CURVE,
C   3) THE DATES MUST BE BETWEEN 1 AND 366, AND
C   4) THE DATES MUST BE IN ASCENDIONG ORDER.
C
      IF (MOD(NRVAL,2).EQ.0) GO TO 120
C
      CALL STER26(40,1)
      GO TO 10
C
  120 CONTINUE
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
      DO 140 I=1,NRHALF
      RVAL(I) = RVAL(I)
      IF (1.0.LE.RVAL(I).AND.RVAL(I).LE.366.02) GO TO 140
C
      CALL STER26(64,1)
      GO TO 10
C
  140 CONTINUE
C
C  SEE IF ELEVATIONS ARE WITHIN BOUNDS OF ELEV VS. STORAGE CURVE
C  IF CURVE WAS NOT DEFINED, CALL IT AN ERROR
C
      DO 155 I=NRSEC,NRVAL
      RVAL(I) = RVAL(I)/CONVL
  155 CONTINUE
C
      CALL ELST26(RVAL(NRSEC),NRHALF,IERST)
      IF (IERST.GT.0) GO TO 10
C
C  STORE CODE FOR RULECURVE IN /MULT26/
C
      NMDEF(1) = NMDEF(1) + 1
      DMCODE(NMDEF(1),1) = CODERA
C
      GO TO 170
C
C--------------------------------
C  FIRST FIELD AFTER 'CURVE' IS CHARACTER. SEE IF IT'S A VALID S/U ID
C  WITH OR WITHOUT PARENTHESES
C
  160 CONTINUE
      CALL MREF26(1,CODERA,LOCWK,LOCCRA,IERM)
      IF (IERM.GT.0) GO TO 10
C
C  CURVE IS DEFINED OK
C
  170 CONTINUE
      RCOK = .TRUE.
      GO TO 10
C
C-----------------------------------------------------------------
C  'RULETIME' KEYWORD EXPECTED. IF FOUND, GET NEXT FIELD ON CARD
C   IF NOT FOUND, STORE VALUES IN WORK USING DEFAULT
C
  200 CONTINUE
C
      IP(2) = IP(2) + 1
      IF (IP(2).GT.1) CALL STER26(39,1)
C
      IF (NEEDTM) GO TO 210
C
C  'RULETIME' FOUND BUT NOT NEEDED. (I.E. - A REFERENCE TO 'CURVE' WAS
C   FOUND.)
C
      CALL STRN26(60,1,INPUT(1,2),2)
      GO TO 10
C
C  AN INTEGER VALUE ( OR A NULL FIELD) MUST FOLLOW
C
  210 CONTINUE
C
      TIMEOK = .FALSE.
      NUMFLD = -2
      CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.1) GO TO 9000
      IF (IERF.EQ.1) GO TO 250
C
C  SPECIFICATION MUST BE INTEGER
C
      IF (ITYPE.EQ.0) GO TO 220
      CALL STER26(5,1)
      GO TO 10
C
  220 CONTINUE
C
C  RULETIME MUST BE .GE. ZERO
C
      IF (INTEGR.GE.0) GO TO 230
C
      CALL STER26(95,1)
      GO TO 10
C
C  TIME MUST BE MULTIPLE OF OPERATION TIME INTERVAL.
C
  230 CONTINUE
C$     IF (MOD(INTEGR,MINODT).EQ.0) GO TO 240
C
C$     CALL STER26(47,1)
C$     GO TO 10
C
C$ 240 CONTINUE
      RTIME = INTEGR + 0.01
C
C  EVERYTHING IS OK
C
  250 CONTINUE
      TIMEOK = .TRUE.
      GO TO 10
C
C----------------------------------------------------------------------
C  'PERIODS' KEYWORD IS EXPECTED HERE. IF NOT FOUND, SIGNAL ERROR
C
  300 CONTINUE
      IP(3) = IP(3) + 1
      IF (IP(3).GT.1) CALL STER26(39,1)
C
C  NUMBER OF PERIODS MUST BE A POSITIVE INTEGER
C
      NUMFLD = -2
      CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
      IF (ITYPE.EQ.0) GO TO 320
      CALL STER26(5,1)
      GO TO 10
C
  320 CONTINUE
      INTEGR=IABS(INTEGR)
      IF (INTEGR .LE. 100) GO TO 330
      CALL STER26(122,1)
      GO TO 10
C
C  EVERYTHING IS OK
C
  330 CONTINUE
      NPER = INTEGR
      PERIOD = NPER + 0.01
      PDOK = .TRUE.
      GO TO 10
C
C----------------------------------------------------------------------
C  'DIFFI' KEYWORD IS EXPECTED HERE. IF NOT FOUND, SIGNAL ERROR
C
  400 CONTINUE
      IP(4) = IP(4) + 1
      IF (IP(4).GT.1) CALL STER26(39,1)
C
C  DIFFERENCE MUST BE A POSITIVE REAL
C
      NUMFLD = -2
      CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
      IF (ITYPE.LE.1) GO TO 420
      CALL STER26(4,1)
      GO TO 10
C
  420 CONTINUE
      IF (REAL.GT.0) GO TO 430
      CALL STER26(61,1)
      GO TO 10
C
C  EVERYTHING IS OK
C
  430 CONTINUE
      DIFF = REAL/CONVL
      DOK = .TRUE.
      GO TO 10
C
C----------------------------------------------------------------------
C  'MAXQI' KEYWORD IS EXPECTED HERE. IF NOT FOUND, SIGNAL ERROR
C
  500 CONTINUE
      IP(5) = IP(5) + 1
      IF (IP(5).GT.1) CALL STER26(39,1)
C
C  DIFFERENCE MUST BE A POSITIVE REAL
C
      NUMFLD = -2
      CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
      IF (ITYPE.LE.1) GO TO 520
      CALL STER26(4,1)
      GO TO 10
C
  520 CONTINUE
      IF (REAL.GT.0) GO TO 530
      CALL STER26(61,1)
      GO TO 10
C
C  EVERYTHING IS OK
C
  530 CONTINUE
      QMAXI = REAL/CONVLT
      QMOK = .TRUE.
      GO TO 10
C
C--------------------------------------------------------------------
C  END OF INPUT. STORE VALUES IN WORK ARRAY IF EVERYTHING WAS ENTERED
C  WITHOUT ERROR.
C
  900 CONTINUE
C
      IF (IP(1).EQ.0) CALL STRN26(59,1,INPUT(1,1),LINPUT(1))
      DO 910 I = 3,5
           IF (IP(I).EQ.0) CALL STRN26(59,1,INPUT(1,I),LINPUT(I))
  910 CONTINUE
C
      IF (DOK.AND.PDOK.AND.QMOK.AND.RCOK.AND.TIMEOK.AND.ALLOK)
     .  GO TO 1010
      GO TO 9999
C
C  STORE EITHER THE RULE CURVE DEFINITION OR THE REFERENCE TO
C  THE DEFINITION, FOLLOWED BY THE VALUES FOR THE NUMBER OF PERIODS,
C  THE MAXIMUM ELEVATION DIFFERENCE, AND THE MAXIMUM FLOW.
C
 1010 CONTINUE
C
      IF (ICTYPE.GT.1) GO TO 1030
C
C  CURVE WAS DEFINED IN THIS SCHEME
C
      PAIR = NRVAL/2 + 0.01
      CALL FLWK26(WORK,IUSEW,LEFTW,PAIR,501)
C
C  STORE LOCATION FOR THIS RULE CURVE DEFINITION
C
      IPOWD(NMDEF(1),1) = NPMENT + NP14 + 1
      IWKWD(NMDEF(1),1) = IUSEW
C
C  STORE CURVE DEFINITION
C
      DO 1020 I=1,NRVAL
      CALL FLWK26(WORK,IUSEW,LEFTW,RVAL(I),501)
 1020 CONTINUE
C
C  STORE TIME OF RULE CURVE
C
      CALL FLWK26(WORK,IUSEW,LEFTW,RTIME,501)
      NRVAL = NRVAL + 1
      GO TO 1050
C
C  STORE REFERENCE TO PREVIOUS DEFINITION IN WORK
C
 1030 CONTINUE
      CRALOC = - (LOCCRA+0.01)
      NRVAL = 0
      CALL FLWK26(WORK,IUSEW,LEFTW,CRALOC,501)
C
 1050 CONTINUE
C
      NP14 = NP14 + NRVAL + 1
C
      CALL FLWK26(WORK,IUSEW,LEFTW,PERIOD,501)
      CALL FLWK26(WORK,IUSEW,LEFTW,DIFF,501)
      CALL FLWK26(WORK,IUSEW,LEFTW,QMAXI,501)
C
      NP14 = NP14 + 3
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
