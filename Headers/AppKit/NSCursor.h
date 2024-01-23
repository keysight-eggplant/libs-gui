########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: a1d62943a6153190d2403fd79327deaa45268775
# Date: 2016-10-04 22:11:05 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: de5f907dcae55a0a0a8af1653c5e6c379ab2a4bc
# Date: 2015-07-08 22:21:16 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: c1baac77bed430e4b2cd0ae94d19eb55fdc6b85f
# Date: 2013-08-23 16:31:38 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 94976243ddfdbeae7fa8abb79f0f24288e838638
# Date: 2013-08-23 16:09:17 +0000
########## End of Keysight Technologies Notice ##########
/* 
   NSCursor.h

   Holds an image to use as a cursor

   Copyright (C) 1996,1999 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: 1996
   
   This file is part of the GNUstep GUI Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; see the file COPYING.LIB.
   If not, write to the Free Software Foundation,
   51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.
*/ 

#ifndef _GNUstep_H_NSCursor
#define _GNUstep_H_NSCursor
#import <GNUstepBase/GSVersionMacros.h>

#import <Foundation/NSGeometry.h>
#import <Foundation/NSObject.h>

@class NSImage;
@class NSEvent;
@class NSColor;

@interface NSCursor : NSObject <NSCoding>
{
  NSImage	*_cursor_image;
  NSPoint	_hot_spot;
  struct GSCursorFlagsType {
    unsigned int is_set_on_mouse_entered: 1;
    unsigned int is_set_on_mouse_exited: 1;
    unsigned int type: 5;
    unsigned int reserved: 25;
  } _cursor_flags;
  void		*_cid;
}

// Method needed on Windows to handle the cursor.
#ifdef WIN32
+ (NSUInteger) count;
#endif

/*
 * Initializing a New NSCursor Object
 */
#if OS_API_VERSION(GS_API_NONE, GS_API_NONE)
- (id) initWithImage: (NSImage *)newImage;
#endif
- (id) initWithImage: (NSImage *)newImage
	     hotSpot: (NSPoint)hotSpot;


#if OS_API_VERSION(GS_API_MACOSX, GS_API_LATEST)
- (id)initWithImage:(NSImage *)newImage 
foregroundColorHint:(NSColor *)fg 
backgroundColorHint:(NSColor *)bg
	    hotSpot:(NSPoint)hotSpot;
#endif

/*
 * Defining the Cursor
 */
- (NSPoint) hotSpot;
- (NSImage*) image;
#if OS_API_VERSION(GS_API_NONE, GS_API_NONE)
- (void) setHotSpot: (NSPoint)spot;
- (void) setImage: (NSImage *)newImage;
#endif

/*
 * Setting the Cursor
 */
+ (void) hide;
+ (void) pop;
+ (void) setHiddenUntilMouseMoves: (BOOL)flag;
+ (BOOL) isHiddenUntilMouseMoves;
+ (void) unhide;
- (BOOL) isSetOnMouseEntered;
- (BOOL) isSetOnMouseExited;
- (void) mouseEntered: (NSEvent*)theEvent;
- (void) mouseExited: (NSEvent*)theEvent;
- (void) pop;
- (void) push;
- (void) set;
- (void) setOnMouseEntered: (BOOL)flag;
- (void) setOnMouseExited: (BOOL)flag;
 
/*
 * Getting the Cursor
 */
+ (NSCursor*) arrowCursor;
+ (NSCursor*) currentCursor;
+ (NSCursor*) IBeamCursor;

#if OS_API_VERSION(GS_API_NONE, GS_API_NONE)
+ (NSCursor*) greenArrowCursor;
#endif

#if OS_API_VERSION(MAC_OS_X_VERSION_10_3, GS_API_LATEST)
+ (NSCursor*) closedHandCursor;
+ (NSCursor*) crosshairCursor;
+ (NSCursor*) disappearingItemCursor;
+ (NSCursor*) openHandCursor;
+ (NSCursor*) pointingHandCursor;
+ (NSCursor*) resizeDownCursor;
+ (NSCursor*) resizeLeftCursor;
+ (NSCursor*) resizeLeftRightCursor;
+ (NSCursor*) resizeRightCursor;
+ (NSCursor*) resizeUpCursor;
+ (NSCursor*) resizeUpDownCursor;
+ (NSCursor*) resizeNWSECursor; // Testplant-MAL-10042016
+ (NSCursor*) resizeNESWCursor; // Testplant-MAL-10042016
#endif

#if OS_API_VERSION(MAC_OS_X_VERSION_10_6, GS_API_LATEST)
+ (NSCursor*) currentSystemCursor;

+ (NSCursor*) contextualMenuCursor;
+ (NSCursor*) dragCopyCursor;
+ (NSCursor*) dragLinkCursor;
+ (NSCursor*) operationNotAllowedCursor;
#endif

@end

/* Cursor types */
typedef enum {
  GSArrowCursor = 0,
  GSIBeamCursor,
  GSDragLinkCursor,
  GSOperationNotAllowedCursor,
  GSDragCopyCursor = 5,
  GSClosedHandCursor = 11,
  GSOpenHandCursor,
  GSPointingHandCursor,
  GSResizeLeftCursor = 17,
  GSResizeRightCursor,
  GSResizeLeftRightCursor,
  GSCrosshairCursor,
  GSResizeUpCursor,
  GSResizeDownCursor,
  GSResizeUpDownCursor,
  GSContextualMenuCursor,
  GSDisappearingItemCursor, // Testplant-MAL-10042016
  GSResizeNWSECursor,       // Testplant-MAL-10042016
  GSResizeNESWCursor        // Testplant-MAL-10042016
} GSCursorTypes;

#endif /* _GNUstep_H_NSCursor */
