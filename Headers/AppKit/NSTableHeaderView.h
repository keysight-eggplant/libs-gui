########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Frank Le Grand
# Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0
# Date: 2013-08-09 14:24:48 +0000
########## End of Keysight Technologies Notice ##########
/* 
   NSTableHeaderView.h

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author: Michael Hanni  <mhanni@sprintmail.com>
   Date: 1999

   Author: Nicola Pero <n.pero@mi.flashnet.it>
   Date: December 1999
   
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

#ifndef _GNUstep_H_NSTableHeaderView
#define _GNUstep_H_NSTableHeaderView

#import <Foundation/NSGeometry.h>
#import <AppKit/NSView.h>

@class NSTableView;

@interface NSTableHeaderView : NSView
{
  NSTableView *_tableView;
  int _resizedColumn;
}
/*
 * Setting the table view 
 */
- (void) setTableView: (NSTableView*)aTableView;
- (NSTableView*) tableView;
/*
 * Checking altered columns 
 */
- (NSInteger) draggedColumn;
- (CGFloat) draggedDistance; 
- (NSInteger) resizedColumn;
/*
 * Utility methods 
 */
- (NSInteger) columnAtPoint: (NSPoint)aPoint; 
- (NSRect) headerRectOfColumn: (NSInteger)columnIndex;  
@end
#endif
