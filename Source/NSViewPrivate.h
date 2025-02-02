// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Marcian Lytwyn 
// Commit ID: 0a05caf78a5bf717fe400e64b24d2aa93b6abf99 
// Date: 2012-10-20 00:06:53 +0000 
// ========== End of Keysight Technologies Notice ========== 
/* 
   NSViewPrivate.h

   The private methods of the NSView classes

   Copyright (C) 2010 Free Software Foundation, Inc.
   
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

#ifndef _GNUstep_H_NSViewPrivate
#define _GNUstep_H_NSViewPrivate

#import "AppKit/NSView.h"

@interface NSView (KeyViewLoop)
- (void) _setUpKeyViewLoopWithNextKeyView: (NSView *)nextKeyView;
- (void) _recursiveSetUpKeyViewLoopWithNextKeyView: (NSView *)nextKeyView;
@end

#endif // _GNUstep_H_NSViewPrivate
