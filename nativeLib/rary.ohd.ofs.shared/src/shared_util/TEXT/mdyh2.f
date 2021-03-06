C MODULE MDYH2
C-----------------------------------------------------------------------
C  ROUTINE MDYH1 AND ENTRY MDYH2 CONVERT FROM THE INTERNAL CLOCK TIME
C          TO MONTH, DAY, YEAR, AND HOUR FOR A SPECIFIED TIME ZONE
C
C  FOR MDYH1 THE TIME ZONE IS SPECIFIED BY ITZ AND IDSAV
C  FOR MDYH2 HAS CODE INPUT, NEEDS ITZ AND IDSAV OUTPUT
C
C  FOR MDYH2 THE TIME ZONE IS SPECIFIED BY CODE
C
C     ARGUMENT  IN/OUT  DESCRIPTION
C     --------  ------  ------------------------------------------------
C     JDAY       IN     JULIAN DAY (01JAN1900=1)
C     INTHR      IN     INTERNAL CLOCK HOUR
C     M          OUT    MONTH
C     D          OUT    DAY
C     Y          OUT    YEAR (4 DIGIT)
C     H          OUT    HOUR (1-24)
C     ITZ               TIME ZONE NUMBER.  IN FOR MDYH1,
C                                          OUT FOR MDYH2
C     IDSAV             DAYLIGHT SAVING SWITCH.
C                       IDSAV=1 FOR DAYLIGHT SAVINGS TIME (ANY
C                       OTHER VALUE IGNORED).  IN FOR MDYH1,
C                       OUT FOR MDYH2.
C     CODE              FOUR CHARACTER TIME ZONE CODE.
C                       IN FOR MDYH2, OUT FOR MDYH1.
C-----------------------------------------------------------------------
      SUBROUTINE MDYH2 (JDAY,INTHR,M,D,Y,H,ITZ,IDSAV,CODE)

      INTEGER D,Y,H,DAYS(12),CODE

      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fctime'

      EQUIVALENCE (IJDAYT,XIJDAY),(IHT,XIH)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_util/RCS/mdyh2.f,v $
     . $',                                                             '
     .$Id: mdyh2.f,v 1.2 1998/07/02 16:30:42 page Exp $
     . $' /
C    ===================================================================
C

      DATA DAYS/0,31,59,90,120,151,181,212,243,273,304,334/
      DATA DEBG/4HMDYH/
C  J1 IS THE JULIAN DAY OF DEC 31, 1899 RELATIVE TO JAN 1, 0AD
      DATA J1/693960/,INTL/4HINTL/


      IF (ITRACE.GT.1) WRITE (IODBUG,*) ' **MDYH2 ENTERED'

      CALL FCITZC (ITZ,IDSAV,CODE)

      LDEBUG=0
      IF (IFBUG(DEBG).EQ.1) LDEBUG=1

      IF (LDEBUG.EQ.1) WRITE (IPR,40) JDAY,INTHR,M,D,H,Y,ITZ,IDSAV,CODE
40    FORMAT (' JDAY,INTHR,M,D,H,Y,ITZ,IDSAV,CODE=',8I11,1X,A4)

C  CAN ONLY CONVERT TO INTERNAL TIME WHEN NLSTZ IS UNDEFINED
      IF (NLSTZ.GE.-12.AND.NLSTZ.LE.12) GO TO 60
      IF (ITZ.LT.-12.OR.ITZ.GT.12) GO TO 60
      WRITE (IPR,50) CODE
50    FORMAT (1H0,10X,'**WARNING** MDYH2 UNABLE TO CONVERT ',
     *  'FROM INTERMAL TIME TO REQUESTED TIME ZONE ',A4,' BECAUSE' /
     *  ' TIME TO REQUESTED TIME ZONE ',A4,' BECAUSE' /
     *  11X,'VARIABLE NLSTZ IN COMMON BLOCK FCTIME IS OUTSIDE ',
     *  'THE RANGE -12 TO 12.')
      CALL WARN()
      ITZ=100
      IDSAV=0
      CODE=INTL

C  CONVERT INTERNAL CLOCK HOUR TO SELECTED TIME ZONE
C  (SEE DESCRIPTION OF OPPOSITE CONVERSION IN ROUTINE JULDA1)
60    IJDAY=JDAY
      IH=INTHR
      IF (JDAY.LT.0) JDAY=0
      IF (INTHR.LT.0) INTHR=0
      IF (INTHR.GT.24) INTHR=24
      IF (JDAY.EQ.IJDAY.AND.INTHR.EQ.IH) GO TO 90
      WRITE (IPR,70) IJDAY,IH,JDAY,INTHR
70    FORMAT (1H0,10X,'**WARNING** MDYH2 CALLED WITH ',
     *  'ARGUMENTS OUT OF RANGE WERE RESET TO INDICATED VALUES.' /
     *  11X,'JULIAN DAY     HOUR'/7X,I11,7X,I4/7X,I11,7X,I4)
      IJDAYT=IJDAY
      IHT=IH
      WRITE (IPR,80) IJDAY,IH,XIJDAY,XIH
80    FORMAT (1H0,10X,'** JULIAN DAY AND HOUR INPUT IN A4 FORMAT ',
     *  A4,1X,A4/11X,'** JULIAN DAY AND HOUR INPUT IN G15.7 FORMAT ',
     *  G15.7,1X,G15.7)
      CALL WARN()

90    H=INTHR
      IF (ITZ.LT.-12.OR.ITZ.GT.12) GO TO 100
      H=INTHR-NLSTZ+LOCAL+ITZ
      IF (IDSAV.EQ.1) H=H+1

C  CORRECT VALUE OF H TO RANGE 1-24
100   NDOFF=(H-24)/24
      IF (H.GT.0) NDOFF=H/24
      IF (NDOFF.GT.0.AND.MOD(H,24).EQ.0) NDOFF=NDOFF-1
      JD=JDAY+NDOFF
      H=H-NDOFF*24

C  COMPUTE YEAR AND CHECK FOR LEAP YEAR.
C  NOTE THAT THERE ARE EXACTLY 146097 DAYS IN 400 YEARS
C  THIS ACCOUNTS FOR LEAP YEAR, PLUS EVERY 100-TH YEAR NOT
C  BEING A LEAP YEAR UNLESS IT A 400-TH YEAR AS WELL.
      Y=(JD*400)/146097+1900
110   LEAP=1
      IF (MOD(Y,4).NE.0) LEAP=0
      IF (MOD(Y,100).EQ.0.AND.MOD(Y,400).NE.0) LEAP=0
      ID1=365*Y+Y/4-Y/100+Y/400-J1-LEAP
      IF (ID1.LT.JD) GO TO 120
         Y=Y-1
         GO TO 110
120   D=JD-ID1
130   LEAP=1
      IF (MOD(Y,4).NE.0) LEAP=0
      IF (MOD(Y,100).EQ.0.AND.MOD(Y,400).NE.0) LEAP=0
      IF (D.LE.365+LEAP) GO TO 140
      Y=Y+1
      D=D-365-LEAP
      GO TO 130

C  FIND MONTH
140   M=0
      IF (D.LE.31) M=1
      IF (M.GT.0) GO TO 160
      DO 150 I=3,12
         M=I-1
         IF (D.LE.(DAYS(I)+LEAP)) GO TO 160
150      CONTINUE
      M=12

C  MONTH KNOWN - COMPUTE DAY OFFSET FROM MONTH
160   D=D-DAYS(M)
      IF (M.GE.3) D=D-LEAP

      IF (LDEBUG.EQ.1) WRITE (IPR,40) JDAY,INTHR,M,D,H,Y,ITZ,IDSAV,CODE
      IF (LDEBUG.EQ.1) WRITE (IPR,180) LEAP,NDOFF,ID1,JD,J1
180   FORMAT (' LEAP,NDOFF,ID1,JD,J1=',5I11)

      IF (ITRACE.GT.2) WRITE (IODBUG,*) ' **EXIT MDYH2'

      RETURN
      END
