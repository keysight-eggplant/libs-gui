// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Marcian Lytwyn 
// Commit ID: 0b03717fe9d68fe488ceed1e0a90144048e22ee4 
// Date: 2015-06-26 16:47:48 +0000 
// ========== End of Keysight Technologies Notice ========== 
/** <title>GSTitleView</title>

   Copyright (C) 2003 Free Software Foundation, Inc.

   Author: Serg Stoyan <stoyan@on.com.ua>
   Date:   Mar 2003
   
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

#import <Foundation/NSDebug.h>
#import <Foundation/NSNotification.h>
#import <Foundation/NSRunLoop.h>

#import "AppKit/NSApplication.h"
#import "AppKit/NSAttributedString.h"
#import "AppKit/NSButton.h"
#import "AppKit/NSColor.h"
#import "AppKit/NSEvent.h"
#import "AppKit/NSGraphics.h"
#import "AppKit/NSImage.h"
#import "AppKit/NSMenu.h"
#import "AppKit/NSMenuView.h"
#import "AppKit/NSPanel.h"
#import "AppKit/NSStringDrawing.h"
#import "AppKit/NSView.h"
#import "AppKit/NSWindow.h"

#import "GNUstepGUI/GSTitleView.h"
#import "GNUstepGUI/GSTheme.h"

@implementation GSTitleView

// ============================================================================
// ==== Initialization & deallocation
// ============================================================================

+ (float) height
{
  return [NSMenuView menuBarHeight] + 1;
}

- (id) init
{
  self = [super init];
  if (!self)
    return nil;

  _owner = nil;
  _ownedByMenu = NO;
  _isKeyWindow = NO;
  _isMainWindow = NO;
  _isActiveApplication = NO;

  [self setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin];

  textAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
    [NSFont boldSystemFontOfSize: 0], NSFontAttributeName,
    [NSColor blackColor], NSForegroundColorAttributeName, nil];

  titleColor = RETAIN ([NSColor lightGrayColor]);

  return self;
}

- (id) initWithOwner: (id)owner
{
  self = [self init];
  if (!self)
    return nil;

  [self setOwner: owner];

  return self;
}

- (void) setOwner: (id)owner
{
  NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];

  if ([owner isKindOfClass: [NSWindow class]])
    {
      NSDebugLLog(@"GSTitleView", @"owner is NSWindow or NSPanel");
      _owner = owner;
      _ownedByMenu = NO;

      [self setFrame: 
        NSMakeRect (-1, [_owner frame].size.height - [GSTitleView height]-40,
                    [_owner frame].size.width+2, [GSTitleView height])];

      if ([_owner styleMask] & NSClosableWindowMask)
        {
          [self addCloseButtonWithAction: @selector(performClose:)];
        }
      if ([_owner styleMask] & NSMiniaturizableWindowMask)
        {
          [self addMiniaturizeButtonWithAction: @selector(performMiniaturize:)];
        }

      // NSWindow observers
      [theCenter addObserver: self
                    selector: @selector(windowBecomeKey:)
                        name: NSWindowDidBecomeKeyNotification
                      object: _owner];
      [theCenter addObserver: self
                    selector: @selector(windowResignKey:)
                        name: NSWindowDidResignKeyNotification
                      object: _owner];
      [theCenter addObserver: self
                    selector: @selector(windowBecomeMain:)
                        name: NSWindowDidBecomeMainNotification
                      object: _owner];
      [theCenter addObserver: self
                    selector: @selector(windowResignMain:)
                        name: NSWindowDidResignMainNotification
                      object: _owner];

      // NSApplication observers
      [theCenter addObserver: self
                    selector: @selector(applicationBecomeActive:)
                        name: NSApplicationWillBecomeActiveNotification
                      object: NSApp];
      [theCenter addObserver: self
                    selector: @selector(applicationResignActive:)
                        name: NSApplicationWillResignActiveNotification
                      object: NSApp];
    }
  else if ([owner isKindOfClass: [NSMenu class]])
    {
      NSColor *textColor;
      GSTheme *theme;

      NSDebugLLog(@"GSTitleView", @"owner is NSMenu");
      _owner = owner;
      _ownedByMenu = YES;
      theme = [GSTheme theme];

      RELEASE (titleColor);
      titleColor = RETAIN ([theme colorNamed: @"GSMenuBar" state: GSThemeNormalState]);
      if (titleColor == nil)
	{
	  titleColor = RETAIN ([NSColor blackColor]);
	}

      textColor = [theme colorNamed: @"GSMenuBarTitle" state: GSThemeNormalState];
      if (textColor == nil)
	{
	  textColor = [NSColor whiteColor];
	}
      [textAttributes setObject: textColor 
		      forKey: NSForegroundColorAttributeName];
    }
  else
    {
      NSDebugLLog(@"GSTitleView", 
		  @"%@ owner is not NSMenu or NSWindow or NSPanel",
		  [owner className]);
      return;
    }
}

- (id) owner
{
  return _owner;
}

- (void) dealloc
{
  if (!_ownedByMenu)
    {
      [[NSNotificationCenter defaultCenter] removeObserver: self];
    }

  RELEASE(textAttributes);
  RELEASE(titleColor);
  [[GSTheme theme] setName: nil forElement: [closeButton cell] temporary: NO];
  TEST_RELEASE(closeButton);
  TEST_RELEASE(miniaturizeButton);

  [super dealloc];
}

// ============================================================================
// ==== Drawing
// ============================================================================

- (NSSize) titleSize
{
  return [[_owner title] sizeWithAttributes: textAttributes];
}

- (void) drawRect: (NSRect)rect
{
  NSRect workRect = [[GSTheme theme] drawMenuTitleBackground: self
						  withBounds: [self bounds]
						    withClip: rect];
  // Draw the title
  NSSize titleSize = [self titleSize];
      workRect.origin.x += 4;

  workRect.origin.y = NSMidY (workRect) - titleSize.height / 2;
  workRect.size.height = titleSize.height;
  [[_owner title] drawInRect: workRect  withAttributes: textAttributes];
}

// ============================================================================
// ==== Mouse actions
// ============================================================================

- (BOOL) acceptsFirstMouse: (NSEvent *)theEvent
{
  return YES;
} 
 
- (void) mouseDown: (NSEvent*)theEvent
{
  NSPoint  lastLocation;
  NSPoint  location;
  NSUInteger eventMask = NSLeftMouseUpMask | NSPeriodicMask;
  BOOL     done = NO;
  BOOL	   moved = NO;
  NSDate   *theDistantFuture = [NSDate distantFuture];
  NSPoint  startWindowOrigin;
  NSPoint  endWindowOrigin;

  NSDebugLLog (@"NSMenu", @"Mouse down in title!");

  // Remember start position of window
  startWindowOrigin = [_window frame].origin;

  // Remember start location of cursor in window
  lastLocation = [theEvent locationInWindow];

  [_window _captureMouse: nil];
  
  [NSEvent startPeriodicEventsAfterDelay: 0.02 withPeriod: 0.02];

  while (!done)
    {
      theEvent = [NSApp nextEventMatchingMask: eventMask
                                    untilDate: theDistantFuture
                                       inMode: NSEventTrackingRunLoopMode
                                      dequeue: YES];
      switch ([theEvent type])
        {
        case NSRightMouseUp:
        case NSLeftMouseUp: 
          done = YES; 
          [_window _releaseMouse: nil];
          break;
        case NSPeriodic:
          location = [_window mouseLocationOutsideOfEventStream];
          if (NSEqualPoints(location, lastLocation) == NO)
            {
              NSPoint origin = [_window frame].origin;

              moved = YES;
              origin.x += (location.x - lastLocation.x);
              origin.y += (location.y - lastLocation.y);
              if (_ownedByMenu)
                {
                  [_owner nestedSetFrameOrigin: origin];
                }
              else
                {
                  [_owner setFrameOrigin: origin];
                }
            }
          break;

        default: 
          break;
        }
    }

  // Make menu torn off
  if (_ownedByMenu && ![_owner isTornOff] && [_owner supermenu])
    {
      endWindowOrigin = [_window frame].origin;
      if ((startWindowOrigin.x != endWindowOrigin.x 
	   || startWindowOrigin.y != endWindowOrigin.y))
        {
          [_owner setTornOff: YES];
        }
    }

  [NSEvent stopPeriodicEvents];

  if (moved == YES)
    {
      // Let everything know the window has moved.
      [[NSNotificationCenter defaultCenter]
          postNotificationName: NSWindowDidMoveNotification object: _window];
    }
}

// We do not need app menu over menu
- (void) rightMouseDown: (NSEvent*)theEvent
{
}

// We do not want to popup menus in this menu.
- (NSMenu *) menuForEvent: (NSEvent*) theEvent
{
  return nil;
}

// ============================================================================
// ==== NSWindow & NSApplication notifications
// ============================================================================

- (void) applicationBecomeActive: (NSNotification *)notification
{
  _isActiveApplication = YES;
}

- (void) applicationResignActive: (NSNotification *)notification
{
  _isActiveApplication = NO;
  RELEASE (titleColor);
  titleColor = RETAIN ([NSColor lightGrayColor]);
  [textAttributes setObject: [NSColor blackColor] 
                     forKey: NSForegroundColorAttributeName];
  [self setNeedsDisplay: YES];
}

- (void) windowBecomeKey: (NSNotification *)notification
{
  _isKeyWindow = YES;
  RELEASE (titleColor);
  titleColor = RETAIN ([NSColor blackColor]);
  [textAttributes setObject: [NSColor whiteColor] 
                     forKey: NSForegroundColorAttributeName];

  [self setNeedsDisplay: YES];
}

- (void) windowResignKey: (NSNotification *)notification
{
  _isKeyWindow = NO;
  RELEASE (titleColor);
  if (_isActiveApplication && _isMainWindow)
    {
      titleColor = RETAIN ([NSColor darkGrayColor]);
      [textAttributes setObject: [NSColor whiteColor] 
                         forKey: NSForegroundColorAttributeName];
    }
  else
    {
      titleColor = RETAIN ([NSColor lightGrayColor]);
      [textAttributes setObject: [NSColor blackColor] 
                         forKey: NSForegroundColorAttributeName];
    }
  [self setNeedsDisplay: YES];
}

- (void) windowBecomeMain: (NSNotification *)notification 
{
  _isMainWindow = YES;
}

- (void) windowResignMain: (NSNotification *)notification 
{
  _isMainWindow = NO;
}

// ============================================================================
// ==== Buttons
// ============================================================================

- (void) addCloseButtonWithAction: (SEL)closeAction
{
  if (closeButton == nil)
    {
      NSSize viewSize;
      NSSize buttonSize;
      
      [[GSTheme theme] setName: nil forElement: [closeButton cell] temporary: NO];
      ASSIGN(closeButton, 
             [NSWindow standardWindowButton: 
                           NSWindowCloseButton 
                       forStyleMask: 
                           NSTitledWindowMask | NSClosableWindowMask 
                       | NSMiniaturizableWindowMask]);
      [[GSTheme theme] setName: @"GSMenuCloseButton" forElement: [closeButton cell] temporary: NO];

      [closeButton setTarget: _owner];
      [closeButton setAction: closeAction];

      viewSize = [self frame].size;
      buttonSize = [[closeButton image] size];
      buttonSize = NSMakeSize(buttonSize.width + 3, buttonSize.height + 3);

      // Update location
      [closeButton setFrame:
        NSMakeRect(viewSize.width - buttonSize.width - 4,
                   (viewSize.height - buttonSize.height) / 2,
                   buttonSize.width, buttonSize.height)];

      [closeButton setAutoresizingMask: NSViewMinXMargin | NSViewMaxYMargin];
    }

  if ([closeButton superview] == nil)
    {
      [self addSubview: closeButton];
      [self setNeedsDisplay: YES];
    }
}

- (NSButton *) closeButton
{
  return closeButton;
}

- (void) removeCloseButton
{
  if ([closeButton superview] != nil)
    {
      [closeButton removeFromSuperview];
    }
}

- (void) addMiniaturizeButtonWithAction: (SEL)miniaturizeAction
{
  if (miniaturizeButton == nil)
    {
      NSSize viewSize;
      NSSize buttonSize;
      
      ASSIGN(miniaturizeButton, 
             [NSWindow standardWindowButton: 
                           NSWindowMiniaturizeButton 
                       forStyleMask: 
                           NSTitledWindowMask | NSClosableWindowMask 
                       | NSMiniaturizableWindowMask]);
      [miniaturizeButton setTarget: _owner];
      [miniaturizeButton setAction: miniaturizeAction];

      viewSize = [self frame].size;
      buttonSize = [[miniaturizeButton image] size];
      buttonSize = NSMakeSize(buttonSize.width + 3, buttonSize.height + 3);

      // Update location
      [miniaturizeButton setFrame:
        NSMakeRect(4, (viewSize.height - buttonSize.height) / 2,
                   buttonSize.width, buttonSize.height)];

      [miniaturizeButton setAutoresizingMask: NSViewMaxXMargin | NSViewMaxYMargin];
    }
    
  if ([miniaturizeButton superview] == nil)
    {
      [self addSubview: miniaturizeButton];
      [self setNeedsDisplay: YES];
    }
}

- (NSButton *) miniaturizeButton
{
  return miniaturizeButton;
}

- (void) removeMiniaturizeButton
{
  if ([miniaturizeButton superview] != nil)
    {
      [miniaturizeButton removeFromSuperview];
    }
}

@end 
