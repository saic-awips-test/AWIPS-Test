##
# This software was developed and / or modified by Raytheon Company,
# pursuant to Contract DG133W-05-CQ-1067 with the US Government.
# 
# U.S. EXPORT CONTROLLED TECHNICAL DATA
# This software product contains export-restricted data whose
# export/transfer/disclosure is restricted by U.S. law. Dissemination
# to non-U.S. persons whether in the United States or abroad requires
# an export license or other authorization.
# 
# Contractor Name:        Raytheon Company
# Contractor Address:     6825 Pine Street, Suite 340
#                         Mail Stop B8
#                         Omaha, NE 68106
#                         402.291.0100
# 
# See the AWIPS II Master Rights File ("Master Rights File.pdf") for
# further licensing information.
##
#
#    Name:
#       avnxs.py
#       GFS1-NHD:A7832.0000-SCRIPT;1.9
#
#    Status:
#       DELIVERED
#    
#    History:
#       Revision 1.9 (DELIVERED)
#         Created:  29-NOV-2007 09:54:12      OBERFIEL
#           Removed obsolete directory search path
#       
#       Revision 1.8 (DELIVERED)
#         Created:  28-JUL-2005 18:10:47      TROJAN
#           spr 6951
#       
#       Revision 1.7 (APPROVED)
#         Created:  07-JUL-2005 12:05:45      TROJAN
#           spr 6885
#       
#       Revision 1.6 (DELIVERED)
#         Created:  07-MAY-2005 11:42:21      OBERFIEL
#           Added Item Header Block
#       
#       Revision 1.5 (DELIVERED)
#         Created:  11-MAR-2005 15:55:30      TROJAN
#           spr 6717
#       
#       Revision 1.4 (DELIVERED)
#         Created:  23-JAN-2005 18:42:22      TROJAN
#           spr 6604
#       
#       Revision 1.3 (APPROVED)
#         Created:  30-SEP-2004 18:56:01      TROJAN
#           stdr 874
#       
#       Revision 1.2 (APPROVED)
#         Created:  19-AUG-2004 20:27:58      OBERFIEL
#           Code change
#       
#       Revision 1.1 (APPROVED)
#         Created:  01-JUL-2004 14:47:07      OBERFIEL
#           date and time created -2147483647/-2147483648/-2147481748
#           -2147483648:-2147483648:-2147483648 by oberfiel
#
#    Change Document History:
#       1:
#       	Change Document:   GFS1-NHD_SPR_7351
#       	Action Date:       19-MAR-2008 08:14:54
#       	Relationship Type: In Response to
#       	Status:           CLOSED
#       	Title:             AvnFPS: Remove dependency on shared library, climmodule.so
#       
#
#    Purpose:
#	A driver for AvnFPS transmission server

import getopt, os, socket, sys
TopDir = os.environ['TOP_DIR']
sys.path = sys.path[1:]
sys.path.extend([os.path.join(TopDir, dir) for dir in \
    ['sitepy', 'py', 'toolpy']])
import AvnUtils

def main():
    me = os.path.basename(sys.argv[0])
    try:
        opts, pargs = getopt.getopt(sys.argv[1:], 'dn:')
        kwds = dict(opts)
        args = [me] + sys.argv[1:]
    except IndexError:
        print 'Usage: %s [-d] [-n host]' % os.path.basename(sys.argv[0])
        raise SystemExit
    pids = AvnUtils.isRunning(args)
    if pids:
        print '%s is running, pids=%s. Terminating' % (args[0], str(pids))
        raise SystemExit
    if '-d' in kwds:
        del kwds['-d']
    else:
        AvnUtils.daemonize()
    os.chdir(TopDir)
    try:
        import Startup
        import XmitServ
        svr = XmitServ.XmitServer(kwds.get('-n', socket.gethostname()))
        svr.run()
    except SystemExit:
        raise
    except Exception:
        import logging
        logging.getLogger(__name__).exception('Uncaught exception')

if __name__ == '__main__':
    main()
