C MEMBER EWTINF
C  (from old member EEWTINF)
C
      SUBROUTINE EWTINF
C
C   THIS SUBROUTINE WRITES BASIC ESP RUN TIME INFO THAT IS
C UNIVERSAL FOR ALL SEGMENTS (INDIVIDUAL SEGMENT RUN INFO
C IS WRITTEN BY ANOTHER ROUTINE, ESGINF.)
C
C ORIGINALLY BY G. DAY - HRL
C MODIFIED BY ED VANBLARGAN  MARCH 1982
C
      DIMENSION SBNAME(2),OLDOPN(2),GROUP(12),UNITS(4)
C
      INCLUDE 'common/etime'
      INCLUDE 'common/eunit'
      INCLUDE 'common/fcrunc'
      INCLUDE 'common/eswtch'
      INCLUDE 'common/fctime'
      INCLUDE 'common/esprun'
      INCLUDE 'common/ionum'
      INCLUDE 'common/where'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/eoutpt'
      INCLUDE 'common/fengmt'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_esp/RCS/ewtinf.f,v $
     . $',                                                             '
     .$Id: ewtinf.f,v 1.2 1997/12/31 19:45:49 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA SBNAME/4HEWTI,4HNF  /
      DATA GROUP/4HCARR,4HYOVE,4HR GR,4HOUP ,4HFORE,4HCAST,
     1 4H GRO,4HUP  ,4HSEGM,4HENT ,4H    ,4H    /
      DATA UNITS/4HENGL,4HISH ,4HMETR,4HIC  /
C
C SET ERROR TRACES
C
      IOLDOP=IOPNUM
      IOPNUM=0
      DO 10 I=1,2
      OLDOPN(I)=OPNAME(I)
   10 OPNAME(I)=SBNAME(I)
C
      IF(ITRACE.GE.1) WRITE(IODBUG,900)
  900 FORMAT(1H0,17H** EWTINF ENTERED)
C
C SET LOCAL TO FLOCAL
C
      LOCAL=FLOCAL
C
C
C PRINT OUT THE RUNTYPE INFO AND ID
C
      IGPTR=4*ITYPRN-4
C
      WRITE(IPR,600) (GROUP(IGPTR+I),I=1,4),RUNID
  600 FORMAT(// 1X,20X,4A4,2X,2A4
     * // 11X,50HFOLLOWING IS RUNTIME INFORMATION IN EFFECT FOR ALL,
     * 25H SEGMENTS THIS EXECUTION:)
C
C PRINT OUT START DATE
C
      CALL MDYH1(IJDFC,IHFC,ISTMO,ISTDA,ISTYR,ISTHR,NOUTZ,
     1 NOUTDS,TZC)
C
      WRITE(IPR,610) ISTMO,ISTDA,ISTYR,ISTHR,TZC
  610 FORMAT(1H0,10X,21HSTART DATE OF RUN IS ,I2,1H/,I2,1H/,
     1 I4,3H HR,I2,2X,A4)

cew
cew Because ESP runs with internal time = LST, must shift dates
cew from LST to internal time and then use the MDYH1 function
cew to compute mdyh

      ihlst_temp =ihlst-local
      ijdlst_temp=ijdlst
      if(ihlst_temp.lt.0) then
	ihlst_temp =(ihlst+24)-local
	ijdlst_temp=ijdlst-1
      endif
      CALL MDYH1(ijdlst_temp,ihlst_temp,ISTMO2,ISTDA2,ISTYR2,ISTHR2,
     1 NOUTZ,NOUTDS,TZC)
C
      if(isthr2.ne.isthr) then
	write(ipr,*)' **NOTE**  THE START DATE HAS BEEN SHIFTED.'
        WRITE(IPR,611) ISTMO2,ISTDA2,ISTYR2,ISTHR2,TZC
  611 FORMAT(1H0,10X,25HSTART DATE OF RUN IS NOW ,I2,1H/,I2,1H/,
     1 I4,3H HR,I2,2X,A4)
      endif
cew
C
C PRINT OUT HISTORICAL YEARS.
C
      WRITE(IPR,620) IHYR,LHYR
  620 FORMAT(1H0,10X,41HTHE HISTORICAL WATER YEARS SIMULATED ARE ,2X,
     1 I5,2H -,I5)
C
C PRINT OUT BASE PERIOD IF DESIRED.
C
      IF(JBPS.EQ.0) GO TO 125
      WRITE(IPR,627) IBHYR,LBHYR
  627 FORMAT(1H ,10X,43HA BASE PERIOD ANALYSIS WILL BE PERFORMED ON,
     1 6H YEARS,1X,I4,3H - ,I4)
  125 CONTINUE
C
C PRINT OUT DATES OF ALL WINDOWS
C
      WRITE(IPR,630)
630   FORMAT(1H0,10X,37HSTARTING AND ENDING WINDOW DATES ARE:)
      DO 150 I=1,NUMWIN
      CALL MDYH1(IWJD(I),IWH(I),IWMO,IWDA,IWYR,IWHR,NOUTZ,NOUTDS,
     1 TZCI)
      CALL MDYH1(LWJD(I),LWH(I),LWMO,LWDA,LWYR,LWHR,NOUTZ,NOUTDS,
     1 TZCL)
      WRITE(IPR,640) I,IWMO,IWDA,IWYR,IWHR,TZCI,LWMO,LWDA,LWYR,LWHR,TZCL
  640 FORMAT(1H0,10X,I5,2H.),2X,I2,1H/,I2,1H/,I4,4H  HR,I2,2X,A4,5X,I2,
     1 1H/,I2,1H/,I4,4H  HR,I2,2X,A4)
  150 CONTINUE
C
      WRITE (IPR,699)
C
C HISTORICAL AND ADJUSTED SWITCHES.
C
      IF(JHSS.NE.1) GO TO 160
      WRITE(IPR,650)
  650 FORMAT(1H ,10X,40HHISTORICAL SIMULATION WILL BE PERFORMED.)
  160 IF(JASS.NE.1) GO TO 170
      WRITE(IPR,660)
  660 FORMAT(1H ,10X,40HADJUSTED   SIMULATION WILL BE PERFORMED.)
C
C WRITE UNITS CONSIDERING METRIC AND WATER SUPPLY.
C
170   IUPTR=2*METRIC
      WRITE(IPR,690) (UNITS(IUPTR+I),I=1,2)
690   FORMAT(1H ,10X,17HUNITS WILL BE IN ,2A4)
      IF (IWS.EQ.1) WRITE(IPR,692)
692   FORMAT(1H+,35X,19H,WATER SUPPLY UNITS)
C
C PERMANENT FILE UNIT NUMBERS
C
      WRITE(IPR,693)
693   FORMAT(1H0,10X,35HUNIT NUMBERS (IF ANY) USED TO WRITE,
     * 24H TO PERMANENT FILES ARE:)
C
      DO 250 I=1,5
        IF (KEPERM(1).NE.0) WRITE(IPR,697) KEPERM(I)
697     FORMAT(1H ,15X,6HUNIT =,I4)
250   CONTINUE
C
C RESET LOCAL=0
C
      LOCAL=0
C
C
C
699   FORMAT(1H0)
C
C RESET ERROR TRACES
C
      IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
C
      RETURN
      END