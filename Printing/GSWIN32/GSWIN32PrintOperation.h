// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Marcian Lytwyn 
// Commit ID: beccb8503d37dc9cf8c9d7c19bc1d308d39c3c8e 
// Date: 2015-06-26 00:00:53 +0000 
// ========== End of Keysight Technologies Notice ========== 
/** <title>GSWIN32PrintOperation</title>

   <abstract>Controls generation of EPS, PDF or PS print jobs.</abstract>

   Copyright (C) 1996,2004 Free Software Foundation, Inc.
   
   Author:  Gregory Casamento <greg.casamento@gmail.com>
   Date: 2014
   Author:  Scott Christley <scottc@net-community.com>
   Date: 1996
   Author: Fred Kiefer <FredKiefer@gmx.de>
   Date: November 2000
   Updated to new specification
   Author: Adam Fedor <fedor@gnu.org>
   Date: Oct 2001
   Modified for Printing Backend Support
   Author: Chad Hardin <cehardin@mac.com>
   Date: June 2004

   This file is part of the GNUstep GUI Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the 
   Free Software Foundation, 51 Franklin Street, Fifth Floor, 
   Boston, MA 02110-1301, USA.
*/ 

#ifndef _GNUstep_H_GSWIN32PrintOperation
#define _GNUstep_H_GSWIN32PrintOperation

#import "GNUstepGUI/GSPrintOperation.h"

//GSPrintOperation is subclasses of GSPrintOperation, NOT NSPrintOperation.
//NSPrintOperation does a lot of work that is pretty generic.
//GSPrintOperation contains the method that does the actual
//spooling.  A future Win32 printing printing bundle
//will likely have to implement much more
@interface GSWIN32PrintOperation : GSPrintOperation
{
}


@end

#endif // _GNUstep_H_GSWIN32PrintOperation
