C MODULE LLGDG
C-----------------------------------------------------------------------
C
C  THIS ROUTINE CONVERTS FROM LONGITUDE AND LATITUDE COORDINATE
C  LOCATION TO THE HRAP GRID SYSTEM LOCATION (AND VISA-VERSA).
C  NORTH POLE IS ASSUMED TO BE GRID COORDINATES 401,1601.
C
C    ARGUMENT LIST:
C
C       NAME     TYPE  I/O   DIM   DESCRIPTION
C       ----     ---- ------ ---   -----------
C       FLON      R   I OR O  1    LONGITUDE (DECIMAL DEGREES)
C       FLAT      R   I OR O  1    LATITUDE (DECIMAL DEGREES)
C       NBPTS     I      I    1    NUMBER OF LAT/LON PAIRS
C       X         R   I OR O  1    CONVERTED LONGITUDE
C       Y         R   I OR O  1    CONVERTED LATITUDE
C       ILLGD     I      I    1    CONVERSION CODE
C                                     0=CONVERT GRID POINTS TO LAT/LON
C                                     1=CONVERT LAT/LON TO GRID POINTS
C       GRIDF     R*8    I    1    GRID FACTOR, 1=HRAP 4= 1/4 HRAP
C       ISTAT     I      O    1    STATUS INDICATOR
C                                    -2=BAD VALUE FOR ILLGD
C                                    -1=BAD VALUE FOR NBPTS
C                                     0=NO ERRORS
C                                   POS=NUM OF INPUT COORDINATE ERRORS
C
C  Note; for bad input the following values are the default output:
C        for ILLGD = 0   FLAT = 0.0
C                        FLON = 90.0
C        for ILLGD = 1   X    = 401.0
C                        Y    = 1601.0
C
C  Adapted from LLGD routine by David T. Miller, RSIS, Nov 2007
C    added GRIDF which is a grid factor for 1/4 HRAP grid used by EMPE
C    LLGDG is specifically used by the gribit routine
C-----------------------------------------------------------------------
C
      SUBROUTINE LLGDG (FLON,FLAT,NBPTS,X,Y,ILLGD,GRIDF,ISTAT)
C
      REAL*8        DEGRAD,EARTHR,STLAT,STLON,RADDEG,XMESH,D1,D180,XD,YD
      REAL*8        TLAT,RE,R,RR,GI2,ANG,XLAT,WLONG
      INTEGER       ILLGD,NBPTS,ISTAT,II
      REAL          X(1),Y(1),FLON(1),FLAT(1)
      REAL*8        GRIDF,MINX,MAXX,MAXY,MISSX,MESHX 
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob82/ohd/pproc/src/gribit/RCS/llgd.f,v $
     . $',                                                             '
     .$Id: llgd.f,v 1.1 2006/10/19 16:06:04 dsa Exp $
     . $' /
C    ===================================================================
C
      DATA   DEGRAD / 0.01745329D0 /
      DATA   STLAT  / 60.D0        /
      DATA   EARTHR / 6371.2D0     /
      DATA   STLON  / 105.D0       /
      DATA   RADDEG / 57.2957795D0 /
      DATA   XMESH  / 4.7625D0     /
      DATA   D1     / 1.0D0        /
      DATA   D180   / 180.0D0      /

C              Check for positive number of pairs,
C              and get grid pts if ILLGD = 1, or long/lat if ILLGD = 0

      ISTAT = 0
C
C             For HRAP, GRIDF = 1
C             Must account for 1/4 HRAP where GRIDF would equal 4
C                    
      MESHX = XMESH/GRIDF
      
      IF (NBPTS .LE. 0) THEN
        ISTAT = -1

      ELSEIF (ILLGD .EQ. 1) THEN
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C              Compute grid points from longitude and latitude

        TLAT = STLAT*DEGRAD
        RE   = (EARTHR*(D1+DSIN(TLAT)))/MESHX
        DO 50 II=1,NBPTS
          X(II) = 0.0
          Y(II) = 0.0
          IF (FLAT(II).LT.10. .OR. FLAT(II).GT.80.) THEN
            ISTAT = ISTAT+1
          ELSEIF (FLON(II).LT.40. .OR. FLON(II).GT.180.) THEN
            ISTAT = ISTAT+1
          ELSE
            XLAT  = DBLE(FLAT(II))*DEGRAD
            WLONG = (DBLE(FLON(II))+D180-STLON)*DEGRAD
            R     = (RE*DCOS(XLAT))/(D1+DSIN(XLAT))
            X(II)  = SNGL(R*DSIN(WLONG))
            Y(II)  = SNGL(R*DCOS(WLONG))
          ENDIF
          X(II) = X(II)+FLOOR(401.* GRIDF)
          Y(II) = Y(II)+FLOOR(1601.* GRIDF)
   	  
50      CONTINUE

      ELSEIF (ILLGD .EQ. 0) THEN
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C              Compute longitude and latitude from grid points

        TLAT = STLAT*DEGRAD
        GI2 = (EARTHR*(D1+DSIN(TLAT)))/MESHX
        GI2 = GI2*GI2
        MINX = CEILING(-300.*GRIDF)
        MAXX = FLOOR(1661.*GRIDF)
        MAXY = FLOOR(1601.*GRIDF)
        MISSX = FLOOR(401.*GRIDF)
        DO 100 II=1,NBPTS
          FLON(II) = 0.0
          FLAT(II) = 90.0
          IF (X(II).LT.MINX .OR. X(II).GT.MAXX) THEN
            ISTAT = ISTAT+1
          ELSEIF (Y(II).LT.1 .OR. Y(II).GT.MAXY) THEN
            ISTAT = ISTAT+1
          ELSE
            XD = DBLE( X(II)-MISSX )
            YD = DBLE( Y(II)-MAXY )
            RR = XD*XD + YD*YD
            IF (RR .EQ. 0.0D0) THEN
              ISTAT = ISTAT+1
            ELSE
              FLAT(II) = SNGL( DASIN((GI2-RR)/(GI2+RR))*RADDEG )
              ANG = ATAN2(YD,XD)*RADDEG
               IF (ANG .LT. 0.0D0) ANG = ANG+360.0D0
              FLON(II) = 270.0 + SNGL(STLON-ANG)
               IF (FLON(II) .LT. 0.0 ) FLON(II) = FLON(II)+360.
               IF (FLON(II) .GE. 360.) FLON(II) = FLON(II)-360.
            ENDIF
          ENDIF
100     CONTINUE

      ELSE
        ISTAT = -2

      ENDIF

      RETURN
      END
