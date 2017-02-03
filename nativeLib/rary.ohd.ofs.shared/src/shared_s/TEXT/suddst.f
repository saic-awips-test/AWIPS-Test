C MODULE SUDDST
C-----------------------------------------------------------------------
C
C  ROUTINE TO CHECK WHICH DATA BASES ARE ALLOCATED AND SET INDICATORS.
C
      SUBROUTINE SUDDST (ISTAT)
C
      CHARACTER*50 DBNAME/' '/
C
      DIMENSION IHCLUN(10)
      DIMENSION IFCUN(10)
      DIMENSION NOTFND(10)
C
      INCLUDE 'uiox'
      INCLUDE 'uunits'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/suddsx'
      INCLUDE 'scommon/supagx'
      INCLUDE 'hclcommon/hunits'
      INCLUDE 'pdbcommon/pdunts'
      INCLUDE 'pppcommon/ppunts'
      INCLUDE 'prdcommon/punits'
      INCLUDE 'common/fcunit'
      INCLUDE 'dscommon/dsunts'
      INCLUDE 'dgcommon/dgunts'
C
      EQUIVALENCE (KINDXL,IHCLUN(1))
      EQUIVALENCE (KFCGD,IFCUN(1))
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_s/RCS/suddst.f,v $
     . $',                                                             '
     .$Id: suddst.f,v 1.3 2001/06/13 13:31:55 dws Exp $
     . $' /
C    ===================================================================
C
C
      IF (ISTRCE.GT.0) THEN
         IF (NPSPAG.EQ.0) CALL SUPAGE
         WRITE (IOSDBG,*) 'ENTER SUDDST'
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('SYS ')
C
      IF (LDEBUG.GT.0) THEN
         IF (NPSPAG.EQ.0) CALL SUPAGE
         WRITE (IOSDBG,180) IDBALC
         CALL SULINE (IOSDBG,1)
         WRITE (IOSDBG,190) IDBOPN
         CALL SULINE (IOSDBG,1)
         WRITE (IOSDBG,200) IDBWRT
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      ISTAT=0
C
      NUMWRN=0
      IPRERR=0
      IF (LDEBUG.GT.0) IPRERR=1
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF SYSTEM DATASET ALLOCATED
C
      IPOS=1
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 10
C
      NALLOC=0
      MALLOC=1
      DBNAME='NWSRFS SYSTEM DATASET'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      CALL SUDDS2 (KDTYPE,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF USER PARAMETER DATASET ALLOCATED
C
10    IPOS=2
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 20
C
      NALLOC=0
      MALLOC=1
      DBNAME='USER PARAMETER DATASET'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      CALL SUDDS2 (KUPARM,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF HYDROLOGIC COMMAND LANGUAGE DATA BASE ALLOCATED
C
20    IPOS=3
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 40
C
      NALLOC=0
      MALLOC=5
      DBNAME='HYDROLOGIC COMMAND LANGUAGE DATA BASE'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      DO 30 IUNIT=1,10
         IF (IUNIT.GE.5.AND.IUNIT.LE.8) GO TO 30
         IF (IUNIT.EQ.10) GO TO 30
         CALL SUDDS2 (IHCLUN(IUNIT),NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
30       CONTINUE
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF PREPROCESSOR DATA BASE ALLOCATED
C
40    IPOS=4
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 60
C
      NALLOC=0
      MALLOC=2+NMPPDF
      DBNAME='PREPROCESSOR DATA BASE'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      CALL SUDDS2 (KPDSIF,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
      CALL SUDDS2 (KPDRRS,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
      DO 50 I=1,NMPPDF
         IUNIT=KPDDDF(I)
         IF (IUNIT.EQ.0) GO TO 50
         CALL SUDDS2 (IUNIT,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
50       CONTINUE
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF PREPROCESSOR PARAMETRIC DATA BASE ALLOCATED
C
60    IPOS=5
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 80
C
      NALLOC=0
      MALLOC=1+NMPPPF
      DBNAME='PREPROCESSOR PARAMETRIC DATA BASE'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      CALL SUDDS2 (KPPIDX,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
      DO 70 I=1,NMPPPF
         IUNIT=KPPRMU(I)
         IF (IUNIT.EQ.0) GO TO 70
         CALL SUDDS2 (IUNIT,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
70       CONTINUE
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF PROCESSED DATA BASE ALLOCATED
C
80    IPOS=6
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 100
C
      NALLOC=0
      MALLOC=1+NMPRDF
      DBNAME='PROCESSED DATA BASE'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      CALL SUDDS2 (KRFCPR,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
      DO 90 I=1,NMPRDF
         IUNIT=KPRDTU(I)
         IF (IUNIT.EQ.0) GO TO 90
         CALL SUDDS2 (IUNIT,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
90       CONTINUE
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF FORECAST COMPONENT DATA BASE ALLOCATED
C
100   IPOS=7
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 120
C
      NALLOC=0
      MALLOC=9
      DBNAME='FORECAST COMPONENT DATA BASE'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      DO 110 I=1,10
         IUNIT=IFCUN(I)
         IF (IUNIT.EQ.0) GO TO 110
         CALL SUDDS2 (IUNIT,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
110      CONTINUE
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF SASM DATA BASE ALLOCATED
C
120   IPOS=8
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 130
C
      NALLOC=0
      MALLOC=1
      DBNAME='SASM DATA BASE'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      CALL SUDDS2 (KDSRCF,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF GOES DATA BASE ALLOCATED
C
130   IPOS=9
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 140
C
      NALLOC=0
      MALLOC=1
      DBNAME='GOES DATA BASE'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      CALL SUDDS2 (KDGRCF,NUNIT,NOTFND,NALLOC,LDEBUG,ISTAT)
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF FORECAST TEMPERATURE DATA BASE ALLOCATED
C
140   IPOS=10
      IF (IDBALC(IPOS).EQ.-1.OR.IDBALC(IPOS).EQ.2) GO TO 150
C
      NALLOC=0
      MALLOC=0
      DBNAME='FORECAST TEMPERATURE DATA BASE'
      NUNIT=0
      CALL UMEMST (0,NOTFND,10)
C
      CALL SUDDS3 (DBNAME,NALLOC,MALLOC,NOTFND,IPOS,NUMWRN,LDEBUG,ISTAT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
150   IDBFIL=1
C
      IF (LDEBUG.EQ.0) GO TO 160
         WRITE (IOSDBG,180) IDBALC
         CALL SULINE (IOSDBG,1)
         WRITE (IOSDBG,190) IDBOPN
         CALL SULINE (IOSDBG,1)
         WRITE (IOSDBG,200) IDBWRT
         CALL SULINE (IOSDBG,1)
C
160   IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,*) 'EXIT SUDDST : ISTAT=',ISTAT
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
180   FORMAT (' IDBALC=',10(I2,1X))
190   FORMAT (' IDBOPN=',10(I2,1X))
200   FORMAT (' IDBWRT=',10(I2,1X))
C
      END