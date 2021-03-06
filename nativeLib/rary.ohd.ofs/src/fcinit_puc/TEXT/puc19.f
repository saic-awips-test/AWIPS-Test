C MEMBER PUC19
C  (from old member FCPUC19)
C
      SUBROUTINE PUC19(PS,CS)
C.......................................
C     THIS IS THE PUNCHED CARD SUBROUTINE FOR THE 'SNOW-17 '
C        OPERATION.
C.......................................
C     SUBROUTINE INITIALLY WRITTEN BY...
C      FID  ERIC ANDERSON - HRL   MAY 1980
C
CVK     MODIFIED 4/00 BY V. KOREN: TWO NEW STATES ADDED
C
CAV     MODIFIED 6/03 BY A Vo: Obs snow depth state added 
C
CEA     MODIFIED 11/05 BY E. ANDERSON TO ADD TAPREV AND CORRECT
CEA       A FEW EXISTING PROBLEMS
C
C.......................................
      DIMENSION PS(*),CS(*)
CVK  FID ARRAY INCREASED TO INCLUDE SNOW DEPTH TIME SERIES INFORMATION
CVK      DIMENSION UPDATE(2),UPS(2),FID(6),UPPM(2),RSID(2),AE(2,14)
      DIMENSION UPDATE(2),UPS(2),FID(9),UPPM(2),RSID(2),AE(2,14)
C
C     COMMON BLOCKS
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON/IONUM/IN,IPR,IPU
      COMMON/PUDFLT/IPDFLT
      COMMON/FPROG/MAINUM,VERS,VDATE(2),PNAME(5),NDD
      COMMON/FENGMT/METRIC
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_puc/RCS/puc19.f,v $
     . $',                                                             '
     .$Id: puc19.f,v 1.7 2006/10/03 19:33:24 hsu Exp $
     . $' /
C    ===================================================================
C
C     DATA STATEMENTS
      DATA ALL,FNONE,YES,SUMS,RDCO/4HALL ,4HNONE,3HYES,4HSUMS,4HRDCO/
      DATA BLANK,BLANK3,BLANK2/4H    ,3H   ,2H  /
      DATA UPDATE/4HUPDA,2HTE/
      DATA CMETR,CENGL/4HMETR,4HENGL/
      DATA AVSE/4HAVSE/
C.......................................
C     TRACE LEVEL=1,NO DEBUG OUTPUT
      IF(ITRACE.GE.1) WRITE(IODBUG,900)
  900 FORMAT(1H0,16H** PUC19 ENTERED)
C.......................................
C     CONTROL VARIABLES
CEA  VERSION NUMBER NEEDED TO DETERMINE WHAT CARRYOVER EXISTS
CEA    IN THE CS ARRAY.
      IVER=PS(1)
      IDT=PS(14)
      ITPX=PS(10)
      LPM=PS(25)
      LADC=PS(26)
      LRM=PS(17)
      LPCTS=PS(18)
      LOWE=PS(19)
      LSWE=PS(20)
      LOSC=PS(21)
      LCOVER=PS(22)
      LSUMS=PS(23)
      LTAPM=PS(27)
      LUPPM=PS(28)
      LMFV=PS(29)
      LAEC=PS(30)
CVK  SNSG TIME SERIES ADDED
      LSNSG=PS(31)
cav  SNOG TIME SERIES ADDED
      LSNOG=PS(32)
      IPRINT=PS(24)
C.......................................
C     PUNCH CARD NUMBER 1.
      PRC=BLANK
      IF(IPRINT.EQ.0) PRC=FNONE
      IF(IPRINT.EQ.1) PRC=ALL
      ODS=BLANK3
      IF((LOWE.GT.0).OR.(LOSC.GT.0).or.(lsnog.gt.0)) ODS=YES
      OSS=BLANK3
CEA  CHECK FOR SIMULATED DEPTH TIME SERIES
C      IF ((LSWE.GT.0).OR.(LCOVER.GT.0)) OSS=YES
      IF ((LSWE.GT.0).OR.(LCOVER.GT.0).OR.(LSNSG.GT.0)) OSS=YES
      SS=BLANK
      IF(LSUMS.GT.0) SS=SUMS
      UPS(1)=BLANK
      UPS(2)=BLANK2
      IF(MAINUM.LT.3) GO TO 101
      IF(LUPPM.EQ.0) GO TO 101
      UPS(1)=UPDATE(1)
      UPS(2)=UPDATE(2)
  101 RDCOS=BLANK
      WE=CS(1)
      IF(WE.EQ.0.0) GO TO 107
      RDCOS=RDCO
  107 AVSES=BLANK
      IF (LAEC.EQ.0) GO TO 102
      AVSES=AVSE
  102 WRITE(IPU,901) (PS(I),I=2,6),PS(LPM+1),PS(LPM+13),PRC,ODS,OSS,SS,
     1UPS,RDCOS,AVSES
  901 FORMAT(5A4,F5.0,F5.1,1X,A4,2X,A3,2X,A3,1X,A4,4X,A4,A2,1X,A4,1X,A4)
C.......................................
C     PUNCH CARD NUMBER 2.
      DO 103 I=1,6
  103 FID(I)=BLANK
      IF (LRM.EQ.0) GO TO 104
      FID(1)=PS(LRM)
      FID(2)=PS(LRM+1)
      FID(3)=PS(LRM+2)
  104 IF(LPCTS.EQ.0) GO TO 105
      FID(4)=PS(LPCTS)
      FID(5)=PS(LPCTS+1)
      FID(6)=PS(LPCTS+2)
  105 WRITE(IPU,902) ITPX,(PS(I),I=7,9),PS(LPM),(FID(I),I=1,6)
  902 FORMAT(3X,I2,2X,2A4,1X,A4,F10.3,7X,2A4,1X,A4,7X,2A4,1X,A4)
C.......................................
C     PUNCH CARD NUMBER 3.
      IF(LTAPM.GT.0) GO TO 106
      WRITE(IPU,903)(PS(I),I=11,13),IDT
  903 FORMAT(2X,2A4,1X,A4,3X,I2,F10.0,2F5.2)
      GO TO 130
  106 WRITE(IPU,903) (PS(I),I=11,13),IDT,PS(LTAPM),PS(LTAPM+1),
     1PS(LTAPM+2)
  130 IF (LAEC.EQ.0) GO TO 110
C.......................................
C     PUNCH CARD NUMBER 3A
      IAEU=PS(LAEC+1)
      IF (METRIC.EQ.0) GO TO 131
      IF ((METRIC.EQ.-1).AND.(IAEU.EQ.0)) GO TO 131
      UNIT=CMETR
      CONV=1.0
      GO TO 132
  131 UNIT=CENGL
      CONV=1.0/0.3048
  132 NPTAE=PS(LAEC)
      DO 133 I=1,NPTAE
      L=LAEC+5+(I-1)*2
      AE(1,I)=PS(L)*CONV
      AE(2,I)=PS(L+1)
  133 CONTINUE
      EMIN=AE(1,1)
      EMAX=AE(1,NPTAE)
      NPTAE=NPTAE-2
      LRS=LAEC+2
      RSID(1)=PS(LRS)
      RSID(2)=PS(LRS+1)
      RSTYPE=PS(LRS+2)
      WRITE(IPU,911) NPTAE,EMIN,EMAX,UNIT,RSID,RSTYPE
  911 FORMAT(3X,I2,2F10.0,1X,A4,2X,2A4,1X,A4)
      IF (NPTAE.EQ.0) GO TO 110
C     PUNCH CARD NUMBER 3B
      WRITE(IPU,912) (AE(1,I+1),AE(2,I+1),I=1,NPTAE)
  912 FORMAT(4(F10.0,2X,F3.2))
  110 IF(ODS.EQ.BLANK3) GO TO 115
C.......................................
C     PUNCH CARD NUMBER 4.
cav  FID ARRAY SIZE INCREASED
      DO 111 I=1,9
  111 FID(I)=BLANK
      IT1=0
      IT2=0
      IT3=0
      IF(LOWE.EQ.0) GO TO 112
      FID(1)=PS(LOWE)
      FID(2)=PS(LOWE+1)
      FID(3)=PS(LOWE+2)
      IT1=PS(LOWE+3)
  112 IF(LOSC.EQ.0) GO TO 113
      FID(4)=PS(LOSC)
      FID(5)=PS(LOSC+1)
      FID(6)=PS(LOSC+2)
      IT2=PS(LOSC+3)
  113 IF(LSNOG .EQ. 0) GO TO 114
      FID(7)=PS(LSNOG)
      FID(8)=PS(LSNOG+1)
      FID(9)=PS(LSNOG+2)
      IT3=PS(LSNOG+3)
CEA  ALWAYS INCLUDED ALL TIME SERIES SO PUNCH OUTPUT COMPATIABLE
CEA    WITH CURRENT VERSION INPUT.
  114 WRITE(IPU,904) (FID(I),I=1,3),IT1,(FID(I),I=4,6),IT2,
     +  (FID(I),I=7,9),IT3
CVK  SNOW DEPTH TIME SERIES ADDED TO 904 FORMAT
CVK  904 FORMAT(2X,2A4,1X,A4,3X,I2,12X,2A4,1X,A4,3X,I2)
  904 FORMAT(2X,2A4,1X,A4,3X,I2,12X,2A4,1X,A4,3X,I2,2X,2A4,1X,A4,3X,I2)
  115 IF(OSS.EQ.BLANK3) GO TO 120
C.......................................
C     PUNCH CARD NUMBER 5.
CVK  FID ARRAY INCREASED 
CVK      DO 116 I=1,6
      DO 116 I=1,9     
  116 FID(I)=BLANK
      IT1=0
      IT2=0
      IT3=0
      IF(LSWE.EQ.0) GO TO 117
      FID(1)=PS(LSWE)
      FID(2)=PS(LSWE+1)
      FID(3)=PS(LSWE+2)
      IT1=PS(LSWE+3)
CVK  SNSG TIME SERIES ADDED
CVK  117 IF(LCOVER.EQ.0) GO TO 118
  117 IF(LCOVER.EQ.0) GO TO 126
      FID(4)=PS(LCOVER)
      FID(5)=PS(LCOVER+1)
      FID(6)=PS(LCOVER+2)
      IT2=PS(LCOVER+3)
CVK  SNSG TIME SERIES ADDED
  126 IF(LSNSG .EQ. 0) GO TO 127
      FID(7)=PS(LSNSG)
      FID(8)=PS(LSNSG+1)
      FID(9)=PS(LSNSG+2)
      IT3=PS(LSNSG+3)
CEA  ALWAYS INCLUDED ALL TIME SERIES SO PUNCH OUTPUT COMPATIABLE
CEA    WITH CURRENT VERSION INPUT.
  127 WRITE(IPU,904) (FID(I),I=1,3),IT1,(FID(I),I=4,6),IT2,
     +  (FID(I),I=7,9),IT3
C.......................................
C     PUNCH CARD NUMBER 6.
  120 MV=0
      IF (LMFV.GT.0) MV=1
      WRITE(IPU,905) (PS(LPM+I),I=2,6),MV
  905 FORMAT(3F5.2,F5.3,F5.0,I5)
C     PUNCH CARD 6A IF NEEDED
      IF (LMFV.EQ.0) GO TO 125
      WRITE(IPU,910) PS(LMFV),(PS(LMFV+I),I=1,11)
  910 FORMAT(12F5.2)
C.......................................
C     PUNCH CARD NUMBER 7.
  125 DO 121 I=1,2
  121 UPPM(I)=0.0
      IF(LUPPM.EQ.0) GO TO 122
      UPPM(1)=PS(LUPPM)
      UPPM(2)=PS(LUPPM+1)
  122 WRITE(IPU,906) (PS(LPM+I),I=7,12),UPPM
  906 FORMAT(2F5.2,2F5.2,4F5.2)
C.......................................
C     PUNCH CARD NUMBER 8.
      WRITE(IPU,907) PS(LADC),(PS(LADC+I),I=1,8)
  907 FORMAT(9F5.2)
      IF(RDCOS.EQ.BLANK) RETURN
C.......................................
C     PUNCH CARD NUMBER 9.
      ICO=1
      IF(IPDFLT.EQ.1) ICO=0
      IWE=CS(1)+0.5
      IAX=CS(5)+0.5
      NEXLAG=5/ITPX+2
      N=11+NEXLAG
CEA  INCLUDE ALL CARRYOVER THAT IS NEEDED BY THE CURRENT VERSION -
CEA    OBTAIN VALUE FROM CS ARRAY IF AVAILABLE, OTHERWISE SET TO
CEA    DEFAULT VALUE.
      IDPT=0
      IF (IVER.GT.1) IDPT=CS(N)+0.5
      SNTMP=0.0
      IF (IVER.GT.1) SNTMP=CS(N+1)
      TAPREV=0.0
      IF (IVER.GT.3) TAPREV=CS(N+2)
CVK  ADD ADDITIONAL CARRYOVER
CVK      WRITE(IPU,908) IWE,(CS(I),I=2,4),IAX,ICO
CVK  908 FORMAT(I5,F5.1,F5.0,F5.1,I5,4X,I1)
CEA  ADD TAPREV CARRYOVER VALUE
CEA      WRITE(IPU,908) IWE,(CS(I),I=2,4),IAX,ICO,CS(N),CS(N+1)
      WRITE(IPU,908) IWE,(CS(I),I=2,4),IAX,ICO,IDPT,SNTMP,TAPREV
ckwz  908 FORMAT(I5,F5.1,F5.0,F5.1,I5,4X,I1,2F5.1)  
ckwz r24-14, change to fit the snow depth value 6416.181. 11/12/03
CEA   908 FORMAT(I5,F5.1,F5.0,F5.1,I5,4X,I1,F5.0,F5.1)  
  908 FORMAT(I5,F5.1,F5.0,F5.1,I5,4X,I1,I5,2F5.1)  
      IF (ICO.EQ.0) RETURN
C.......................................
C     PUNCH CARD NUMBER 10.
      L=10+NEXLAG
      ISB=CS(6)+0.5
      ISBWS=CS(8)+0.5
      IAEA=CS(10)+0.5
      WRITE(IPU,909) ISB,CS(7),ISBWS,CS(9),IAEA,(CS(I),I=11,L)
  909 FORMAT(I5,F5.2,I5,F5.1,I5,7F5.1)
C.......................................
      RETURN
      END