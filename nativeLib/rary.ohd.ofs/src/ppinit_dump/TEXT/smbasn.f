C MODULE SMBASN
C-----------------------------------------------------------------------
C
C  ROUTINE TO OUTPUT BASIN PARAMETERS.
C
      SUBROUTINE SMBASN (LARRAY,ARRAY,OUTPUT,UNITS,SUMARY,PLOT,SORT,
     *   NSPACE,NFLD,ISTAT)
C
      CHARACTER*4 OUTPUT,PLOT,SORT,SUMARY,UNITS
      CHARACTER*8 CHAR1,CHAR2
      CHARACTER*10 PUFORM
      CHARACTER*20 CHAR,CHK,OPTN
C
      DIMENSION ARRAY(LARRAY)
      INTEGER*2 ISTATE(1)
      DIMENSION ISRTBY(1),IPNTRS(1)
C
C  BASN PARAMETER VARIABLES
      CHARACTER*8 BASNID,PID,PXID,TID
      CHARACTER*20 DESCRP
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/suoptx'
      INCLUDE 'ufreex'
      INCLUDE 'scommon/sworkx'
      INCLUDE 'scommon/sntwkx'
C
      EQUIVALENCE (ISTATE(1),STATNW(1))
      EQUIVALENCE (IPNTRS(1),PP24NW(1))
      EQUIVALENCE (ISRTBY(1),STIDNW(1,1))
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_dump/RCS/smbasn.f,v $
     . $',                                                             '
     .$Id: smbasn.f,v 1.5 1999/01/20 14:22:53 page Exp $
     . $' /
C    ===================================================================
C
C
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,150)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('DUMP')
C
      ISTAT=0
      MCHAR=LEN(CHAR)/4
      MCHK=LEN(CHK)/4
      NUMERR=0
      NUMWRN=0
      ISTRT=0
      IALL=0
      MAXDEC=2
      PUFORM='PACKED'
      IPROPT=1
      IDLIST=0
      IENDIN=0
      LPUNCH=NPUCRD
      UNDEF=-997.
      CALL UDUCNV ('M   ','FT  ',1,1,UNDEF,UNDEF1,IERR)
      CALL UDUCNV ('KM2 ','MI2 ',1,1,UNDEF,UNDEF2,IERR)
      NTBASN=0
      NTBPTS=0
      NTSEGS=0
C
C  SET UP WORK SPACE POINTERS
      IDIV=15
      LWP=LSWORK/IDIV
C  X:
      IWP1=1
C  Y:
      IWP2=LWP*1+1
C  LAT:
      IWP3=LWP*2+1
C  LON:
      IWP4=LWP*3+1
C  JX:
      IWP5=LWP*4+1
C  JY:
      IWP6=LWP*5+1
C  IY:
      IWP7=LWP*6+1
C  IXB:
      IWP8=LWP*8+1
C  IXE:
      IWP9=LWP*10+1
C  JN:
      IWP10=LWP*14+1
C 
      MBPTS=LWP
      MSEGS=LWP
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,*) 'IN SMBASN -',
     *      ' LSWORK=',LSWORK,
     *      ' IDIV=',IDIV,
     *      ' MBPTS=',MBPTS,
     *      ' MSEGS=',MSEGS,
     *      ' '
         CALL SULINE (IOSDBG,1)
         ENDIF   
C
C  PRINT HEADER LINE
      IF (ISLEFT(10).GT.0) CALL SUPAGE
      WRITE (LP,160)
      CALL SULINE (LP,2)
      WRITE (LP,180)
      CALL SULINE (LP,1)
C
C  SET PLOT FLAG
      IPLOT=0
C
      IF (PLOT.EQ.'YES') IPLOT=1
      IF (PLOT.EQ.' ') IPLOT=IOPPLT
C
C  CHECK SORT OPTION
      ISORT=0
      IF (SORT.EQ.'ID') ISORT=1
      IF (SORT.EQ.'DESC') ISORT=2
      IF (ISORT.GE.0.AND.ISORT.LE.2) THEN
         ELSE
            WRITE (LP,170) SORT
            CALL SUWRNS (LP,2,NUMWRN)
         ENDIF
         ISORT=1
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK FIELDS FOR DUMP BASN OPTIONS
C
10    CALL UFIELD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,MCHAR,
     *   CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
      IF (NFLD.EQ.-1) IENDIN=1
      IF (LDEBUG.GT.0) THEN
         CALL UPRFLD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,MCHAR,
     *      CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
         ENDIF
      IF (IERR.EQ.1) THEN
         IF (LDEBUG.GT.0) THEN
            WRITE (IOSDBG,200) NFLD
            CALL SULINE (IOSDBG,1)
            ENDIF
         GO TO 10
         ENDIF
C
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,210) CHAR
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  CHECK FOR COMMAND
      IF (LATSGN.EQ.1) IENDIN=1
C
      IF (ILPFND.GT.0.AND.IRPFND.EQ.0) THEN
         WRITE (LP,220) NFLD
         CALL SULINE (LP,2)
         ILPFND=0
         IRPFND=0
         ENDIF
      IF (LLPAR.GT.0) ILPFND=1
C
      IF (LLPAR.GT.0) CALL UFPACK (MCHK,CHK,ISTRT,1,LLPAR-1,IERR)
      IF (LLPAR.EQ.0) CALL UFPACK (MCHK,CHK,ISTRT,1,LENGTH,IERR)
C
C  CHECK FOR GROUP
      CALL SUIDCK ('DUMP',CHK,NFLD,0,IKEYWD,IERR)
      IF (IERR.GT.0) IENDIN=1
C
      IF (NFLD.EQ.1.AND.IENDIN.EQ.0) CALL SUPCRD
C
      IF (IENDIN.EQ.1) THEN
         IF (IALL.EQ.1.OR.IDLIST.EQ.1) GO TO 130
         IF (NTBASN.EQ.0) GO TO 20
         ENDIF
C
      OPTN=CHK
C
C  CHECK FOR ALL OPTION
      IF (OPTN.NE.'ALL') GO TO 25
20       IALL=1
         IDLIST=0
         GO TO 50
C
C  CHECK FOR PUMAXDEC OPTION
25    IF (OPTN.EQ.'PUMAXDEC') THEN
         IF (LLPAR.EQ.0) THEN
            INTEGR=2
            WRITE (LP,230) OPTN(1:LENSTR(OPTN)),INTEGR
            CALL SUWRNS (LP,2,NUMWRN)
            GO TO 30
            ENDIF
         IF (LRPAR.GT.0) IRPFND=1
         IF (LRPAR.EQ.0) THEN
            WRITE (LP,220) NFLD
            CALL SULINE (LP,2)
            LRPAR=LENGTH+1
            ENDIF
         CALL UFINFX (INTEGR,ISTRT,LLPAR+1,LRPAR-1,IERR)
30       MINVAL=0
         MAXVAL=4
         IF (INTEGR.GE.MINVAL.AND.INTEGR.LE.MAXVAL) THEN
            ELSE
               WRITE (LP,270) OPTN(1:LENSTR(OPTN)),INTEGR,MINVAL,MAXVAL
               CALL SUERRS (LP,2,NUMERR)
               GO TO 10
            ENDIF
         MAXDEC=INTEGR
         IF (LDEBUG.GT.0) THEN
            WRITE (IOSDBG,250) OPTN(1:LENSTR(OPTN)),MAXDEC
            CALL SULINE (IOSDBG,1)
            ENDIF
         IPROPT=1
         GO TO 10
         ENDIF
C
C  CHECK FOR PUFORMAT OPTION
      IF (OPTN.EQ.'PUFORMAT') THEN
         IF (LLPAR.EQ.0) THEN
            CHK='PACKED'
            WRITE (LP,240) OPTN(1:LENSTR(OPTN)),CHK(1:LENSTR(CHK))
            CALL SUWRNS (LP,2,NUMWRN)
            GO TO 40
            ENDIF
         IF (LRPAR.GT.0) IRPFND=1
         IF (LRPAR.EQ.0) THEN
            WRITE (LP,220) NFLD
            CALL SULINE (LP,2)
            LRPAR=LENGTH+1
            ENDIF
         CALL UFPACK (MCHK,CHK,ISTRT,LLPAR+1,LRPAR-1,IERR)
40       IF (CHK.EQ.'PACKED'.OR.
     *       CHK.EQ.'FIXED'.OR.
     *       CHK.EQ.'ONEPERCARD') THEN
            ELSE
               WRITE (LP,280) OPTN(1:LENSTR(OPTN)),CHK
               CALL SUERRS (LP,2,NUMERR)
               GO TO 10
            ENDIF
         PUFORM=CHK
         IF (LDEBUG.GT.0) THEN
            WRITE (IOSDBG,260) OPTN(1:LENSTR(OPTN)),PUFORM
            CALL SULINE (IOSDBG,1)
            ENDIF
         IPROPT=1
         GO TO 10
         ENDIF
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  SET BASIN IDENTIFIER
      IF (LENGTH.GT.LEN(BASNID)) THEN
         WRITE (LP,290) LENGTH,CHAR(1:LENSTR(CHAR)),
     *      LEN(BASNID),LEN(BASNID)
         CALL SUWRNS (LP,2,NUMWRN)
         ENDIF
      CALL SUBSTR (CHAR,1,LEN(BASNID),BASNID,1)
      IALL=0
      IDLIST=1
C
C  CHECK IF TO PRINT OPTIONS IN EFFECT
50    IF (IPROPT.EQ.1) THEN
         WRITE (LP,310)
     *      'PUFORMAT',PUFORM(1:LENSTR(PUFORM)),
     *      'PUMAXDEC',MAXDEC,
     *      ' '
         CALL ULINE (LP,2)
         IPROPT=0
         ENDIF
C
      IPTRNX=0
      IPRERR=0
      NBASN=0
C
      IF (IALL.NE.1) GO TO 70
C
      IF (ISORT.GT.0) THEN
         INWFIL=0
         ISTATE(1)=0
         IPNTRS(1)=1
         NWORDS=5
         IPRMSG=1
         IPRERR=0
         CALL SURIDS ('BASN',ISORT,MAXSNW,ISTATE,NWORDS,ISRTBY,
     *      IPNTRS,NUMID,LARRAY,ARRAY,IPRMSG,IPRERR,IERR)
         IF (IERR.NE.0) THEN
            IF (IERR.EQ.2) THEN
               WRITE (LP,320)
               CALL SULINE (LP,2)
               GO TO 10
               ENDIF
            WRITE (LP,300)
            CALL SUWRNS (LP,2,NUMWRN)
            ISORT=0
            ENDIF
         ENDIF
C
60    BASNID=' '
C
70    IPTR=0
      IF (IALL.EQ.1) THEN
         IF (ISORT.EQ.0) IPTR=IPTRNX
         IF (ISORT.GT.0) IPTR=IPNTRS(NBASN+1)
         ENDIF
C
C  READ BASIN PARAMETERS
      CALL SRBASN (ARRAY,LARRAY,IVBASN,BASNID,DESCRP,
     *   SWORK(IWP3),SWORK(IWP4),MBPTS,NBPTS,
     *   AREA,CAREA,ELEV,XC,YC,MAPFLG,MATFLG,PID,TID,PXID,
     *   MSEGS,NSEGS,SWORK(IWP7),SWORK(IWP8),SWORK(IWP9),LFACTR,
     *   IPTR,IPTRNX,IPRERR,IERR)
      IF (IERR.GT.0) THEN
         IF (IERR.EQ.6.AND.IALL.EQ.1) GO TO 110
         IF (IALL.EQ.1) THEN
            WRITE (LP,330) BASNID
            CALL SULINE (LP,2)
            GO TO 110
            ENDIF
         IF (IERR.EQ.2) THEN
            WRITE (LP,350) BASNID
            CALL SUERRS (LP,2,NUMERR)
            ENDIF
         IF (IERR.NE.2) THEN
            WRITE (LP,340) BASNID
            CALL SUERRS (LP,2,NUMERR)
            ENDIF
         GO TO 10
         ENDIF
C
      IF (OUTPUT.EQ.'PRNT'.OR.OUTPUT.EQ.'BOTH') THEN
         ELSE
            GO TO 90
         ENDIF
C
      IF (SUMARY.EQ.'NO') GO TO 80
C
C  PRINT SUMARY
C
      IF (NBASN.EQ.0.AND.ISLEFT(10).GT.0) CALL SUPAGE
      IF (NBASN.EQ.0.OR.ISNWPG(LP).EQ.1) THEN
         WRITE (LP,360)
         CALL SULINE (LP,4)
         ENDIF
      VAL1=ELEV
      VAL2=AREA
      VAL3=CAREA
      IF (UNITS.EQ.'ENGL') THEN
         IF (ELEV.NE.UNDEF2)
     *      CALL UDUCNV ('M   ','FT  ',1,1,ELEV,VAL1,IERR)
         IF (AREA.NE.UNDEF2)
     *      CALL UDUCNV ('KM2 ','MI2 ',1,1,AREA,VAL2,IERR)
         CALL UDUCNV ('KM2 ','MI2 ',1,1,CAREA,VAL3,IERR)
         ENDIF
      CHAR1='**NONE**'
      CHAR2='**NONE**'
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,370) UNDEF1,VAL1,UNDEF2,VAL2
         CALL SULINE (IOSDBG,1)
         ENDIF
      IF (VAL1.NE.UNDEF1) CALL URELCH (VAL1,8,CHAR1,1,NFILL,IERR)
      IF (VAL2.NE.UNDEF2) CALL URELCH (VAL2,8,CHAR2,1,NFILL,IERR)
      CALL SBLLGD (CLON,CLAT,1,XC,YC,0,IERR)
      CALL SUBLID (PID,IERR)
      CALL SUBLID (PXID,IERR)
      CALL SUBLID (TID,IERR)
      IF (NSPACE.EQ.1) THEN
         WRITE (LP,180)
         CALL SULINE (LP,1)
         ENDIF
      NUM=NBASN+1
      WRITE (LP,380) NUM,BASNID,DESCRP,CLAT,CLON,CHAR1,CHAR2,VAL3,
     *   PID,TID,PXID
      CALL SULINE (LP,1)
      GO TO 90
C
80    CALL SPBASN (BASNID,DESCRP,SWORK(IWP3),SWORK(IWP4),NBPTS,
     *   AREA,ELEV,CAREA,
     *   SWORK(IWP7),SWORK(IWP8),SWORK(IWP9),NSEGS,XC,YC,
     *   MAPFLG,MATFLG,
     *   PID,TID,PXID,UNITS,
     *   LFACTR,SWORK(IWP1),SWORK(IWP2),SWORK(IWP5),SWORK(IWP6),
     *   IVBASN,IPLOT,SWORK(IWP10),IERR)
      IF (IERR.GT.0) THEN
         WRITE (LP,390) 'PRINT',BASNID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
90    IF (OUTPUT.EQ.'PNCH'.OR.OUTPUT.EQ.'BOTH') THEN
         CALL SCBASN (UNITS,BASNID,DESCRP,SWORK(IWP3),SWORK(IWP4),NBPTS,
     *      AREA,ELEV,IVBASN,MAXDEC,PUFORM,IERR)
         IF (IERR.GT.0) THEN
            WRITE (LP,390) 'PUNCH',BASNID
            CALL SUERRS (LP,2,NUMERR)
            GO TO 110
            ENDIF
         ENDIF
C
      NTBASN=NTBASN+1
      NTBPTS=NTBPTS+NBPTS
      NTSEGS=NTSEGS+NSEGS
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,*)
     *      ' NTBASN=',NTBASN,
     *      ' BASNID=',BASNID,
     *      ' NBPTS=',NBPTS,
     *      ' NSEGS=',NSEGS,
     *      ' '
         CALL SULINE (IOSDBG,1)
         ENDIF
C      
110   NBASN=NBASN+1
C
      IF (IALL.EQ.0) GO TO 120
      IF (ISORT.EQ.0.AND.IPTRNX.EQ.0) GO TO 120
      IF (ISORT.GT.0.AND.NBASN.EQ.NUMID) GO TO 120
         IPTR=IPTRNX
         IF (OUTPUT.NE.'PNCH'.AND.SUMARY.EQ.'NO') THEN
            WRITE (LP,190)
            CALL SULINE (LP,2)
            ENDIF
         GO TO 60
C
120   IF (IENDIN.EQ.0) GO TO 10
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  PRINT NUMBER OF BASINS PROCESSED
130   IF (NTBASN.GT.0) THEN
         WRITE (LP,400) NTBASN
         CALL SULINE (LP,2)
C     COMPUTE AVERAGE NUMBER OF BASIN BOUNDARY POINTS PER BASIN
         IAVG=NTBPTS/NTBASN
         WRITE (LP,425) 'BASIN BOUNDARY POINTS',IAVG
         CALL SULINE (LP,2)         
C     COMPUTE AVERAGE NUMBER OF HRAP LINE SEGMENTS PER BASIN
         IAVG=NTSEGS/NTBASN
         WRITE (LP,425) 'HRAP LINE SEGMENTS',IAVG
         CALL SULINE (LP,2)
         ELSE
            WRITE (LP,410)
            CALL SULINE (LP,2)
         ENDIF         
C
      IF (OUTPUT.EQ.'PRNT') GO TO 140
C
C  PRINT NUMBER OF CARD IMAGES OUTPUT
      NPUNCH=NPUCRD-LPUNCH
      IF (NPUNCH.GT.0) THEN
         WRITE (LP,430) NPUNCH
         CALL SULINE (LP,2)
         ENDIF
C
C  CHECK NUMBER OF ERRORS ENCOUNTERED
140   IF (NUMERR.GT.0) THEN
         WRITE (LP,420) NUMERR
         CALL SULINE (LP,2)
         ENDIF
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,440)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
150   FORMAT (' *** ENTER SMBASN')
160   FORMAT ('0*--> DUMP BASIN PARAMETERS')
170   FORMAT ('0*** WARNING - SORT BY ',A4,' NOT AVAILABLE. SORT ',
     *   'OPTION SET TO BY ID.')
180   FORMAT (' ')
190   FORMAT ('0')
200   FORMAT (' BLANK STRING FOUND IN FIELD ',I2)
210   FORMAT (' INPUT FIELD = ',A)
220   FORMAT ('0*** NOTE - RIGHT PARENTHESIS ASSUMED IN FIELD ',I2,
     *   '.')
230   FORMAT ('0*** NOTE - NO LEFT PARENTHESIS FOUND. ',A,' OPTION ',
     *   'SET TO ',I2,'.')
240   FORMAT ('0*** NOTE - NO LEFT PARENTHESIS FOUND. ',A,' OPTION ',
     *   'SET TO ',A,'.')
250   FORMAT (' ',A,' OPTION SET TO ',I4)
260   FORMAT (' ',A,' OPTION SET TO ',A)
270   FORMAT ('0*** ERROR - INVALID ',A,' VALUE : ',I2,'. VALID ',
     *   'VALUES ARE ',I2,' THROUGH ',I2,'.')
280   FORMAT ('0*** ERROR - INVALID ',A,' CODE : ',A)
290   FORMAT ('0*** WARNING - NUMBER OF CHARACTERS (',I2,') IN ',
     *   'BASIN IDENTIFIER ',A,' EXCEEDS ',I2,'. THE FIRST ',I2,
     *   ' CHARACTERS WILL BE USED.')
300   FORMAT ('0*** WARNING - SORTED LIST OF STATIONS NOT ',
     *   'SUCCESSFULLY OBTAINED. SORT OPTION CANCELLED.')
310   FORMAT ('0DUMP BASIN OPTIONS IN EFFECT : ',
     *   A,'=',A,3X,
     *   A,'=',I1,3X,
     *   A)
320   FORMAT ('0*** NOTE - NO BASINS ARE DEFINED.')
330   FORMAT ('0*** NOTE - ERROR OCCURRED READING BASN PARAMETERS ',
     *   'FOR BASIN ',A,'.')
340   FORMAT ('0*** ERROR - READING BASIN PARAMETERS FOR ',A,
     *   ' IDENTIFIER.')
350   FORMAT ('0*** ERROR - BASIN ',A,' NOT DEFINED.')
360   FORMAT ('0',3X,39X,'CENTROID',14X,3X,'SPECIFIED',3X,'COMPUTED',
     *      3(3X,'USED BY ') /
     *   T7,'BASN ID ',3X,'DESCRIPTION',12X,' LAT  ',2X,' LON  ',3X,
     *      'ELEV    ',3X,'AREA     ',3X,'AREA    ',3X,
     *      'MAP AREA',3X,'MAT AREA',3X,'MAPX AREA' /
     *   T7,8('-'),3X,20('-'),3X,2(6('-'),2X),1X,
     *      8('-'),3X,9('-'),3X,3(8('-'),3X),9('-'))
370   FORMAT (' UNDEF1=',F8.2,3X,'VAL1=',F8.2,3X,'UNDEF2=',F8.2,3X,
     *   'VAL2=',F8.2)
380   FORMAT (' ',I4,1X,A,3X,A,3X,2(F6.2,2X),1X,A8,3X,1X,A8,3X,
     *   F8.1,3X,3(A,3X))
390   FORMAT ('0*** ERROR - ',A,'ING PARAMETERS FOR BASIN ',A,'.')
400   FORMAT ('0*** NOTE - ',I4,' BASINS PROCESSED.')
410   FORMAT ('0*** NOTE - NO BASINS PROCESSED.')
420   FORMAT ('0*** NOTE - ',I3,' ERRORS ENCOUNTERED IN DUMP BASIN ',
     *   'COMMAND.')
425   FORMAT ('0*** NOTE - AVERAGE NUMBER OF ',A,' PER BASIN IS ',I4,
     *   '.')
430   FORMAT ('0*** NOTE - ',I4,' CARD IMAGES OUTPUT.')
440   FORMAT (' *** EXIT SMBASN')
C
      END