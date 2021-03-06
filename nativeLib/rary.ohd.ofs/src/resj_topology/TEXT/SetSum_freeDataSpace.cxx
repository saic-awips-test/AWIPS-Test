//------------------------------------------------------------------------------
// SetSum :: freeDataSpace - delete dynamically allocated memory.
//------------------------------------------------------------------------------
// Copyright:	See the COPYRIGHT file.
//------------------------------------------------------------------------------
// Notes:
//
//------------------------------------------------------------------------------
// History:
// 
// 04 Mar 1998	Matthew J. Rutherford, Riverside Technology, inc
//					Created initial version.
//------------------------------------------------------------------------------
// Variables:	I/O	Description		
//
//
//------------------------------------------------------------------------------
#include "SetSum.h"

int SetSum :: freeDataSpace()
{
	if( _group ) {
		delete [] _group;
	}
	return( STATUS_SUCCESS );

/*  ==============  Statements containing RCS keywords:  */
/*  ===================================================  */


/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob81/ohd/ofs/src/resj_topology/RCS/SetSum_freeDataSpace.cxx,v $";
 static char rcs_id2[] = "$Id: SetSum_freeDataSpace.cxx,v 1.2 2006/10/26 15:34:48 hsu Exp $";}
/*  ===================================================  */

}
