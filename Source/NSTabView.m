########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: fd09bcdbca7189a049160254af4bfa81c7c84d0c
# Date: 2018-11-16 17:09:08 +0000
--------------------
# Committed by: Bekki Freeman
# Commit ID: 7539512b9a35e5d151b349f43f2f082c081c687a
# Date: 2017-09-22 18:04:50 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 31f52310df1070560f65479c26efcfa2fac99342
# Date: 2017-01-25 15:49:14 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 78b58c0f2442acd1a0dfb306ccb75ca44df0c9cc
# Date: 2015-07-20 19:50:40 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 31ffdc9fd5fa305762fe3b39b4b218e9df4e4619
# Date: 2015-07-20 19:48:22 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 060fca2f5082fa6e45f70595dba60a9c4cd1850c
# Date: 2015-06-20 16:06:26 +0000
--------------------
# Committed by: Jonathan Gillaspie
# Commit ID: a9cac5d99a95713b5afe34120ccf3014227bd71d
# Date: 2014-01-23 16:17:21 +0000
--------------------
# Committed by: Jonathan Gillaspie
# Commit ID: a139d7094a81d2d03dacec3546b5517b648b9a9a
# Date: 2014-01-23 16:13:37 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 425fbcd681c5c1f4efb5297b33c5b5a110bf8471
# Date: 2013-08-23 21:33:02 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0
# Date: 2013-08-09 14:24:48 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: d3b8f3ae90d1f97baba9deeaa55924a6fd9c2a43
# Date: 2013-03-08 22:59:40 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: cdf826a4d02f9a5b72d7522ca738a8a43a906d42
# Date: 2012-10-30 20:10:12 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 36e77b95f7921e9539fdc0c115fe4039fa573150
# Date: 2012-10-19 22:51:20 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: ed7a880a0c9c00b3e395a5089a5c82c96b1d365e
# Date: 2012-09-12 00:36:49 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 0c5c7ed17e54a83142de6d8577a552aba9c75c32
# Date: 2012-09-04 16:47:03 +0000
########## End of Keysight Technologies Notice ##########
/** <title>NSTabView</title>

   <abstract>The tabular view class</abstract>

   Copyright (C) 1999,2000 Free Software Foundation, Inc.

   Author: Michael Hanni <mhanni@sprintmail.com>
   Date: 1999

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

#import <Foundation/NSKeyValueCoding.h>
#import <Foundation/NSValue.h>
#import "AppKit/NSColor.h"
#import "AppKit/NSEvent.h"
#import "AppKit/NSFont.h"
#import "AppKit/NSFontManager.h"
#import "AppKit/NSForm.h"
#import "AppKit/NSGraphics.h"
#import "AppKit/NSImage.h"
#import "AppKit/NSKeyValueBinding.h"
#import "AppKit/NSMatrix.h"
#import "AppKit/NSTabView.h"
#import "AppKit/NSTabViewItem.h"
#import "AppKit/NSWindow.h"
#import "GNUstepGUI/GSTheme.h"
#import "GSBindingHelpers.h"
#import "NSViewPrivate.h"

@interface NSTabViewItem (KeyViewLoop)
- (void) _setUpKeyViewLoopWithNextKeyView: (NSView *)nextKeyView;
- (NSView *) _lastKeyView;
@end


@implementation NSTabView

/*
 * Class methods
 */
+ (void) initialize
{
  if (self == [NSTabView class])
    {
      [self setVersion: 3];

      [self exposeBinding: NSSelectedIndexBinding];
      [self exposeBinding: NSFontBinding];
      [self exposeBinding: NSFontNameBinding];
      [self exposeBinding: NSFontSizeBinding];
    }
}

- (id) initWithFrame: (NSRect)rect
{
  self = [super initWithFrame: rect];

  if (self)
    {
      // setup variables  
      ASSIGN(_items, [NSMutableArray array]);
      ASSIGN(_font, [NSFont systemFontOfSize: 0]);
      _selected = nil;
      //_truncated_label = NO;
    }

  return self;
}

- (void) dealloc
{
  // Reset the _selected attribute to prevent crash when -dealloc calls
  // -setNextKeyView:
  // Testplant-MAL-2015-07-20: Keep Frank LeGrand's fix...
  _original_nextKeyView = nil;
  _selected = nil;
  RELEASE(_items);
  RELEASE(_font);
  [super dealloc];
}

- (BOOL) isFlipped
{
  return YES;
}

// tab management.

- (void) addTabViewItem: (NSTabViewItem*)tabViewItem
{
  [self insertTabViewItem: tabViewItem atIndex: [_items count]];
}

- (void) insertTabViewItem: (NSTabViewItem*)tabViewItem
                   atIndex: (NSInteger)index
{
  if (tabViewItem == nil)
    return;
  
  [tabViewItem _setTabView: self];
  [_items insertObject: tabViewItem atIndex: index];
  
  // If this is the first inserted then select it...
  if ([_items count] == 1)
    [self selectTabViewItem: tabViewItem];

  if ([_delegate respondsToSelector:
    @selector(tabViewDidChangeNumberOfTabViewItems:)])
    {
      [_delegate tabViewDidChangeNumberOfTabViewItems: self];
    }

  /* TODO (Optimize) - just mark the tabs rect as needing redisplay */
  [self setNeedsDisplay: YES];
}

- (void) removeTabViewItem: (NSTabViewItem*)tabViewItem
{
  NSUInteger i = [self indexOfTabViewItem: tabViewItem];
  
  if (i == NSNotFound)
    return;

  RETAIN(tabViewItem);
  // Do this BEFORE removing from array...in case it gets released...
  [tabViewItem _setTabView: nil];
  [_items removeObjectAtIndex: i];

  if (tabViewItem == _selected)
    {
      if ([_items count] == 0)
        {
          [self selectTabViewItem: nil];
        }
      else
        {
          // Select a new tab index...
          NSUInteger newIndex = ((i < [_items count]) ? i : (i-1));
          [self selectTabViewItem: [_items objectAtIndex: newIndex]];
        }
    }
  RELEASE(tabViewItem);
  
  if ([_delegate respondsToSelector: @selector(tabViewDidChangeNumberOfTabViewItems:)])
    {
      [_delegate tabViewDidChangeNumberOfTabViewItems: self];
    }

    /* TODO (Optimize) - just mark the tabs rect as needing redisplay */
    [self setNeedsDisplay: YES];
}

- (NSInteger) indexOfTabViewItem: (NSTabViewItem*)tabViewItem
{
  return [_items indexOfObject: tabViewItem];
}

- (NSInteger) indexOfTabViewItemWithIdentifier: (id)identifier
{
  NSUInteger howMany = [_items count];
  NSUInteger i;

  for (i = 0; i < howMany; i++)
    {
      id anItem = [_items objectAtIndex: i];

      if ([[anItem identifier] isEqual: identifier])
        return i;
    }

  return NSNotFound;
}

- (NSInteger) numberOfTabViewItems
{
  return [_items count];
}

- (NSTabViewItem*) tabViewItemAtIndex: (NSInteger)index
{
  return [_items objectAtIndex: index];
}

- (NSArray*) tabViewItems
{
  return (NSArray*)_items;
}

- (void) selectFirstTabViewItem: (id)sender
{
  [self selectTabViewItemAtIndex: 0];
}

- (void) selectLastTabViewItem: (id)sender
{
  [self selectTabViewItem: [_items lastObject]];
}

- (void) selectNextTabViewItem: (id)sender
{
  NSUInteger selected_item = [self indexOfTabViewItem:_selected];
  if (selected_item != NSNotFound)
    {
      [self selectTabViewItemAtIndex: selected_item + 1];
    }
}

- (void) selectPreviousTabViewItem: (id)sender
{
  NSUInteger selected_item = [self indexOfTabViewItem:_selected];
  if (selected_item != NSNotFound)
    {
      [self selectTabViewItemAtIndex: selected_item - 1];
    }
}

- (NSTabViewItem*) selectedTabViewItem
{
  return _selected;
}

- (void) selectTabViewItem: (NSTabViewItem*)tabViewItem
{
  BOOL canSelect = YES;
  NSView *selectedView = nil;

  if ([_delegate respondsToSelector: @selector(tabView:shouldSelectTabViewItem:)])
    {
      canSelect = [_delegate tabView: self shouldSelectTabViewItem: tabViewItem];
    }
  
  if (canSelect)
    {
      if ([_delegate respondsToSelector: @selector(tabView:willSelectTabViewItem:)])
        {
          [_delegate tabView: self willSelectTabViewItem: tabViewItem];
        }
      
      if (_selected != nil)
        {
          [_selected _setTabState: NSBackgroundTab];

          /* NB: If [_selected view] is nil this does nothing, which
             is fine.  */
          [[_selected view] removeFromSuperview];
        }

      _selected = tabViewItem;
      [_selected _setTabState: NSSelectedTab];
      selectedView = [_selected view];
      if (selectedView != nil)
        {
          NSView *firstResponder;
          
          [self addSubview: selectedView];
          // FIXME: We should not change this mask
          [selectedView setAutoresizingMask:
           NSViewWidthSizable | NSViewHeightSizable];
          [selectedView setFrame: [self contentRect]];
          firstResponder = [_selected initialFirstResponder];
          if (firstResponder == nil)
            {
              firstResponder = [_selected view];
              [_selected setInitialFirstResponder: firstResponder];
              [firstResponder _setUpKeyViewLoopWithNextKeyView:
               _original_nextKeyView];
            }
          
          // Testplant-MAL-2015-07-20: Keep Frank LeGrand's fix...
          [super setNextKeyView: firstResponder];
          [_window makeFirstResponder: firstResponder];
        }
      
      /* Will need to redraw tabs and content area. */
      [self setNeedsDisplay: YES];
      
      if ([_delegate respondsToSelector: 
        @selector(tabView:didSelectTabViewItem:)])
        {
          [_delegate tabView: self didSelectTabViewItem: _selected];
        }
    }
}

- (void) selectTabViewItemAtIndex: (NSInteger)index
{
  if (index < 0 || index >= [_items count])
    [self selectTabViewItem: nil];
  else
    [self selectTabViewItem: [_items objectAtIndex: index]];
}

- (void) selectTabViewItemWithIdentifier: (id)identifier 
{
  NSInteger index = [self indexOfTabViewItemWithIdentifier: identifier];

  [self selectTabViewItemAtIndex: index];
}

- (void) takeSelectedTabViewItemFromSender: (id)sender
{
  NSInteger index = -1;

  if ([sender respondsToSelector: @selector(indexOfSelectedItem)] == YES)
    {
      index = [sender indexOfSelectedItem];
    }
  else if ([sender isKindOfClass: [NSMatrix class]] == YES)
    {
      NSInteger cols = [sender numberOfColumns];
      NSInteger row = [sender selectedRow];
      NSInteger col = [sender selectedColumn];

      if (row >= 0 && col >= 0)
        {
          index = row * cols + col;
        }
    }
  [self selectTabViewItemAtIndex: index];
}

- (void) setFont: (NSFont*)font
{
  ASSIGN(_font, font);
}

- (NSFont*) font
{
  return _font;
}

- (void) setTabViewType: (NSTabViewType)tabViewType
{
  _type = tabViewType;
}

- (NSTabViewType) tabViewType
{
  return _type;
}

- (void) setDrawsBackground: (BOOL)flag
{
  _draws_background = flag;
}

- (BOOL) drawsBackground
{
  return _draws_background;
}

- (void) setAllowsTruncatedLabels: (BOOL)allowTruncatedLabels
{
  _truncated_label = allowTruncatedLabels;
}

- (BOOL) allowsTruncatedLabels
{
  return _truncated_label;
}

- (void) setDelegate: (id)anObject
{
  _delegate = anObject;
}

- (id) delegate
{
  return _delegate;
}

// content and size

- (NSSize) minimumSize
{
  switch (_type)
    {
      case NSTopTabsBezelBorder:
        return NSMakeSize(3, 19);
      case NSNoTabsBezelBorder:
        return NSMakeSize(3, 3);
      case NSNoTabsLineBorder:
        return NSMakeSize(2, 2);
      case NSBottomTabsBezelBorder:
        return NSMakeSize(3, 19);
      case NSLeftTabsBezelBorder:
        return NSMakeSize(21, 3);
      case NSRightTabsBezelBorder:
        return NSMakeSize(21, 3);
      case NSNoTabsNoBorder:
      default:
        return NSZeroSize;
    }
}

- (NSRect) contentRect
{
  NSRect result = [[GSTheme theme] tabViewContentRectForBounds: _bounds
						   tabViewType: [self tabViewType]
						       tabView: self];
  return result;
    }

// Drawing.

- (void) drawRect: (NSRect)rect
{
  // Make sure some tab is selected
  if ((_selected == nil) && ([_items count] > 0))
    {
      [self selectFirstTabViewItem: nil];
    }

  [[GSTheme theme] drawTabViewRect: rect
		   inView: self
		   withItems: _items
		   selectedItem: _selected];
}

- (BOOL) isOpaque
{
  return NO;
}

// Event handling.

/* 
 *  Find the tab view item containing the NSPoint point. This point 
 *  is expected to be alreay in the coordinate system of the tab view.
 */
- (NSTabViewItem*) tabViewItemAtPoint: (NSPoint)point
{
  NSInteger howMany = [_items count];
  NSInteger i;

  for (i = 0; i < howMany; i++)
    {
      NSTabViewItem *anItem = [_items objectAtIndex: i];

      if (NSPointInRect(point, [anItem _tabRect]))
        return anItem;
    }

  return nil;
}

- (void) mouseDown: (NSEvent *)theEvent
{
  NSPoint location = [self convertPoint: [theEvent locationInWindow] 
                           fromView: nil];
  NSTabViewItem *anItem = [self tabViewItemAtPoint: location];
  
  if (anItem != nil  &&  ![anItem isEqual: _selected])
    {
      [self selectTabViewItem: anItem];

      GSKeyValueBinding *theBinding = [GSKeyValueBinding getBinding: NSSelectedIndexBinding
                                                          forObject: self];
      if (theBinding != nil)
        [theBinding reverseSetValueFor: NSSelectedIndexBinding];
    }
}


- (NSControlSize) controlSize
{
  // FIXME
  return NSRegularControlSize;
}

/**
 * Not implemented.
 */
- (void) setControlSize: (NSControlSize)controlSize
{
  // FIXME 
}

- (NSControlTint) controlTint
{
  // FIXME
  return NSDefaultControlTint;
}

/**
 * Not implemented.
 */
- (void) setControlTint: (NSControlTint)controlTint
{
  // FIXME 
}

// Coding.

- (void) encodeWithCoder: (NSCoder*)aCoder
{ 
  [super encodeWithCoder: aCoder];
  if ([aCoder allowsKeyedCoding])
    {
      unsigned int type = _type; // no flags set...

      [aCoder encodeBool: [self allowsTruncatedLabels] forKey: @"NSAllowTruncatedLabels"];
      [aCoder encodeBool: [self drawsBackground] forKey: @"NSDrawsBackground"];
      [aCoder encodeObject: [self font] forKey: @"NSFont"];
      [aCoder encodeObject: _items forKey: @"NSTabViewItems"];
      [aCoder encodeObject: [self selectedTabViewItem] forKey: @"NSSelectedTabViewItem"];
      [aCoder encodeInt: type forKey: @"NSTvFlags"];
    }
  else
    {
      NSUInteger selected_item = [self indexOfTabViewItem:_selected];
      [aCoder encodeObject: _items];
      [aCoder encodeObject: _font];
      [aCoder encodeValueOfObjCType: @encode(int) at: &_type];
      [aCoder encodeValueOfObjCType: @encode(BOOL) at: &_draws_background];
      [aCoder encodeValueOfObjCType: @encode(BOOL) at: &_truncated_label];
      [aCoder encodeConditionalObject: _delegate];
      [aCoder encodeValueOfObjCType: @encode(NSUInteger) at: &selected_item];
    }
}

- (id) initWithCoder: (NSCoder*)aDecoder
{
  self = [super initWithCoder: aDecoder];

  if ([aDecoder allowsKeyedCoding])
    {
      if ([aDecoder containsValueForKey: @"NSAllowTruncatedLabels"])
        {
          [self setAllowsTruncatedLabels: [aDecoder decodeBoolForKey: 
                                                        @"NSAllowTruncatedLabels"]];
        }
      if ([aDecoder containsValueForKey: @"NSDrawsBackground"])
        {
          [self setDrawsBackground: [aDecoder decodeBoolForKey: 
                                                  @"NSDrawsBackground"]];
        }
      if ([aDecoder containsValueForKey: @"NSFont"])
        {
          [self setFont: [aDecoder decodeObjectForKey: @"NSFont"]];
        }
      if ([aDecoder containsValueForKey: @"NSTvFlags"])
        {
          GSTabViewTypeFlagsUnion mask;
          mask.value = [aDecoder decodeIntForKey: @"NSTvFlags"];

          [self setControlTint: mask.flags.controlTint];
          [self setControlSize: mask.flags.controlSize];
          [self setTabViewType: mask.flags.tabViewBorderType];
        }
      if ([aDecoder containsValueForKey: @"NSTabViewItems"])
        {
          ASSIGN(_items, [aDecoder decodeObjectForKey: @"NSTabViewItems"]);
        }
      else // Otherwise assign an empty array...
        {
          ASSIGN(_items, [NSMutableArray array]);
        }
      if ([aDecoder containsValueForKey: @"NSSelectedTabViewItem"])
        {
	  // N.B.: As a side effect, this discards the subview frame
	  // and sets it to [self contentRect]. 
	  //
	  // This is desirable because the subview frame will be different
	  // depending on whether the arcive is from Cocoa or GNUstep,
	  // and which GNUstep theme was active at save time.
	  //
	  // However, it does mean that the tab view contents should be 
	  // prepared to resize slightly.
          [self selectTabViewItem: [aDecoder decodeObjectForKey: 
                                                 @"NSSelectedTabViewItem"]];
        }
    }
  else
    {
      int version = [aDecoder versionForClassName: @"NSTabView"];

      [aDecoder decodeValueOfObjCType: @encode(id) at: &_items];
      [aDecoder decodeValueOfObjCType: @encode(id) at: &_font];
      [aDecoder decodeValueOfObjCType: @encode(int) at: &_type];
      if (version < 2)
        {
          switch(_type)
            {
              case 0:
                _type = NSTopTabsBezelBorder;
                break;
              case 5:
                _type = NSLeftTabsBezelBorder;
                break;
              case 1:
                _type = NSBottomTabsBezelBorder;
                break;
              case 6:
                _type = NSRightTabsBezelBorder;
                break;
              case 2:
                _type = NSNoTabsBezelBorder;
                break;
              case 3:
                _type = NSNoTabsLineBorder;
                break;
              case 4:
                _type = NSNoTabsNoBorder;
                break;
              default:
                break;
            }
        }
      [aDecoder decodeValueOfObjCType: @encode(BOOL) at: &_draws_background];
      [aDecoder decodeValueOfObjCType: @encode(BOOL) at: &_truncated_label];
      _delegate = [aDecoder decodeObject];
      
      NSUInteger selected_item = NSNotFound;
      if (version < 3)
        {
          int tmp;
          [aDecoder decodeValueOfObjCType: @encode(int) at: &tmp];
          selected_item = tmp;
        }
      else
      {
        [aDecoder decodeValueOfObjCType: @encode(NSUInteger) at: &selected_item];
      }
      
      // N.B. Recalculates subview frame; see comment above.
      [self selectTabViewItemAtIndex: selected_item];      
    }
  return self;
}

- (void) setValue: (id)anObject forKey: (NSString*)aKey
{
  if ([aKey isEqual: NSSelectedIndexBinding])
    {
      [self selectTabViewItemAtIndex: [anObject intValue]];
    }
  else if ([aKey isEqual: NSFontNameBinding])
    {
      [self setFont: [[NSFontManager sharedFontManager] convertFont: [self font] 
                                                             toFace: anObject]];
    }
  else if ([aKey isEqual: NSFontSizeBinding])
    {
      [self setFont: [[NSFontManager sharedFontManager] convertFont: [self font]
                                                             toSize: [anObject doubleValue]]];
    }
  else
    {
      [super setValue: anObject forKey: aKey];
    }
}

- (id) valueForKey: (NSString*)aKey
{
  if ([aKey isEqual: NSSelectedIndexBinding])
    {
      return [NSNumber numberWithInt: [self indexOfTabViewItem: 
                                              [self selectedTabViewItem]]];
    }
  else if ([aKey isEqual: NSFontNameBinding])
    {
      return [[self font] fontName];
    }
  else if ([aKey isEqual: NSFontSizeBinding])
    {
      return [NSNumber numberWithDouble: (double)[[self font] pointSize]];
    }
  else
    {
      return [super valueForKey: aKey];
    }
}
@end

@implementation NSTabViewItem (KeyViewLoop)

- (void) _setUpKeyViewLoopWithNextKeyView: (NSView *)nextKeyView
{
  [self setInitialFirstResponder: [self view]];
  [[self view] _setUpKeyViewLoopWithNextKeyView: nextKeyView];
}

- (NSView *) _lastKeyView
{
  NSView *keyView = [self initialFirstResponder];
  NSView *itemView = [self view];
  NSView *lastKeyView = nil;
  NSMutableArray *views = // cycle protection
    [[NSMutableArray alloc] initWithCapacity: 1 + [[itemView subviews] count]];

  if (keyView == nil && itemView != nil)
    {
      [self _setUpKeyViewLoopWithNextKeyView: itemView];
    }
  while ([keyView isDescendantOf: itemView] && ![views containsObject: keyView])
    {
      [views addObject: keyView];
      lastKeyView = keyView;
      keyView = [keyView nextKeyView];
    }
  [views release];
  return lastKeyView;
}

@end

@implementation NSTabView (KeyViewLoop)

- (void) _setUpKeyViewLoopWithNextKeyView: (NSView *)nextKeyView
{
  [_items makeObjectsPerform: @selector(_setUpKeyViewLoopWithNextKeyView:)
		  withObject: nextKeyView];
  if (_selected)
    {
      [super setNextKeyView: [_selected initialFirstResponder]];
    }
  [self setNextKeyView: nextKeyView];
}

- (void) setNextKeyView: (NSView *)nextKeyView
{
  _original_nextKeyView = nextKeyView;
  if (_selected)
    {
      [[_selected _lastKeyView] setNextKeyView: nextKeyView];
    }
  else
    {
      [super setNextKeyView: nextKeyView];
    }
}

@end
