C MEMBER PIN50
C  (from old member FCPIN50)
C
C @PROCESS LVL(77)
      SUBROUTINE PIN50( P, MP, PO, LEFTP, IUSEP )
C                             LAST UPDATE: 04/25/95.13:32:45 BY $WC20SV
C
C
C    THIS IS THE INPUT ROUTINE FOR THE ASSIMILATOR OPERATION.
C    THIS ROUTINE INPUTS ALL CARDS FOR THE OPERATION AND FILLS
C    THE PO ARRAY.
C
C    ROUTINE INITIALLY WRITTEN BY
C    ERIC MARKSTROM, RIVERSIDE TECHNOLOGY, INC. DECEMBER 1994 VERSION 1
C

C    CONTENTS OF THE PO ARRAY -
C
C
C POSITION  NAME        DESCRIPTION
C    1      IVER        VERSION NUMBER
C   2-6     GINFO       GENERAL INFORMATION
C   7-8     ASSMID      ASSIMILATOR I.D.

C    9      NBASINS     NUMBER OF SUBAREAS WITHIN BASIN
C    10     NDQ_PER_PRD NUMBER OF DAYS PER DISCHARGE INTERVAL
C    11     NDP_PER_PRD NUMBER OF DAYS PER PRECIPITATION INTERVAL

C    12     WQ          WEIGHT COEFFICIENT FOR DISCHARGE
C    13     WP          WEIGHT COEFFICIENT FOR PRECIPITATION
C    14     WS          WEIGHT COEFFICIENT FOR STATES

C  15-16    QOID        OBSERVED DISCHARGE TIME SERIES I.D.
C    17     QODT        OBSERVED DISCHARGE DATA TYPE

C  18-19    QSID        SIMULATED DISCHARGE TIME SERIES I.D.
C    20     QSDT        SIMULATED DISCHARGE DATA TYPE

C    21     MOPT        MAX NUMBER OF ITERATIONS FOR OPTIMIZER
C    22     DELTF       DELTA VALUE FOR OPTIMIZER
C    23     VALUEF      MINIMUM CRITERIA VALUE FOR OPTIMIZER

C    24     P_OPTY      POINTER TO A LIST OF RAINFALL/RUNOFF
C                       OPERATION TYPES
C    25     P_OPID      POINTER TO A LIST OF RAINFALL/RUNOFF
C                       OPERATION ID'S
C    26     P_RRPO      POINTER TO A LIST OF PO ARRAYS
C                       FOR RAINFALL/RUNOFF MODELS
C    27     P_RRCO      POINTER TO A LIST OF CO ARRAYS
C                       FOR RAINFALL/RUNOFF MODELS

C    28     P_KPID      POINTER TO A LIST OF KP TS ID'S

C    29     P_WP_B      POINTER TO A LIST OF BASIN WEIGHTS
C                       FOR PRECIPITATION
C    30     P_WS_B      POINTER TO A LIST OF BASIN WEIGHTS FOR STATES

C    31     P_KPMIN     POINTER TO A LIST OF LOWER BOUNDARYS FOR KP
C    32     P_KPMAX     POINTER TO A LIST OF UPPER BOUNDARYS FOR KP

C    33     P_ST_OP     POINTER TO A LIST OF STATE OPTIONS

C    34     P_KSMIN     POINTER TO A LIST OF LOWER BOUNDARYS FOR KS
C                       (DEPENDS ON STATE OPTIONS)
C    35     P_KSMAX     POINTER TO A LIST OF UPPER BOUNDARYS FOR KS
C                       (DEPENDS ON STATE OPTIONS)

C    36     P_STNF      POINTER TO A LIST OF ON/OFF SWITCHES FOR STATES
C                       (DEPENDS ON STATE OPTIONS)

C  37-40                RESERVED FOR FUTURE USE

C    PASSED ARGUMENTS
      INTEGER MP, LEFTP, IUSEP
      DIMENSION P(MP), PO(*)

C    COMMON BLOCKS
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/where'
      INCLUDE 'common/fclfls'

C    LOCAL VARIABLES
      PARAMETER (ARRLN=40)
      DIMENSION GINFO(5), ASSMID(2), QOID(2), QSID(2),
     1 ROPTY(2,10), ROPID(2,10), RKPID(2,10), WP_B(10), WS_B(10),
     2 RKPMIN(10), RKPMAX(10), IST_OP(10), RKSMIN(1,10), RKSMAX(1,10),
     3 ISTNF(6,10), IDSEG(2), SNAME(2), ANAME(2),BLANK(2)

C dws    Var PCNT was made an integer, avoids warnings ... 2006-01-23

      INTEGER PCNT
      INTEGER NBASINS, NDQ_PER_PRD, NDP_PER_PRD, MOPT, ISTATES,
     1 IUSEPTMP, I_0, I_1, I_24, IFOO1, IFOO2, IERR, IMISS, IPIN50
      REAL*4 ARRAY(100)
      REAL WQ, WP, WS, QODT, QSDT, DELTF, VALUEF, FOO1, FOO2, FOO3,
     1 RKPDT, ASSM
      DATA ANAME /4HASSI,4HM   /
      DATA SNAME /4HPIN5,4H0   /
      DATA RKPDT /4HKP  /
      DATA ASSM /4HASSM/

      EQUIVALENCE (ARRAY(4), IDSEG(1))
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_pntb/RCS/pin50.f,v $
     . $',                                                             '
     .$Id: pin50.f,v 1.2 2006/03/16 16:34:55 xfan Exp $
     . $' /
C    ===================================================================
C

CCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC  DEBUG INITIALIZATION
C
      CALL FOPCDE(ANAME,IPIN50)
      CALL FPRBUG( SNAME, 1, IPIN50, IBUG )

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC  READ DATA FROM INPUT CARDS
C
C    READ CARD 1
      READ (IN, 801) GINFO, ASSMID, NBASINS, NDQ_PER_PRD,
     1 NDP_PER_PRD, WQ, WP, WS

C    READ CARD 2
      READ (IN, 802) QOID, QODT, QSID, QSDT,
     1 MOPT, DELTF, VALUEF

C    READ CARDS 3, 4, ..., 2 + (NBASINS * 2)
      DO I = 1, NBASINS
           READ (IN, 803) ROPTY(1,I), ROPTY(2,I), ROPID(1,I),
     1 ROPID(2,I), RKPID(1,I), RKPID(2,I), WP_B(I), WS_B(I),
     2 RKPMIN(I), RKPMAX(I), IST_OP(I)

C         READ THE NEXT CARD IN A MANNER DEPENDING ON THE STATE OPTION

C         STATE OPTION #1 - SAC-SMA
            IF (IST_OP(I).EQ.1) THEN
               READ(IN, 804) RKSMIN(1,I), RKSMAX(1,I),
     1 ISTNF(1,I), ISTNF(2,I), ISTNF(3,I), ISTNF(4,I),
     2 ISTNF(5,I), ISTNF(6,I)

            ELSE
               WRITE(IPR, 901)
  901          FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 40HAN INVALID STATE OPTION HAS BEEN ENTERED )
               CALL ERROR
               RETURN
           END IF
      END DO


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC  CHECK VALIDITY OF PARAMETERS AND TIME SERIES FILES
C
C    FIRST CHECK TO ENSURE THAT THERE IS ENOUGH SPACE IN P
C    IUSEP WILL STORE THE 40 VALUES AS DEFINED IN THE COMMENT
C    SECTION PLUS 11 ELEMENTS FOR EACH SUBBASIN PLUS
C    IF STATE OPTION = 1
C       8 ELEMENTS FOR EACH SUBBASIN
      ISTATES = 0
      DO I = 1, NBASINS
          IF (IST_OP(I).EQ.1) THEN
             ISTATES =  ISTATES + 8
          END IF
      END DO
      IUSEP = 0
      IUSEPTMP = ARRLN + NBASINS * 13 + ISTATES
      CALL CHECKP( IUSEPTMP, LEFTP, IERR )
      IF (IERR.GE.1) THEN
          WRITE( IPR, 902 )
  902     FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 50HTHERE IS NOT ENOUGH SPACE AVAILABLE IN THE P ARRAY )
          CALL ERROR
          RETURN
      END IF

C    CHECK NBASINS INFO - MAXIMUM OF 10 BASINS
      IF ((NBASINS.LE.0).OR.(NBASINS.GT.10)) THEN
         WRITE( IPR, 903 )
  903    FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 42HINFORMATION REGARDING THE NUMBER OF BASINS,
     2 10HIS INVALID )
         CALL ERROR
         RETURN
      END IF

C    CHECK NDQ_PER_PRD INFO
      IF ((NDQ_PER_PRD.LE.0).OR.(NDQ_PER_PRD.GT.31)) THEN
         WRITE( IPR, 904 )
  904    FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 40HINFORMATION REGARDING THE NUMBER OF DAYS,
     2 26HPER FLOW PERIOD IS INVALID )
         CALL ERROR
         RETURN
      END IF

C    CHECK NDP_PER_PRD INFO
      IF ((NDP_PER_PRD.LE.0).OR.(NDP_PER_PRD.GT.31)) THEN
          WRITE( IPR, 905 )
  905     FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 40HINFORMATION REGARDING THE NUMBER OF DAYS,
     2 35HPER PRECIPITATION PERIOD IS INVALID )
          CALL ERROR
          RETURN
      END IF

C    CHECK WQ INFO
      IF (WQ.LT.0.0) THEN
          WRITE( IPR, 906 )
  906     FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 39HINFORMATION REGARDING THE WEIGHT OF THE,
     2 25HDISCHARGE TERM IS INVALID )
          CALL ERROR
          RETURN
      END IF

C    CHECK WP INFO
      IF (WP.LE.0.0) THEN
          WRITE( IPR, 907 )
  907     FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 39HINFORMATION REGARDING THE WEIGHT OF THE,
     2 29HPRECIPITATION TERM IS INVALID )
          CALL ERROR
          RETURN
      END IF

C    CHECK WS INFO
      IF (WS.LE.0.0) THEN
          WRITE( IPR, 908 )
  908     FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 39HINFORMATION REGARDING THE WEIGHT OF THE,
     2 22HSTATES TERM IS INVALID )
          CALL ERROR
          RETURN
      END IF

C    CHECK OBSERVED TS FILE
      I_0  =  0
      I_1  =  1
      I_24 = 24
      IMISS = 1
      CALL CHEKTS ( QOID, QODT, I_24, I_0, FOO, IMISS, I_1, IERR )
      IF (IERR.GE.1) THEN
           WRITE( IPR, 909 )
  909      FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 48HTHERE IS AN ERROR WITH THE OBSERVED DISCHARGE TS )
           CALL ERROR
           RETURN
      END IF

C    CHECK SIMULATED TS FILE
      I_0  =  0
      I_1  =  1
      I_24 = 24
      IMISS = 0
      CALL CHEKTS ( QSID, QSDT, I_24, I_0, FOO, IMISS, I_1, IERR )
      IF (IERR.GE.1) THEN
           WRITE( IPR, 910 )
  910      FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 49HTHERE IS AN ERROR WITH THE SIMULATED DISCHARGE TS )
           CALL ERROR
           RETURN
      END IF

C    CHECK MOPT INFO
      IF (MOPT.LT.0.0) THEN
          WRITE( IPR, 911 )
  911     FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 40HINFORMATION CONCERNING MOPT IS INCORRECT )
          CALL ERROR
          RETURN
      END IF

C    CHECK DELTF INFO
      IF (DELTF.LE.0.0) THEN
          WRITE( IPR, 912 )
  912     FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 41HINFORMATION CONCERNING DELTF IS INCORRECT )
          CALL ERROR
          RETURN
      END IF

C    CHECK VALUEF INFO
      IF (VALUEF.LE.0.0) THEN
          WRITE( IPR, 913 )
  913     FORMAT( 1H0, 10X, 10H**ERROR** ,
     142HINFORMATION CONCERNING VALUEF IS INCORRECT )
          CALL ERROR
          RETURN
      END IF

C    CHECK RAINFALL/RUNOFF OPERATIONS
C    ONE FOR EACH SUBBASIN

      DO I = 1, NBASINS
           POS = 0
          CALL FOPCDE( ROPTY(1,I), IOPNUM )

C         OPERATION DOES NOT EXIST
          IF (IOPNUM.EQ.0) THEN
              WRITE( IPR, 914 )
  914         FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 35HRAINFALL/RUNOFF OPERATION NOT FOUND )
              CALL ERROR
              RETURN
          END IF

           CALL FSERCH( IOPNUM, ROPID(1,I), POS, P, MP )
          IF (POS.EQ.0) THEN
              WRITE( IPR, 915 )
  915         FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 38HINVALID RAINFALL/RUNOFF OPERATION TYPE )
              CALL ERROR
              RETURN
           END IF
      END DO

C    CHECK KP TS FILES
      DO I = 1, NBASINS
         I_0 = 0
         I_1 = 1
         I_24 = 24
         IMISS = 1
         CALL CHEKTS ( RKPID(1,I), RKPDT, I_24, I_0, FOO,
     1 IMISS, I_1, IERR )
         IF (IERR.GE.1) THEN
             WRITE( IPR, 916 )
  916        FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 41HTHERE IS A PROBLEM WITH THE KP TIMESERIES )
             CALL ERROR
             RETURN
         END IF
      END DO


C    CHECK WEIGHTS OF PRECIP FOR EACH BASIN
      DO I = 1, NBASINS
        IF (WP_B(I).LT.0) THEN
           WRITE( IPR, 917 )
  917      FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 44HTHERE IS AN ERROR IN A WEIGHT FROM THE BASIN,
     2 13HPRECIPITATION )
           CALL ERROR
           RETURN
        END IF
      END DO


C    CHECK WEIGHTS OF STATES FOR EACH BASIN
      DO I = 1, NBASINS
         IF (WS_B(I).LT.0) THEN
            WRITE( IPR, 918 )
  918       FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 44HTHERE IS AN ERROR IN A WEIGHT FROM THE BASIN,
     2 6HSTATES )
            CALL ERROR
            RETURN
         END IF
      END DO


C    CHECK MIN AND MAX VALUES FOR EACH VALUE OF KP
      DO I = 1, NBASINS
         IF ((RKPMIN(I).LT.0).OR.(
     1 RKPMIN(I).GT.RKPMAX(I))) THEN
           WRITE( IPR, 919 )
  919      FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 49HTHERE IS AN ERROR WITH A KP MINIMUM OR KP MAXIMUM,
     2 5HVALUE )
           CALL ERROR
           RETURN
         END IF
      END DO

C    CHECK TO SEE PREPROCESSOR DATA BASE FOR KS
C    IF THE ASSMID EXISTS BUT IS NOT THE SAME SEGMENT
C    THEN GENERATE ERROR
      IPTR = 0
      LARRAY = 100
      CALL RPPREC( ASSMID, ASSM, IPTR, LARRAY, ARRAY,
     1 NFILL, IPTRNX, ISTAT )

      IF ((ISTAT.EQ.0).AND.((       !!! FOUND IT
     1 IDSEG(1).NE.ISEG(1)).OR.(
     2 IDSEG(2).NE.ISEG(2)))) THEN
          WRITE( IPR, 920 )
  920     FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 49HKS-RECORD: ASSIMILATOR OPERATION ID FOUND BUT NOT,
     2 25HCORRECTLY DEFINED SEGMENT )
           CALL ERROR
           RETURN
      ELSE
           IPTR = 0
           LARRAY = 18
           DO I = 1, NBASINS
             IF (IST_OP(I).EQ.1) THEN
                LARRAY = LARRAY + 1
             END IF
          END DO
          ARRAY(2) = ASSMID(1)
          ARRAY(3) = ASSMID(2)
          IDSEG(1) = ISEG(1)
          IDSEG(2) = ISEG(2)
          ARRAY(6) = 0.0
          ARRAY(7) = 0.0
          ARRAY(8) = 0.0
          ARRAY(9) = 0.0
          ARRAY(10) = 0.0
          ARRAY(11) = 0.0
          ARRAY(12) = 0.0
          ARRAY(13) = 0.0
          ARRAY(14) = 0.0
          ARRAY(15) = 0.0
          ARRAY(16) = 0.0
          ARRAY(17) = 0.0
          ARRAY(18) = -999.0
  102   FORMAT(1X, 5HARRAY, 2X, 2A4 )

          CALL WPPREC(ASSMID, ASSM, LARRAY, ARRAY,
     1 IPTR, ISTAT )
          IF (ISTAT.NE.0) THEN
             WRITE(IPR, 921)
  921        FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 38HTHERE WAS AN ERROR WRITING A KS RECORD )
             CALL ERROR
             RETURN
          END IF
          IWRPPP = 1

      END IF





C    CHECK MIN AND MAX VALUES FOR EACH VALUE OF KS
C    CHECK ON/OFF SWITCHES FOR STATE OPTIONS
      DO I = 1, NBASINS
C         CHECK SWITCHES FOR OPTION 1
C         SAC-SMA SIX PARAMTER MULTIPLIER
           IF (IST_OP(I).EQ.1) THEN

C             KS VALUES
               IF ((RKSMIN(1,I).LT.0).OR.(
     1 RKSMIN(1,I).GT.RKSMAX(1,I))) THEN
                  WRITE( IPR, 922 )
  922             FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 48HTHERE IS A ERROR WITH A KS MINIMUM OR KS MAXIMUM,
     2 5HVALUE )
                  CALL ERROR
                  RETURN
               END IF
C             ON/OFF MULTIPLIERS
               DO J = 1, 6
                    IF ((ISTNF(J,I).NE.0).AND.(
     1 ISTNF(J,I).NE.1)) THEN
                       WRITE( IPR, 923 )
  923                  FORMAT( 1H0, 10X, 10H**ERROR** ,
     1 48HTHERE IS AN ERROR ONE OF THE STATE ON/OFF VALUES )
                       CALL ERROR
                       RETURN
                    END IF
                END DO
           END IF
       END DO



CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    STORE INFORMATION IN PO ARRAY
C
      IVER = 1
      PO(1)    = IVER + 0.01
      PO(2)    = GINFO(1)
      PO(3)    = GINFO(2)
      PO(4)    = GINFO(3)
      PO(5)    = GINFO(4)
      PO(6)    = GINFO(5)
      PO(7)    = ASSMID(1)
      PO(8)    = ASSMID(2)
      PO(9)    = NBASINS + 0.01
      PO(10)   = NDQ_PER_PRD + 0.01
      PO(11)   = NDP_PER_PRD + 0.01
      PO(12)   = WQ
      PO(13)   = WP
      PO(14)   = WS
      PO(15)   = QOID(1)
      PO(16)   = QOID(2)
      PO(17)   = QODT
      PO(18)   = QSID(1)
      PO(19)   = QSID(2)
      PO(20)   = QSDT
      PO(21)   = MOPT + 0.01
      PO(22)   = DELTF
      PO(23)   = VALUEF

      PO(37) =        0.01
      PO(38) =        0.01
      PO(39) =        0.01
      PO(40) =        0.01

      PCNT = ARRLN
      PCNT = PCNT + 1
C    LIST OF RAINFALL/RUNOFF OPERATION TYPES
      P_OPTY = PCNT
      PO(24) =  P_OPTY + 0.01

      DO I = 1, NBASINS
          PO(PCNT) = ROPTY(1,I)
          PCNT = PCNT + 1
          PO(PCNT) =  ROPTY(2,I)
          PCNT = PCNT + 1
      END DO

C    LIST OF RAINFALL/RUNOFF OPERATION ID'S
      P_OPID = PCNT
      PO(25) = P_OPID + 0.01
      DO I = 1, NBASINS
          PO(PCNT) = ROPID(1,I)
          PCNT = PCNT + 1
          PO(PCNT)    = ROPID(2,I)
          PCNT = PCNT + 1
      END DO

C    LIST OF PO ARRAYS FOR RAINFALL/RUNNOFF MODELS
      P_RRPO = PCNT
      PO(26) = P_RRPO + 0.01
      I_0 = 0
      DO I = 1, NBASINS
          CALL FOPCDE(ROPTY(1,I),ICDE)
          CALL FSERCH( ICDE, ROPID(1,I), I_0, P, MP )
          PO(PCNT) = I_0 + 0.01
          PCNT = PCNT + 1
      END DO

C    LIST OF CO ARRAYS FOR RAINFALL/RUNNOFF MODELS
      P_RRCO = PCNT
      PO(27) = P_RRCO + 0.01
      I_0 = 0
      DO I = 1, NBASINS
          CALL FOPCDE(ROPTY(1,I),ICDE)
          CALL FSERCH( ICDE, ROPID(1,I), I_0, P, MP )
          PO(PCNT) = I_0 - 1 + 0.01
          PCNT = PCNT + 1
      END DO

C    LIST OF KP TS ID'S
      P_KPID = PCNT
      PO(28) =        P_KPID + 0.01
      DO I = 1, NBASINS
          PO(PCNT) = RKPID(1,I)
          PCNT = PCNT + 1
          PO(PCNT) = RKPID(2,I)
          PCNT = PCNT + 1
      END DO

C    LIST OF PRECIPITATION WEIGHTS FOR BASINS
      P_WP_B = PCNT
      PO(29) = P_WP_B + 0.01
      DO I = 1, NBASINS
          PO(PCNT) = WP_B(I)
          PCNT = PCNT + 1
      END DO

C    LIST OF STATE WEIGHTS FOR BASINS
      P_WS_B = PCNT
      PO(30) = P_WS_B + 0.01
      DO I = 1, NBASINS
          PO(PCNT) = WS_B(I)
          PCNT = PCNT + 1
      END DO

C    LIST OF MINIMUM KP VALUES FOR THE BASINS
      P_KPMIN = PCNT
      PO(31) = P_KPMIN + 0.01
      DO I = 1, NBASINS
          PO(PCNT) = RKPMIN(I)
          PCNT = PCNT + 1
      END DO

C    LIST OF MAXIMUM KP VALUES FOR THE BASINS
      P_KPMAX = PCNT
      PO(32) = P_KPMAX + 0.01
      DO I = 1, NBASINS
          PO(PCNT) = RKPMAX(I)
          PCNT = PCNT + 1
      END DO

C    LIST OF STATE OPTIONS FOR THE BASINS
      P_ST_OP = PCNT
      PO(33) = P_ST_OP + 0.01
      DO I = 1, NBASINS
          PO(PCNT) = IST_OP(I)
          PCNT = PCNT + 1
      END DO

C    LIST OF MINIMUM KS VALUES FOR THE BASINS
C    IS DEPENDENT ON THE STATE OPTION
      P_KSMIN = PCNT
      PO(34) = P_KSMIN + 0.01
      DO I = 1, NBASINS
          IF (IST_OP(I).EQ.1) THEN
             PO(PCNT) = RKSMIN(1,I)
             PCNT = PCNT + 1
          END IF
      END DO

C    LIST OF MAXIMUM KS VALUES FOR THE BASINS
C    IS DEPENDENT ON THE STATE OPTION
      P_KSMAX = PCNT
      PO(35) = P_KSMAX + 0.01
      DO I = 1, NBASINS
          IF (IST_OP(I).EQ.1) THEN
             PO(PCNT) = RKSMAX(1,I)
             PCNT = PCNT + 1
          END IF
      END DO

C    LIST OF ON/OFF SWITCHES FOR STATES
C    IS DEPENDENT ON THE STATE OPTION
      P_STNF =  PCNT
      PO(36) = P_STNF + 0.01
      DO I = 1, NBASINS
          IF (IST_OP(I).EQ.1) THEN
              DO J = 1, 6
                PO(PCNT) = ISTNF(J,I)
                PCNT = PCNT + 1
              END DO
          END IF
      END DO


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    RETURN CORRECT PARAMETERS
C
      IUSEP = IUSEPTMP


CCCCCCCCCCCCCCCCCC
C    DEBUG OUTPUT

      IF (IBUG.GE.1) THEN
          WRITE(IODBUG, *) 'ASSIM CARD INFO'
          WRITE(IODBUG, *) 'CARD NUMBER 1'
          WRITE (IODBUG, 801) GINFO, ASSMID, NBASINS, NDQ_PER_PRD,
     1 NDP_PER_PRD, WQ, WP, WS
          WRITE(IODBUG, *)
      END IF

      IF (IBUG.GE.1) THEN
          WRITE(IODBUG, *) 'CARD NUMBER 2'
          WRITE (IODBUG, 802) QOID, QODT, QSID, QSDT,
     1 MOPT, DELTF, VALUEF
          WRITE(IODBUG, *)
      END IF

      IF (IBUG.GE.1) THEN
        WRITE(IODBUG, *) 'VARIABLE CARD INFO'
        DO I = 1, NBASINS
           WRITE(IODBUG, 803) ROPTY(1,I), ROPTY(2,I), ROPID(1,I),
     1  ROPID(2,I), RKPID(1,I), RKPID(2,I), WP_B(I), WS_B(I),
     2  RKPMIN(I), RKPMAX(I), IST_OP(I)

C         READ THE NEXT CARD IN A MANNER DEPENDING ON THE STATE OPTION
C         SAC-SMA, FIRST OPTION
           IF (IST_OP(I).EQ.1) THEN
                WRITE(IODBUG, 804) RKSMIN(1,I), RKSMAX(1,I),
     1  ISTNF(1,I), ISTNF(2,I), ISTNF(3,I),
     2  ISTNF(4,I), ISTNF(5,I), ISTNF(6,I)
           END IF

       END DO

      END IF


  801 FORMAT ( 5A4, 2X, 2A4, 1X, I2, 2X, I2, 1X, I2,
     1 3X, F4.2, 1X, F4.2, 1X, F4.2 )
  802 FORMAT ( 2A4, 1X, A4, 9X, 2A4, 1X, A4, 1X, I4,
     1 1X, F8.6, 1X, F6.4 )
  803 FORMAT ( A4, A4, 1X, A4, A4, 1X, A4, A4, 1X, F4.2,
     1  1X, F4.2, 1X, F4.2, 1X, F4.2, 1X, I2 )
  804 FORMAT ( F4.2, 1X, F4.2, 1X, I1, 1X, I1, 1X,
     1 I1, 1X, I1, 1X, I1, 1X, I1 )


      RETURN

      END
