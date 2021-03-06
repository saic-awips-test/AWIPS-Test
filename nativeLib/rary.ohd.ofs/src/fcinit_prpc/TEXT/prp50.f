C MEMBER PRP50
C  (from old member FCPRP50)
C @PROCESS LVL(77)
       SUBROUTINE PRP50(PO)
C                             LAST UPDATE: 04/25/95.13:33:00 BY $WC20SV
C
C
C    THIS IS THE PRINT PARAMETER ROUTINE FOR THE ASSIMILATOR
C    OPERATION.  THIS ROUTINE OUTPUTS ALL VALUES IN THE PO ARRAY
C    IN A NEAT AND CONCISE MANNER.
C
C    ROUTINE INITIALLY WRITTEN BY
C    ERIC MARKSTROM, RIVERSIDE TECHNOLOGY, INC. DECEMBER 1994 VERSION 1

C    CONTENTS OF THE PO ARRAY -
C
C
C POSITION   NAME        DESCRIPTION
C    1       IVER        VERSION NUMBER
C   2-6      GINFO       GENERAL INFORMATION
C   7-8      ASSMID      ASSIMILATOR I.D.

C    9       NBASINS     NUMBER OF SUBAREAS WITHIN BASIN
C    10      NDQ_PER_PRD NUMBER OF DAYS PER DISCHARGE INTERVAL
C    11      NDP_PER_PRD NUMBER OF DAYS PER PRECIP INTERVAL

C    12      WQ          WEIGHT COEFFICIENT FOR DISCHARGE
C    13      WP          WEIGHT COEFFICIENT FOR PRECIPITATION
C    14      WS          WEIGHT COEFFICIENT FOR STATES

C  15-16     QOID        OBSERVED DISCHARGE TIME SERIES I.D.
C    17      QODT        OBSERVED DISCHARGE DATA TYPE

C  18-19     QSID        SIMULATED DISCHARGE TIME SERIES I.D.
C    20      QSDT        SIMULATED DISCHARGE DATA TYPE

C    21      MOPT        MAX NUMBER OF ITERATIONS FOR OPTIMIZER
C    22      DELTF       DELTA VALUE FOR OPTIMIZER
C    23      VALUEF      MINIMUM CRITERIA VALUE FOR OPTIMIZER

C    24      P_OPTY      POINTER TO A LIST OF RAINFALL/RUNOFF
C                        OPERATION TYPES
C    25      P_OPID      POINTER TO A LIST OF RAINFALL/RUNOFF
C                        OPERATION ID'S
C    26      P_RRPO      POINTER TO A LIST OF PO ARRAYS FOR
C                        RAINFALL/RUNOFF MODELS
C    27      P_RRCO      POINTER TO A LIST OF CO ARRAYS FOR
C                        RAINFALL/RUNOFF MODELS

C    28      P_KPID      POINTER TO A LIST OF KP TS ID'S

C    29      P_WP_B      POINTER TO A LIST OF BASIN WEIGHTS
C                        FOR PRECIPITATION
C    30      P_WS_B      POINTER TO A LIST OF BASIN WEIGHTS
C                        FOR STATES

C    31      P_KPMIN     POINTER TO A LIST OF LOWER
C                        BOUNDARYS FOR KP
C    32      P_KPMAX     POINTER TO A LIST OF UPPER
C                        BOUNDARYS FOR KP

C    33      P_ST_OP     POINTER TO A LIST OF STATE OPTIONS

C    34      P_KSMIN     POINTER TO A LIST OF LOWER BOUNDARYS
C                        FOR KS(DEPENDS ON STATE OPTIONS)
C    35      P_KSMAX     POINTER TO A LIST OF UPPER BOUNDARYS
C                        FOR KS(DEPENDS ON STATE OPTIONS)

C    36      P_STNF      POINTER TO A LIST OF ON/OFF SWITCHES
C                        FOR STATES(DEPENDS ON STATE OPTIONS)

C   37-40                RESERVED FOR FUTURE USE



      DIMENSION PO(*)
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'

      DIMENSION ROPTY(2), ROPID(2), RKPID(2), ISTNF(6), SNAME(2),
     1 ANAME(2)
      INTEGER IPRP50
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_prpc/RCS/prp50.f,v $
     . $',                                                             '
     .$Id: prp50.f,v 1.1 1995/09/17 18:50:24 dws Exp $
     . $' /
C    ===================================================================
C
      DATA  SNAME /4HPRP5,4H0   /
      DATA ANAME /4HASSI,4HM   /

CCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC  DEBUG INITIALIZATION
C
      CALL FOPCDE(ANAME,IPRP50)
      CALL FPRBUG( SNAME, 1, IPRP50, IBUG )


C    PRINT HEADER INFORMATION AND ASSIM I.D.
      WRITE(IPR, 801) PO(2), PO(3), PO(4), PO(5), PO(6), PO(7), PO(8)

C    PRINT NUMBER OF BASINS, AVERAGING TIME INTERVAL IN DAYS FOR
C    PRECIPITATION AND DISCHARGE
      WRITE(IPR, 802) INT(PO(9)), INT(PO(10)), INT(PO(11))

C    PRINT OPTIMIZATION PARAMETERS
      WRITE(IPR, 803) INT(PO(21)), PO(22), PO(23)

C    PRINT OBJECTIVE VALUE WEIGHTS
      WRITE(IPR, 804) PO(12), PO(13), PO(14)

C    PRINT INFORMATION CONCERNING OUTLET TIME SERIES
      WRITE(IPR, 805) PO(15), PO(16), PO(17), PO(18),
     1 PO(19), PO(20)

C    PRINT TABLE OF SUB-AREA INFORMATION
      WRITE(IPR, 806)
      WRITE(IPR, 807)
      WRITE(IPR, 808)

      DO I = 1, INT(PO(9))
          ROPTY(1) =  PO(INT(PO(24))+(I-1)*2)
          ROPTY(2) =  PO(INT(PO(24))+(I-1)*2+1)
          ROPID(1) =  PO(INT(PO(25))+(I-1)*2)
          ROPID(2) =  PO(INT(PO(25))+(I-1)*2+1)
          RKPID(1) =  PO(INT(PO(28))+(I-1)*2)
          RKPID(2) =  PO(INT(PO(28))+(I-1)*2+1)
          WP_B     =  PO(INT(PO(29))+(I-1))
          WS_B     =  PO(INT(PO(30))+(I-1))
          RKPMIN   =   PO(INT(PO(31))+(I-1))
          RKPMAX   =   PO(INT(PO(32))+(I-1))
          IST_OP   =  INT(PO(INT(PO(33))+(I-1)))

          IF (IST_OP.EQ.1) THEN   !!! SAC-SMA OPTION 1
               RKSMIN =  PO(INT(PO(34))+(I-1))
               RKSMAX =  PO(INT(PO(35))+(I-1))
               ISTNF(1) = INT(PO(INT(PO(36))+(I-1)*6))
               ISTNF(2) = INT(PO(INT(PO(36))+(I-1)*6+1))
               ISTNF(3) = INT(PO(INT(PO(36))+(I-1)*6+2))
               ISTNF(4) = INT(PO(INT(PO(36))+(I-1)*6+3))
               ISTNF(5) = INT(PO(INT(PO(36))+(I-1)*6+4))
               ISTNF(6) = INT(PO(INT(PO(36))+(I-1)*6+5))
               WRITE(IPR, 809) I, ROPTY, ROPID, RKPID, WP_B,
     1 WS_B, IST_OP, RKPMIN, RKPMAX, RKSMIN, RKSMAX, ISTNF(1),
     2 ISTNF(2), ISTNF(3), ISTNF(4), ISTNF(5), ISTNF(6)
           END IF

      END DO


  801 FORMAT ( 10X, 27HASSIMILATION OPERATION INFO, 20X,
     1 26HASSIMILATOR OPERATION I.D., /,10X, A4, A4, A4, A4, A4, 32X,
     2 A4, A4, /  )

  802 FORMAT ( 50X,  31HAVERAGING TIME INTERVAL IN DAYS, /,
     1 10X, 20HNUMBER OF SUB-BASINS, 20X, 9HDISCHARGE, 9X,
     2 13HPRECIPITATION, /, 20X, I2, 31X, I2, 18X, I2, / )

  803 FORMAT ( 10X, 21HOPTIMATION PARAMETERS, /,
     1 15X, 24HMAX NUMBER OF ITERATIONS, 5X,
     2 11HDELTA VALUE, 5X,
     3 22HMINIMUM CRITERIA VALUE, /,
     4 30X, I4, 13X, F8.6, 13X, F6.4, /)

  804 FORMAT ( 10X, 35HWEIGHTS OF OPTIMIZATION MULTIPLIERS, /,
     1 15X, 9HDISCHARGE,
     2 10X, 15HSTATE VARIABLES,
     3 10X, 13HPRECIPITATION, /,
     4 17X, F4.2, 18X, F4.2, 20X, F4.2, / )

  805 FORMAT ( 10X, 21HDISCHARGE TIME SERIES, /, 10X,
     4 10X, 8HOBSERVED,
     5 16X, 9HSIMULATED, /,
     3 20X, 14HTS ID     TYPE, 10X, 14HTS ID     TYPE, /,
     3 20X, A4, A4, 2X, A4, 10X, A4, A4, 2X, A4,/ )

  806 FORMAT ( 12X, 21H| RAINFALL/RUNOFF   |, 10X,
     1 19H|  BASIN WEIGHTS  |, 9H STATE  |,
     2 7H KP   |,7H KP   |,7H KS   |,7H KS   | )

  807 FORMAT (10X,3H #|,5H OPER,5X,5HTS ID,4X,12H| KP TS ID |,
     1 18H PRECIP | STATES |,9H OPTION |,
     2 7H MIN  |, 7H MAX  |, 7H MIN  |, 7H MAX  |,
     3 23H STATES ON/OFF SWITCHES )

  808 FORMAT ( 10X, 40H----------------------------------------,
     2 50H--------------------------------------------------,
     3 30H------------------------------ )

  809 FORMAT( 10X, I2,'| ',2A4, 1X, 2A4,' | ',2A4, ' | ', F4.2, 5X,
     1 F4.2, 3X, '|', 3X, I1, 4X, '| ', F4.2, ' | ', F4.2, ' | ',
     2 F4.2, ' | ', F4.2, ' | ', I1, 1X, I1, 1X, I1, 1X, I1, 1X, I1,
     3 1X, I1 )

      END
