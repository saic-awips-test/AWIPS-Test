C   MODULE TCORR
C
      SUBROUTINE TCORR(MAXT,MINT,INSTT,NINST,ICFMX,ICFMN,MSNG)
C
C THIS SUBROUTINE APPLIES CORRECTION FACTORS TO MAX,MIN, AND
C INSTANTANEOUS TEMPERATURE VALUES
C
C
C   THIS SUBROUTINE WAS ORIGINALLY WRITTEN BY W. GILREATH
C
      INTEGER*2 MAXT,MINT,INSTT,ICFMX,ICFMN,IC,MSNG
C
      LOGICAL LBUG
C
      DIMENSION SBNAME(2),OLDOPN(2),INSTT(1),IC(8)
C
      INCLUDE 'common/pudbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/where'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_mat/RCS/tcorr.f,v $
     . $',                                                             '
     .$Id: tcorr.f,v 1.1 1995/09/17 19:02:57 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA DCODE/4HTCOR/,SBNAME/4HTCOR,4HR   /
      IF(IPTRCE.GE.1) WRITE(IOPDBG,900)
  900 FORMAT(1H0,14HTCORR ENTERED.)
      LBUG=.FALSE.
      IF(IPBUG(DCODE).EQ.1) LBUG=.TRUE.
C
      IOLDOP=IOPNUM
      IOPNUM=-2
      DO 10 I=1,2
      OLDOPN(I)=OPNAME(I)
   10 OPNAME(I)=SBNAME(I)
C
      IF(NINST.EQ.0) GO TO 50
      IF(LBUG) WRITE(IOPDBG,910) MAXT,MINT,ICFMX,ICFMN,
     1 NINST,(INSTT(I),I=1,NINST)
  910 FORMAT(1H0,'BEFORE CORRECTIONS IN PTCORR',5X,'  MAXT =',I5,
     1 '  MINT =',I5,'  ICFMX =',I5,'  ICFMN =',I5/32X,
     2 '  INSTT(1) TO (',I2,') =',(8I5))
      GO TO 60
   50 IF(LBUG) WRITE(IOPDBG,915) MAXT,MINT,ICFMX,ICFMN
  915 FORMAT(1H0,'BEFORE CORRECTIONS IN PTCORR',5X,'  MAXT =',I5,
     1 '  MINT =',I5,'  ICFMX =',I5,'  ICFMN =',I5)
   60 CONTINUE
C
C GO TO STATEMENT 200 IF EITHER A MAXIMUM OR MINIMUM TEMPERATURE VALUE
C IS MISSING (MSNG), OR MAX TEMPERATURE EQUALS MIN TEMPERATURE.
C
      IF((MAXT.EQ.MSNG).OR.(MINT.EQ.MSNG).OR.(MAXT.EQ.MINT)) GO TO 200
C
C NINST IS THE NUMBER OF INSTANTANEOUS VALUES
C
      IF(NINST.LE.0) GO TO 150
C
C FOLLOWING DO LOOP (THRU STATEMENT 100) COMPUTES CORRECTION FACTOR(IC)
C AND ADDS IT TO THE INSTANTANEOUS TEMPERATURES WHEN THERE ARE NO
C MISSING MAX AND MIN TEMPERATURE VALUES. NO CORRECTION IS MADE IF
C INSTANTANEOUS TEMPERATURE IS MISSING (MSNG).
C
      DO 80 I=1,NINST
      IC(I)=0.
   80 CONTINUE
C
      DO 100 I=1,NINST
      IF(INSTT(I).EQ.MSNG) GO TO 100
      RC=(ICFMN*(MAXT-INSTT(I))+ICFMX*(INSTT(I)-MINT))
      IC(I)=RC/(MAXT-MINT)
      INSTT(I)=INSTT(I)+IC(I)
  100 CONTINUE
C
      IF(.NOT.LBUG) GO TO 150
      WRITE(IOPDBG,930) (IC(I),I=1,NINST)
  930 FORMAT(1X,4HIC =,8I5)
C
C FOLLOWING 2 STATEMENTS ADD MAXIMUM TEMPERATURE CORRECTION FACTOR
C (ICFMX) TO MAXIMUM TEMPERATURE AND MINIMUM TEMPERATURE CORRECTION
C FACTOR (ICFMN) TO MINIMUM TEMPERATURE.
C
  150 MAXT=MAXT+ICFMX
      MINT=MINT+ICFMN
      GO TO 500
C
C NINST IS THE NUMBER OF INSTANTANEOUS VALUES
C
  200 IF(NINST.LE.0) GO TO 350
C
C  COMPUTES CORRECTION FACTOR (IC) WHEN EITHER A MAXIMUM
C OR MINIMUM TEMPERATURE IS MISSING OR WHEN MAX TEMP EQUALS MIN TEMP.
C
      IC(1)=(ICFMN+ICFMX)/2
      IF(LBUG) WRITE(IOPDBG,930) IC(1)
C
C FOLLOWING DO LOOP (THRU STATEMENT 300) ADDS CORRECTION FACTOR (IC) TO
C INSTANTANEOUS TEMPERATURES.  NO CORRECTION IS MADE IF INSTANTANEOUS
C TEMPERATURE IS MISSING (MSNG).
C
      DO 300 I=1,NINST
      IF(INSTT(I).EQ.MSNG) GO TO 300
      INSTT(I)=INSTT(I)+IC(1)
  300 CONTINUE
C
C FOLLOWING STATEMENTS ADD MAXIMUM TEMPERATURE CORRECTION
C FACTOR (ICFMX) TO MAXIMUM TEMPERATURE AND MINIMUM TEMPERATURE
C CORRECTION FACTOR (ICFMN) TO MINIMUM TEMPERATURE. NO CORRECTION IS
C MADE IF TEMPERATURE IS MISSING.
C
  350 IF(MAXT.EQ.MSNG) GO TO 400
      MAXT=MAXT+ICFMX
  400 IF(MINT.EQ.MSNG) GO TO 500
      MINT=MINT+ICFMN
  500 IF(NINST.EQ.0) GO TO 550
      IF(LBUG) WRITE(IOPDBG,950) MAXT,MINT,ICFMX,ICFMN,
     1NINST,(INSTT(I),I=1,NINST)
  950 FORMAT(1X,'AFTER CORRECTIONS IN PTCORR',6X,'  MAXT =',I5,
     1 '  MINT =',I5,'  ICFMX =',
     2 I5,'  ICFMN =',I5/32X,'  INSTT(1) TO (',I2,') =',(8I5))
      GO TO 560
  550 IF(LBUG) WRITE(IOPDBG,955) MAXT,MINT,ICFMX,ICFMN
  955 FORMAT(1X,'AFTER CORRECTIONS IN PTCORR',6X,'  MAXT =',I5,
     1 '  MINT =',I5,'  ICFMX =',I5,'  ICFMN =',I5)
  560 CONTINUE
      IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
C
      RETURN
      END
