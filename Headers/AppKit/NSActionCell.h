// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Frank Le Grand 
// Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0 
// Date: 2013-08-09 14:24:48 +0000 
// ========== End of Keysight Technologies Notice ========== 
/* 
   NSActionCell.h

   Abstract cell for target/action paradigm

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: 1996
   
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

#ifndef _GNUstep_H_NSActionCell
#define _GNUstep_H_NSActionCell
#import <GNUstepBase/GSVersionMacros.h>

#import <AppKit/NSCell.h>

@interface NSActionCell : NSCell
{
  // Attributes
  NSInteger _tag;
  id _target;
  SEL _action;
  NSView *_control_view; 
}
@end

#endif // _GNUstep_H_NSActionCell
