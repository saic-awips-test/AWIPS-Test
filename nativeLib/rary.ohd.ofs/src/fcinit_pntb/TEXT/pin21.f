C MEMBER PIN21
C  (from old member FCPIN21)
C
C DESC -- THIS SUBROUTINE READS ALL INPUT CARDS AND FILL THE PO AND CO
C DESC    ARRAYS FOR THE DWOPER OPERATION BY CALLING OTHER SUBROUTINES.
C                             LAST UPDATE: 02/14/94.14:37:49 BY $WC30JL
C
C
C @PROCESS LVL(77)
      SUBROUTINE PIN21(PO,IPO,LEFTP,IUSEP,CO,LEFTC,IUSEC,WORK,LEFTW)
C
C           THIS SUBROUTINE WAS WRITTEN BY:
C           JANICE LEWIS      HRL   NOVEMBER,1982     VERSION NO. 1
C
C       MODIFIED BY JANICE LEWIS  HRL   FEB 1992      VERSION NO. 2
C           RATING CURVES ARE NOW ALLOWED AS INTERNAL BOUNDARIES
C           VIA THE LAD PARAMETER.  A NEGATIVE VALUE ACTIVATES IT.
C
C       MODIFIED BY JANICE LEWIS  HRL   FEB 1994      VERSION NO. 1/2
C           A GAGE ZERO IS NOW ALLOWED FOR TARGET POOL LEVELS
C
C
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON/IONUM/IN,IPR,IPU
C
      DIMENSION PO(*),IPO(*),CO(*),WORK(*),LOC(15),SNAME(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_pntb/RCS/pin21.f,v $
     . $',                                                             '
     .$Id: pin21.f,v 1.3 1997/12/31 18:16:20 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA SNAME/4HPIN2,4H1   /
C
C
      CALL FPRBUG(SNAME,1,21,IBUG)
C
C         CHECK SPACE SPACE IN PO ARRAY
C
      IUSEP=200
      CALL CHECKP(IUSEP,LEFTP,NERR)
      IF(NERR.EQ.1) IUSEP=0
      IF(NERR.EQ.1) GO TO 9000
C
C         INITIALIZE PO ARRAY
C
      DO 5 J=1,LEFTP
    5 PO(J)=0.0
C
      DO 6 J=1,LEFTC
    6 CO(J)=0.0
C
      IF(IBUG.EQ.1) WRITE(IODBUG,10)
   10 FORMAT(1H0,10X,60HDEBUG INPUT SUBROUTINE FOR DWOPER   OPERATION:
     1 CARD IMAGES)
      IF(IBUG.EQ.1) WRITE(IODBUG,20)
   20 FORMAT(1H ,18X,2H10,8X,2H20,8X,2H30,8X,2H40,8X,2H50,8X,2H60,8X,
     1 2H70,8X,2H80)
      IF(IBUG.EQ.1) WRITE(IODBUG,30)
   30 FORMAT(1H ,10X,16(5H----+))
C
C
C          STORE IN PO ARRAY THE FOLLOWING PARAMETERS:
C
C                JN     -- NO. OF RIVERS BEING ROUTED SIMULTANEOUSLY
C                NBMAX  -- MAXIMUM NO. OF STATIONS ON ANY RIVER
C
C
      READ(IN,102) JN,NBMAX
      IF(IBUG.EQ.1) WRITE(IODBUG,1102) JN,NBMAX
  102 FORMAT(9I5)
 1102 FORMAT(1H ,10X,9I5)
C
      PO(25)=JN+0.01
      PO(102)=NBMAX+0.01
C
C
C
C
C            THE FOLLOWING PARAMETERS WILL BE STORED IN THE WORK ARRAY:
C
C                1 --- NCSS1
C                2 --- NRCM1
C                3 --- NRT1
C                4 --- KU
C                5 --- KD
C                6 --- NB
C                7 --- NCSSS
C                8 --- NWJ
C                9 --- NUMLAD
C               10 --- NQL
C               11 --- NNYQ
C               12 --- NJUN
C               13 --- NSTR
C               14 --- NDIV
C               15 --- NQSL
C               16 --- END OF DATA
C
C            DETERMINE AMOUNT OF WORKING SPACE NEEDED
C
      LOC(1)  = 1
      LOC(2)  = LOC(1) + JN
      LOC(3)  = LOC(2) + JN
      LOC(4)  = LOC(3) + JN
      LOC(5)  = LOC(4) + JN
      LOC(6)  = LOC(5) + JN
      LOC(7)  = LOC(6) + JN
      LOC(8)  = LOC(7) + NBMAX*JN
      LOC(9)  = LOC(8) + JN
      LOC(10) = LOC(9) + JN
      LOC(11) = LOC(10)+ JN
      LOC(12) = LOC(11)+ JN
      LOC(13) = LOC(12)+ JN
      LOC(14) = LOC(13)+ JN
      LOC(15) = LOC(14)+ JN
      LOC(16) = LOC(15)+ JN
C
      IF(LOC(16).LE.LEFTW) GO TO 100
      WRITE(IPR,7000) LOC(15),LEFTW
 7000 FORMAT(1H0,10X,61H**ERROR** EXECUTION TERMINATED BECAUSE WORKING S
     1PACE NEEDED (,I5,33H) EXCEEDS WORKING SPACE REQUIRED(,I5,2H).)
      CALL ERROR
      GO TO 9000
C
C         INITIALIZE WORK ARRAY
C
  100 IEOF=LOC(16)
      DO 105 J=1,LEFTW
  105 WORK(J)=0.
C
C          READ DATA INPUT
C
      CALL CARD21(PO,LEFTP,IUSEP,CO,LEFTC,IUSEC,WORK(LOC(1)),
     1 WORK(LOC(2)),WORK(LOC(3)),WORK(LOC(4)),WORK(LOC(5)),
     2 WORK(LOC(6)),WORK(LOC(7)),WORK(LOC(8)),WORK(LOC(9)),
     3 WORK(LOC(10)),WORK(LOC(11)),WORK(LOC(12)),WORK(LOC(13)),
     4 WORK(LOC(14)),WORK(LOC(15)),NBMAX,JN,NSSS)
      IF(IUSEP.EQ.0.OR.IUSEC.EQ.0) GO TO 9000
C
C         FINISH FILLING PO ARRAY WITH CROSS SECTION PROPERTIES
C
      K7 =PO(08)
      K9 =PO(10)
      JNK=PO(26)
      NCS=PO(30)
      NCSS=PO(31)
      LONB=PO(56)
      LONS1=PO(57)
      LONSS=PO(75)
      LOAS =PO(85)
      LOASS=PO(86)
      LOBS =PO(87)
      LOBSS=PO(88)
      LOHS =PO(90)
      LOHSS=PO(91)
C
      CALL CHAN21(PO(LONB),PO(LOAS),PO(LOBS),PO(LOHS),NCS,PO(LOASS),
     1 PO(LOBSS),PO(LOHSS),PO(LONS1),PO(LONSS),NCSS,JN,JNK,K7,K9)
C
      PO(117)=IUSEP
C
      IF(IBUG.NE.1) GO TO 9000
C
      WRITE(IODBUG,300)
      DO 666 J=1,IUSEP,10
      IEND=J+9
      IF(IEND.GT.IUSEP)IEND=IUSEP
      WRITE(IODBUG,200) J,(PO(I),I=J,IEND)
  666 CONTINUE
      WRITE(IODBUG,310)
      DO 667 J=1,IUSEP,10
      IEND=J+9
      IF(IEND.GT.IUSEP)IEND=IUSEP
      WRITE(IODBUG,210) J,(IPO(I),I=J,IEND)
  667 CONTINUE
      WRITE(IODBUG,320)
      DO 668 J=1,IUSEP,20
      IEND=J+19
      IF(IEND.GT.IUSEP)IEND=IUSEP
      WRITE(IODBUG,220) J,(PO(I),I=J,IEND)
  668 CONTINUE
      WRITE(IODBUG,330)
      DO 669 J=1,IUSEC,10
      IEND=J+9
      IF(IEND.GT.IUSEC)IEND=IUSEC
      WRITE(IODBUG,200) J,(CO(I),I=J,IEND)
  669 CONTINUE
  200 FORMAT(1X,I6,4X,F10.2,1X,F10.2,1X,F10.2,1X,F10.2,1X,F10.2,1X,
     1                F10.2,1X,F10.2,1X,F10.2,1X,F10.2,1X,F10.2)
  210 FORMAT(1X,I6,4X,10I11)
  220 FORMAT(1X,I6,4X,A4,1X,A4,1X,A4,1X,A4,1X,A4,1X,A4,1X,A4,1X,A4,1X,
     1                A4,1X,A4,1X,A4,1X,A4,1X,A4,1X,A4,1X,A4,1X,A4,1X,
     2                A4,1X,A4,1X,A4,1X,A4,1X)
  300 FORMAT(//1H ,10X,22HPO ARRAY (REAL VALUES))
  310 FORMAT(//1H ,10X,25HPO ARRAY (INTEGER VALUES))
  320 FORMAT(//1H ,10X,30HPO ARRAY (ALPHANUMERIC VALUES))
  330 FORMAT(//1H ,10X,8HCO ARRAY)
C
 9000 IF(ITRACE.EQ.1) WRITE(IODBUG,9010) SNAME
 9010 FORMAT(1H0,2H**,1X,2A4,8H EXITED.)
      RETURN
      END