C MEMBER SMPPPT
C----------------------------------------------------------------------
C
C DESC ROUTINE TO READ PROCESSED DATA BASE RECORDS.
C DESC PPINIT COMMAND :  @DUMP PPPTYPE
C
      SUBROUTINE SMPPPT (LARRAY,IARRAY,NFLD,ISTAT)
C
      REAL TYPCK(2)/4HPPPT,4HYPE /
      REAL*8 DMPOPT,DPCHK
      REAL*8 DPBLNK/8H        /
      REAL*8 XSORT/8HSORT    /,XNSORT/8HNOSORT  /
C
      DIMENSION IARRAY(LARRAY)
      DIMENSION IDENT(2),CHAR(5),CHK(5)
      DIMENSION TYPE(2)
      DIMENSION IWORK(6,1)
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/sworkx'
      INCLUDE 'pppcommon/ppxctl'
      INCLUDE 'pppcommon/ppdtdr'
C
      EQUIVALENCE (IWORK(1,1),SWORK(1))
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_dump/RCS/smpppt.f,v $
     . $',                                                             '
     .$Id: smpppt.f,v 1.1 1995/09/17 19:13:05 dws Exp $
     . $' /
C    ===================================================================
C
C
C
      IF (ISTRCE.GT.0) WRITE (IOSDBG,220)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG(4HDUMP)
C
      ISTAT=0
C
      ISTRT=-1
      LCHAR=5
      LCHK=5
      LDPCHK=2
      ILPFND=0
      IRPFND=0
      NUMFLD=0
      NUMERR=0
      ISORT=0
      DMPOPT=XNSORT
C
      NWORDS=6
      LAPARM=2000
      MAXID=0
      MAXID1=LSWORK/NWORDS/2
      MAXID2=LARRAY-LAPARM
      IF (MAXID1.LE.MAXID2) MAXID=MAXID1
      IF (MAXID2.LE.MAXID1) MAXID=MAXID2
      IF (LDEBUG.GT.0) WRITE (IOSDBG,230) MAXID
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK FIELDS FOR TYPE
C
10    CALL UFIELD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,LCHAR,
     *   CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
      IF (LDEBUG.GT.0)
     *  CALL UPRFLD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,LCHAR,
     *   CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
      IF (IERR.NE.1) GO TO 20
         IF (LDEBUG.GT.0) WRITE (IOSDBG,260) IFIELD
         IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
         GO TO 10
C
C  CHECK FOR END OF INPUT
20    IF (NFLD.EQ.-1) GO TO 210
C
CCHECK FOR COMMAND
      IF (LATSGN.EQ.1) GO TO 210
C
C  CHECK FOR PAIRED PARENTHESIS
      IF (ILPFND.GT.0.AND.IRPFND.EQ.0) GO TO 30
         GO TO 40
30    IF (NFLD.EQ.1) CALL SUPCRD
      WRITE (LP,270) NFLD
      CALL SULINE (LP,2)
      ILPFND=0
      IRPFND=0
40    IF (LLPAR.GT.0) ILPFND=1
      IF (LRPAR.GT.0) IRPFND=1
C
C  CHECK FOR PARENTHESIS IN FIELD
      IF (LLPAR.GT.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LLPAR-1,IERR)
      IF (LLPAR.EQ.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LENGTH,IERR)
C
      NUMFLD=NUMFLD+1
      IF (NUMFLD.GT.1) GO TO 90
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK OPTION
      CALL SUBSTR (CHK,1,8,TYPE,1)
      IF (TYPE(1).EQ.TYPCK(1).AND.TYPE(2).EQ.TYPCK(2)) GO TO 50
         WRITE (LP,240) CHK(1)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
50    IF (NFLD.EQ.1) CALL SUPCRD
C
C  CHECK DUMP TYPE
      IF (LLPAR.EQ.0) GO TO 80
      IF (LRPAR.GT.0) GO TO 60
         WRITE (LP,270) NFLD
         CALL SULINE (LP,2)
         LRPAR=LENGTH+1
60    CALL UFPACK (LDPCHK,DPCHK,ISTRT,LLPAR+1,LRPAR-1,IERR)
      IF (DPCHK.EQ.XSORT.OR.DPCHK.EQ.XNSORT) GO TO 70
         WRITE (LP,280) NFLD,DPCHK
         CALL SUERRS (LP,2,NUMERR)
         NUMERR=NUMERR+1
         GO TO 80
70    DMPOPT=DPCHK
      IF (LDEBUG.GT.0) WRITE (LP,300) DMPOPT
      IF (LDEBUG.GT.0) CALL SULINE (LP,1)
80    WRITE (LP,290) DMPOPT
      CALL SULINE (LP,2)
      IF (DMPOPT.EQ.XSORT) ISORT=1
      GO TO 10
C
C  CHECK FOR KEYWORD
90    CALL SUIDCK (4HDMPG,CHK,NFLD,0,IKEYWD,IRIDCK)
      IF (IRIDCK.EQ.2) GO TO 210
         IF (LDEBUG.GT.0) WRITE (IOSDBG,250) CHK
         IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
      IF (NFLD.EQ.1) CALL SUPCRD
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
      IF (NUMFLD.GT.1) GO TO 100
         WRITE (LP,350)
         CALL SULINE (LP,2)
C
100   CALL SUDOPN (1,4HPPP ,IERR)
      IF (IERR.GT.0) GO TO 210
C
C  SET PARAMETER TYPE AND FIND IN DIRECTORY
      CALL SUBSTR (CHK,1,4,ITYPE,1)
      IF (LDEBUG.GT.0) WRITE (IOSDBG,310) ITYPE
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
      DO 110 I=1,NMPTYP
         IF (IPDTDR(1,I).EQ.ITYPE) GO TO 120
110      CONTINUE
         WRITE (LP,320) ITYPE
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
C
C  READ ALL PARAMETER RECORDS OF SPECIFIED TYPE
120   IPTR=0
      NUMID=0
      IF (ISORT.EQ.1) GO TO 130
         WRITE (LP,370)
         CALL SULINE (LP,3)
130   CALL SUBSTR (DPBLNK,1,8,IDENT,1)
      CALL RPPREC (IDENT,ITYPE,IPTR,LAPARM,IARRAY,NFILL,IPTRNX,
     *   IERR)
      IF (IERR.EQ.0) GO TO 140
      IF (IERR.EQ.6) GO TO 10
      IF (IERR.EQ.2) GO TO 160
         CALL SRPPST (IDENT,ITYPE,IPTR,LAPARM,NFILL,IPTRNX,IERR)
         GO TO 150
140   NUMID=NUMID+1
      IF (ISORT.EQ.1) GO TO 145
         WRITE (LP,380) NUMID,IDENT,ITYPE,IPTR,IPTRNX,NFILL
         CALL SULINE (LP,1)
         GO TO 150
145   CALL SUBSTR (IDENT,1,8,IWORK(1,NUMID),1)
      IWORK(3,NUMID)=ITYPE
      IWORK(4,NUMID)=IPTR
      IWORK(5,NUMID)=IPTRNX
      IWORK(6,NUMID)=NFILL
C
150   IF (IPTRNX.EQ.0) GO TO 170
         IPTR=IPTRNX
         GO TO 130
C
C  NO RECORDS FOUND FOR TYPE
160   WRITE (LP,330) ITYPE
      CALL SULINE (LP,2)
      GO TO 10
C
170   IF (ISORT.EQ.0) GO TO 200
C
C  SORT LIST IF OPTION SPECIFIED
      ISPTR=0
      CALL SUSORT (NWORDS,NUMID,IWORK,IWORK,ISPTR,IERR)
C
      WRITE (LP,370)
      CALL SULINE (LP,3)
      DO 190 I=1,NUMID
         WRITE (LP,380) I,(IWORK(J,I),J=1,6)
         CALL SULINE (LP,1)
190      CONTINUE
C
200   WRITE (LP,390) NUMID
      CALL SULINE (LP,2)
      GO TO 10
C
210   IF (ISTRCE.GT.0) WRITE (IOSDBG,400)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
220   FORMAT (' *** ENTER SMPPPT')
230   FORMAT (' MAXID=',I5)
240   FORMAT ('0*** ERROR - IN SMPPPT - ',A4,' IS AN INVALID OPTION.')
250   FORMAT (' INPUT FIELD = ',5A4)
260   FORMAT (' NULL FIELD FOUND IN FIELD ',I2)
270   FORMAT ('0*** NOTE - RIGHT PARENTHESES ASSUMED IN FIELD ',
     *   I2,'.')
280   FORMAT ('0*** ERROR - CARD FIELD ',I2,' HAS AN INVALID DUMP ',
     *   'PPPTYPE OPTION : ',A8)
290   FORMAT ('0DUMP PPPTYPE OPTION IN EFFECT = ',A8)
300   FORMAT (' DUMP PPPTYPE OPTION IS ',A8)
310   FORMAT (' TYPE=',A4)
320   FORMAT ('0*** ERROR - PARAMETRIC DATA TYPE ',A4,' NOT FOUND ',
     *   'IN DATA BASE.')
330   FORMAT ('0*** NOTE - NO PARAMETER RECORDS FOUND FOR TYPE ',A4,'.')
340   FORMAT ('0*** ERROR - IN SMPPPT - MAXIMUM NUMBER OF IDENTIFIERS ',
     *   'THAT CAN BE PROCESSED (',I5,') EXCEEDED.')
350   FORMAT ('0- DUMP OF PARAMETRIC DATA BASE RECORDS -')
360   FORMAT (1H0)
370   FORMAT (1H0,T7,'IDENTIFIER  TYPE  IPTR   IPTRNX  NFILL'/
     *        T7,'----------  ----  -----  ------  -----')
380   FORMAT (1X,I4,T7,2A4,4X,A4,2X,I5,2X,I6,2X,I5)
390    FORMAT ('0*** NOTE - ',I5,' RECORDS RECORDS PROCESSED.')
400   FORMAT (' *** EXIT SMPPPT')
C
      END