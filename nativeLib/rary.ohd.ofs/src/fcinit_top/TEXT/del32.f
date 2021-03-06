C  =====================================================================
C  PGM:  DEL32 (OLDP,MOLDP,P,MP)
C
C   IN: OLDP   .... OLD PARAMETER ARRAY FOR SEGMENT
C   IN: MOLDP  .... MAXIMUM SIZE OF OLDP
C   IN: P      .... PARAMETER ARRAY FOR SEGMENT
C   IN: MP     .... MAXIMUM SIZE OF P
C  =====================================================================
C
      SUBROUTINE DEL32 (OLDP,MOLDP,P,MP)
C
C  THIS ROUTINE CHECKS THE OLD AND NEW SEGMENT DEFINTION FOR FFG 
C  OPERATIONS WHOSE PARAMETERS IN THE PPPDB NEED TO BE DELETED BECAUSE
C  THEY ARE NOT USED IN THE NEW SEGMENT DEFINITION.
C
C  WHEN AN OLD SEGMENT IS DELETED, THIS ROUTINE CHECKS FOR ANY FFG
C  OPERATIONS AND DELETES THE CORRESPONDING FFG PARAMETERS IN THE PPPDB
C
C  POSSIBLE SCENARIOS:
C     1.  SAME FFGID IN OLD AND NEW SEGMENTS
C     2.  DIFFERENT FFGID IN OLD AND NEW
C     3.  NEW FFGID IN NEW
C     4.  NO FFGID IN NEW
C     5.  DELETE OLD SEGMENT
C
C  INITIALLY WRITTEN BY -- TIM SWEENEY - HRL - MAY 1997
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/where'
C
      CHARACTER*4 PTYPE
      CHARACTER*8 RTNNAM,OPNOLD,OFFGID,NFFGID,FFGID
      DIMENSION OLDP(MOLDP),P(MP)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_top/RCS/del32.f,v $
     . $',                                                             '
     .$Id: del32.f,v 1.3 2002/02/11 20:23:47 dws Exp $
     . $' /
C    ===================================================================
C
C
      RTNNAM='DEL32'
C
      IF (ITRACE.GE.1) WRITE (IODBUG,*) 'ENTER ',RTNNAM
C
      IOPNUM=0
      CALL FSTWHR (RTNNAM,IOPNUM,OPNOLD,IOLDOP)
C
      IBUG=IFBUG('SEGD')
C
      PTYPE='FFG'
      NOP=32
      IOPFF=1
C
C  FIND FFG OPERATION IN OLD SEGMENT
10    CALL FSERCH (NOP,OFFGID,IOPFF,OLDP,MOLDP)
      IF (IBUG.GT.0) WRITE (IODBUG,20) NOP,OFFGID,IOPFF
20    FORMAT(5X,'NOP=',I2,'  OFFGID=',A,'  IOPFF=',I4)
      IF (IOPFF.EQ.0) GO TO 120
      IF (MP.LE.10) GO TO 50
C
C  FIND FFG OPERATION IN NEW SEGMENT
      NOPFF=1
30    CALL FSERCH (NOP,NFFGID,NOPFF,P,MP)
      IF (IBUG.GT.0) WRITE (IODBUG,40) NOP,NFFGID,NOPFF
40    FORMAT(5X,'NOP=',I2,'  NFFGID=',A,'  NOPFF=',I4)
      IF (NOPFF.EQ.0) GO TO 50
C
C  CHECK IDS
      IF (OFFGID.EQ.NFFGID) GO TO 10
      GO TO 30
C
50    CALL UMEMOV (OLDP(IOPFF+1),FFGID,2)
C
C  CHECK IF FFG AREA IDENTIFIER USED BY ANOTHER SEGMENT 
      CALL CHK32 (ISEG,FFGID,ISTAT)
      IF (ISTAT.NE.0) THEN
         WRITE (IPR,55) FFGID
55    FORMAT ('0**WARNING** FFG AREA IDENTIFIER ',A,' IS USED BY ',
     *   'ANOTHER SEGMENT. FFG PARAMETER RECORD WILL NOT BE DELETED.')
         CALL WARN
         GO TO 120
         ENDIF      
C
C  DELETE OLD PARAMETER RECORD
      CALL WPPDEL (FFGID,PTYPE,ISTAT)
      IF (ISTAT.EQ.0) THEN
         WRITE (IPR,60) PTYPE,FFGID
60    FORMAT ('0**NOTE** ',A,' PARAMETER RECORD DELETED FOR ',
     1 'IDENTIFIER ',A,'.')
         CALL WPPPCO (ISTAT)
         IF (ISTAT.EQ.0) THEN
            WRITE (IPR,70)
70    FORMAT ('0**NOTE** PREPROCESSOR PARAMETRIC DATA BASE ',
     1 'CONTROL RECORDS SUCCESSFULLY WRITTEN.')
            ELSE
               WRITE (IPR,80)
80    FORMAT('0**ERROR** WRITING PREPROCESSOR PARAMETRIC ',
     1 'DATA BASE CONTROL RECORDS.')
               CALL ERROR
               ENDIF
         GO TO 10
         ENDIF
      IF (ISTAT.EQ.1.OR.ISTAT.EQ.2) THEN
         WRITE (IPR,90) PTYPE,FFGID,ISTAT
90    FORMAT ('0**WARNING** ',A,' PARAMETER RECORD NOT FOUND (1) OR ',
     1 'NOT DEFINED IN FILE (2) FOR ID ',A /
     2  17X,'WHILE DELETING PREPROCESSOR PARAMETRIC RECORD. ISTAT=',I4)
         CALL WARN
         GO TO 10
         ENDIF
      IF (ISTAT.EQ.4) THEN
         WRITE (IPR,100) ISTAT
100   FORMAT ('0**WARNING** IDENTIFIER AND TYPE MISMATCH ',
     1 'BETWEEN INDEX AND PARAMETRIC RECORD. ISTAT=',I4)
         CALL WARN
         GO TO 10
         ENDIF
      WRITE (IPR,110) ISTAT
110   FORMAT ('0**ERROR** WHILE DELETING FFG PREPROCESSOR ',
     1  'PARAMETRIC RECORD.WPPDEL ISTAT=',I4)
      CALL ERROR
      GO TO 10
C
120   CALL FSTWHR (OPNOLD,IOLDOP,OPNOLD,IOLDOP)
C
      IF (ITRACE.GE.1) WRITE (IODBUG,*) 'EXIT ',RTNNAM
C
      RETURN
C
      END
