// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Frank Le Grand 
// Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0 
// Date: 2013-08-09 14:24:48 +0000 
// ========== End of Keysight Technologies Notice ========== 
/* NSSegmentedControl.h
 *
 * Copyright (C) 2007 Free Software Foundation, Inc.
 *
 * Author:	Gregory John Casamento <greg_casamento@yahoo.com>
 * Date:	2007
 * 
 * This file is part of GNUstep.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02111 
 * USA.
 */

#ifndef _GNUstep_H_NSSegmentedControl
#define _GNUstep_H_NSSegmentedControl

#import <AppKit/NSControl.h>

#if OS_API_VERSION(GS_API_MACOSX, GS_API_LATEST)
typedef enum _NSSegmentStyle {
  NSSegmentStyleAutomatic = 0,
  NSSegmentStyleRounded = 1,
  NSSegmentStyleTexturedRounded = 2,
  NSSegmentStyleRoundRect = 3,
  NSSegmentStyleTexturedSquare = 4,
  NSSegmentStyleCapsule = 5,
  NSSegmentStyleSmallSquare = 6
} NSSegmentStyle;
#endif

@interface NSSegmentedControl : NSControl

// Specifying number of segments...
- (void) setSegmentCount: (NSInteger)count;
- (NSInteger) segmentCount; 

// Specifying selected segment...
- (void) setSelectedSegment: (NSInteger)segment;
- (NSInteger) selectedSegment;
- (void) selectSegmentWithTag: (NSInteger)tag;

// Working with individual segments...
- (void) setWidth: (CGFloat)width forSegment: (NSInteger)segment;
- (CGFloat) widthForSegment: (NSInteger)segment;
- (void) setImage: (NSImage *)image forSegment: (NSInteger)segment;
- (NSImage *) imageForSegment: (NSInteger)segment;
- (void) setLabel: (NSString *)label forSegment: (NSInteger)segment;
- (NSString *) labelForSegment: (NSInteger)segment;
- (void) setMenu: (NSMenu *)menu forSegment: (NSInteger)segment;
- (NSMenu *) menuForSegment: (NSInteger)segment;
- (void) setSelected: (BOOL)flag forSegment: (NSInteger)segment;
- (BOOL) isSelectedForSegment: (NSInteger)segment;
- (void) setEnabled: (BOOL)flag forSegment: (NSInteger)segment;
- (BOOL) isEnabledForSegment: (NSInteger)segment;

// Setting the style of the segments
#if OS_API_VERSION(GS_API_MACOSX, GS_API_LATEST)
- (void)setSegmentStyle:(NSSegmentStyle)style;
- (NSSegmentStyle)segmentStyle;
#endif

@end
#endif
