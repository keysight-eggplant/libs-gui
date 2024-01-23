// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Marcian Lytwyn 
// Commit ID: 8b6ec06cc2b6b9623a4ec5f3132e67f8fc13052f 
// Date: 2017-06-08 19:14:40 +0000 
// ========== End of Keysight Technologies Notice ========== 
/* 
   NSSearchFieldCell.h
 
   Text field cell class for text search
 
   Copyright (C) 2004 Free Software Foundation, Inc.
 
   Author: H. Nikolaus Schaller <hns@computer.org>
   Date: Dec 2004
   Author: Fred Kiefer <fredkiefer@gmx.de>
   Date: Mar 2006
 
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

#import <Foundation/NSArray.h>
#import <Foundation/NSException.h>
#import <Foundation/NSNotification.h>
#import <Foundation/NSString.h>
#import <Foundation/NSUserDefaults.h>

#import "AppKit/NSApplication.h"
#import "AppKit/NSButtonCell.h"
#import "AppKit/NSEvent.h"
#import "AppKit/NSImage.h"
#import "AppKit/NSMenu.h"
#import "AppKit/NSMenuView.h"
#import "AppKit/NSPopUpButtonCell.h"
#import "AppKit/NSSearchField.h"
#import "AppKit/NSSearchFieldCell.h"
#import "AppKit/NSWindow.h"

@interface NSSearchFieldCell (Private)

- (NSMenu *) _buildTemplate;
- (void) _openPopup: (id)sender;
- (void) _clearSearches: (id)sender;
- (void) _loadSearches;
- (void) _saveSearches;

@end /* NSSearchFieldCell Private */


@implementation NSSearchFieldCell

#define ICON_WIDTH	16

// Inlined method
 
static inline NSRect textCellFrameFromRect(NSRect cellRect) 
// Not the drawed part, precises just the part which receives events
{
  return NSMakeRect(cellRect.origin.x + ICON_WIDTH,
		    NSMinY(cellRect),
		    NSWidth(cellRect) - 2*ICON_WIDTH,
		    NSHeight(cellRect));
}

- (id) initTextCell:(NSString *)aString
{
  self = [super initTextCell: aString];
  if (self)
    {
      NSButtonCell *c;
      // NSMenu *template;

      c = [[NSButtonCell alloc] initImageCell: nil];
      [self setCancelButtonCell: c];
      RELEASE(c);
      [self resetCancelButtonCell];

      c = [[NSButtonCell alloc] initImageCell: nil];
      [self setSearchButtonCell: c];
      RELEASE(c);
      [self resetSearchButtonCell];

/* Don't set the searchMenuTemplate unless it is explicitly set in code or by a nib connection
      template = [self _buildTemplate];
      [self setSearchMenuTemplate: template];
      RELEASE(template);
*/

      //_recent_searches = [[NSMutableArray alloc] init];
      //_recents_autosave_name = nil;
      _max_recents = 10;
      [self _loadSearches];
    }

  return self;
}

- (void) dealloc
{
  RELEASE(_cancel_button_cell);
  RELEASE(_search_button_cell);
  RELEASE(_recent_searches);
  RELEASE(_recents_autosave_name);
  RELEASE(_menu_template);

  [super dealloc];
}

- (id) copyWithZone:(NSZone *) zone;
{
  NSSearchFieldCell *c = [super copyWithZone: zone];

  c->_cancel_button_cell = [_cancel_button_cell copyWithZone: zone];
  c->_search_button_cell = [_search_button_cell copyWithZone: zone];
  c->_recent_searches = [_recent_searches mutableCopyWithZone: zone];
  c->_recents_autosave_name = [_recents_autosave_name copyWithZone: zone];
  c->_menu_template = [_menu_template copyWithZone: zone];

  return c;
}

- (BOOL) isOpaque
{
  // only if all components are opaque
  return [super isOpaque] && [_cancel_button_cell isOpaque] && 
      [_search_button_cell isOpaque];
}

- (void) drawWithFrame: (NSRect)cellFrame inView: (NSView*)controlView
{
  [_search_button_cell drawWithFrame: [self searchButtonRectForBounds: cellFrame] 
		       inView: controlView];
  [super drawWithFrame: [self searchTextRectForBounds: cellFrame] 
	 inView: controlView];
  if ([[self stringValue] length] > 0)
    [_cancel_button_cell drawWithFrame: [self cancelButtonRectForBounds: cellFrame] 
		       inView: controlView];
}

- (BOOL) sendsWholeSearchString
{ 
  return _sends_whole_search_string; 
}

- (void) setSendsWholeSearchString: (BOOL)flag
{
  _sends_whole_search_string = flag;
}

- (BOOL) sendsSearchStringImmediately
{ 
  return _sends_search_string_immediatly; 
}

- (void) setSendsSearchStringImmediately: (BOOL)flag
{
  _sends_search_string_immediatly = flag;
}

- (NSInteger) maximumRecents
{ 
  return _max_recents;
}

- (void) setMaximumRecents: (NSInteger)max
{
  if (max > 254)
    {
      max = 254;
    }
  else if (max < 0)
    {
      max = 10;
    }

  _max_recents = max;
}

- (NSArray *) recentSearches
{
  return _recent_searches;
}

- (NSString *) recentsAutosaveName
{
  return _recents_autosave_name; 
}

- (void) setRecentsAutosaveName: (NSString *)name
{
  // TESTPLANT-MAL-06132017:
  // There's a bug in the search fields recents autosave name in IB write processing.  It
  // will encode en empty string in the XIB5 files for some reason when the autosave name was set
  // then cleared in the IB GUI settings.  Not sure what do do in this case - should we ignore
  // this or allow it to reset the autosave name to nil???
  if (name && ([name length] == 0))
    name = nil; // We'll clear it for now...
  ASSIGN(_recents_autosave_name, name);
  [self _loadSearches];
}

- (void) setRecentSearches: (NSArray *)searches
{
  int max;
  NSMutableArray *mutableSearches;

  max = [self maximumRecents];
  if ([searches count] > max)
    {
      id buffer[max];

      [searches getObjects: buffer range: NSMakeRange(0, max)];
      mutableSearches = [[NSMutableArray alloc] initWithObjects: buffer count: max];
    }
  else
    {
      mutableSearches = [[NSMutableArray alloc] initWithArray: searches];
    }
  [_recent_searches release];
  _recent_searches = mutableSearches;
  [self _saveSearches];
}
 
- (void) addToRecentSearches:(NSString *)searchTerm
{
  if (!_recent_searches)
    {
      ASSIGN(_recent_searches, [NSMutableArray array]);
    }
  if (searchTerm != nil && [searchTerm length] > 0
	&& [_recent_searches indexOfObject: searchTerm] == NSNotFound)
    {
      [_recent_searches addObject: searchTerm];
      [self _saveSearches];
    }
}

- (NSMenu *) searchMenuTemplate
{
  return _menu_template;
}

- (void) setSearchMenuTemplate: (NSMenu *)menu
{
  ASSIGN(_menu_template, menu);
  if (menu)
    {
      [[self searchButtonCell] setTarget: self];
      [[self searchButtonCell] setAction: @selector(_openPopup:)];
      [[self searchButtonCell] sendActionOn: NSLeftMouseDownMask];
    }
  else
    {
      [self resetSearchButtonCell];
    }
}

- (NSButtonCell *) cancelButtonCell
{
  return _cancel_button_cell;
}

- (void) setCancelButtonCell: (NSButtonCell *)cell
{
  ASSIGN(_cancel_button_cell, cell);
}

- (NSButtonCell *) searchButtonCell
{
  return _search_button_cell;
}

- (void) setSearchButtonCell: (NSButtonCell *)cell
{
  ASSIGN(_search_button_cell, cell);
}

- (void) resetCancelButtonCell
{
  NSButtonCell *c;
  
  c = [self cancelButtonCell];
  // configure the button
  [c setButtonType: NSMomentaryChangeButton];
  [c setBezelStyle: NSRegularSquareBezelStyle];
  [c setBordered: NO];
  [c setBezeled: NO];
  [c setEditable: NO];
  [c setImagePosition: NSImageOnly];
  [c setImage: [NSImage imageNamed: @"GSStop"]];
  [c setAction: @selector(clearSearch:)];
  [c setTarget: self];
  [c setKeyEquivalent: @"\e"];
  [c setKeyEquivalentModifierMask: 0];
  [self setTitle: @""];
}

- (void) resetSearchButtonCell
{
  NSButtonCell *c;

  c = [self searchButtonCell];
  // configure the button
  [c setButtonType: NSMomentaryChangeButton];
  [c setBezelStyle: NSRegularSquareBezelStyle];
  [c setBordered: NO];
  [c setBezeled: NO];
  [c setEditable: NO];
  [c setImagePosition: NSImageOnly];
  [c setImage: [NSImage imageNamed: @"GSSearch"]];
//  [c setAction: [self action]];
//  [c setTarget: [self target]];
  [c setAction: @selector(performClick:)];
  [c setTarget: self];
  [c sendActionOn: NSLeftMouseUpMask];
  [c setKeyEquivalent: @"\r"];
  [c setKeyEquivalentModifierMask: 0];
}

- (NSRect) cancelButtonRectForBounds: (NSRect)rect
{
  NSRect part, clear;
	
  NSDivideRect(rect, &clear, &part, ICON_WIDTH, NSMaxXEdge);
  return clear;
}

- (NSRect) searchTextRectForBounds: (NSRect)rect
{
  NSRect search, text, clear, part;

  if (!_search_button_cell)
    {
      // nothing to split off
      part = rect;
    }
  else
  {
    NSDivideRect(rect, &search, &part, ICON_WIDTH, NSMinXEdge);
  }

  if (!_cancel_button_cell)
    {
      // nothing to split off
      text = part;
    }
  else
    {
      NSDivideRect(part, &clear, &text, ICON_WIDTH, NSMaxXEdge);
    }

  return text;
}

- (NSRect) searchButtonRectForBounds: (NSRect)rect;
{
  NSRect search, part;
  
  NSDivideRect(rect, &search, &part, ICON_WIDTH, NSMinXEdge);
  return search;
}

- (void) editWithFrame: (NSRect)aRect
		inView: (NSView*)controlView
		editor: (NSText*)textObject
	      delegate: (id)anObject
		 event: (NSEvent*)theEvent
{
  // constrain to visible text area
  [super editWithFrame: [self searchTextRectForBounds: aRect]
	        inView: controlView
	        editor: textObject
	      delegate: anObject
	         event: theEvent];
}

- (void) endEditing: (NSText *)editor
{
  [self addToRecentSearches: [[[editor string] copy] autorelease]];
  [super endEditing: editor];
  [[NSNotificationCenter defaultCenter] 
      removeObserver: self 
                name: NSTextDidChangeNotification 
              object: editor];
}

- (void) selectWithFrame: (NSRect)aRect
		  inView: (NSView*)controlView
		  editor: (NSText*)textObject
		delegate: (id)anObject
		   start: (NSInteger)selStart
		  length: (NSInteger)selLength
{ 
  // constrain to visible text area
  [super selectWithFrame: [self searchTextRectForBounds: aRect]
	          inView: controlView
	          editor: textObject
	        delegate: anObject
	           start: selStart
	          length: selLength];
  [[NSNotificationCenter defaultCenter] 
      addObserver: self 
         selector: @selector(textDidChange:)
             name: NSTextDidChangeNotification 
           object: textObject];
}

- (BOOL) trackMouse: (NSEvent *)event 
	     inRect: (NSRect)cellFrame 
	     ofView: (NSView *)controlView 
       untilMouseUp: (BOOL)untilMouseUp
{
  NSRect rect;
  NSPoint thePoint;
  NSPoint location = [event locationInWindow];
  NSText *currentEditor;

  thePoint = [controlView convertPoint: location fromView: nil];

  // check if we are within the search/stop buttons
  rect = [self searchButtonRectForBounds: cellFrame];
  if ([controlView mouse: thePoint inRect: rect])
    {
      return [[self searchButtonCell] trackMouse: event 
				      inRect: rect 
				      ofView: controlView 
				      untilMouseUp: untilMouseUp];
    }

  rect = [self cancelButtonRectForBounds: cellFrame];
  if ([controlView mouse: thePoint inRect: rect])
    {
      return [[self cancelButtonCell] trackMouse: event 
				      inRect: rect 
				      ofView: controlView 
				      untilMouseUp: untilMouseUp];
    }

  currentEditor = ([controlView isKindOfClass:[NSControl class]]
		   ? [(NSControl *)controlView currentEditor]
		   : nil);
  if (currentEditor)
    {
      [currentEditor mouseDown: event];
      return YES;
    }

  return [super trackMouse: event 
		inRect: [self searchTextRectForBounds: cellFrame]
		ofView: controlView 
		untilMouseUp: untilMouseUp];
}

- (void) resetCursorRect: (NSRect)cellFrame inView: (NSView *)controlView
{
  [super resetCursorRect: textCellFrameFromRect(cellFrame)
		  inView: controlView];
}

- (void) textDidChange: (NSNotification *)notification
{ 
  NSText *textObject;
  [_control_view setNeedsDisplay:YES];
  
  // make textChanged send action (unless disabled)
  if (_sends_whole_search_string)
    {
      // ignore
      return;
    }

  textObject = [notification object];
  // copy the current NSTextEdit string so that it can be read from the NSSearchFieldCell!
  [self setStringValue: [textObject string]];
  [NSApp sendAction:[self action] to:[self target] from:_control_view];
}

- (void) clearSearch:(id)sender
{
  [self setStringValue:@""];
  [NSApp sendAction:[self action] to:[self target] from:_control_view];
  [_control_view setNeedsDisplay:YES];
}

//
// NSCoding protocol
//
- (void) encodeWithCoder: (NSCoder*)aCoder
{
  NSInteger max = [self maximumRecents];

  [super encodeWithCoder: aCoder];

  if ([aCoder allowsKeyedCoding])
    {
      [aCoder encodeObject: _search_button_cell forKey: @"NSSearchButtonCell"];
      [aCoder encodeObject: _cancel_button_cell forKey: @"NSCancelButtonCell"];
      [aCoder encodeObject: _recents_autosave_name forKey: @"NSRecentsAutosaveName"];
      [aCoder encodeBool: _sends_whole_search_string forKey: @"NSSendsWholeSearchString"];
      [aCoder encodeInt: max forKey: @"NSMaximumRecents"];
    }
  else
    {
      [aCoder encodeObject: _search_button_cell];
      [aCoder encodeObject: _cancel_button_cell];
      [aCoder encodeObject: _recents_autosave_name];
      [aCoder encodeValueOfObjCType: @encode(BOOL)
              at: &_sends_whole_search_string];
      [aCoder encodeValueOfObjCType: @encode(unsigned int)
              at: &max];
    }
}

- (id) initWithCoder: (NSCoder*)aDecoder
{
  self = [super initWithCoder: aDecoder];

  if (self != nil)
    {
      if ([aDecoder allowsKeyedCoding])
        {
          [self setSearchButtonCell: [aDecoder decodeObjectForKey: @"NSSearchButtonCell"]];
          [self setCancelButtonCell: [aDecoder decodeObjectForKey: @"NSCancelButtonCell"]];
          [self setRecentsAutosaveName: [aDecoder decodeObjectForKey: @"NSRecentsAutosaveName"]];
          [self setSendsWholeSearchString: [aDecoder decodeBoolForKey: @"NSSendsWholeSearchString"]];
          [self setMaximumRecents: [aDecoder decodeIntForKey: @"NSMaximumRecents"]];
          
          if ([[aDecoder class] coderVersion] > 0)
            {
              [self setDrawsBackground: YES];
              [self setBackgroundColor: [NSColor whiteColor]];
            }
        }
      else
        {
                NSInteger max;

          [self setSearchButtonCell: [aDecoder decodeObject]];
          [self setCancelButtonCell: [aDecoder decodeObject]];
          [self setRecentsAutosaveName: [aDecoder decodeObject]];
          [aDecoder decodeValueOfObjCType: @encode(BOOL) at: &_sends_whole_search_string];
          [aDecoder decodeValueOfObjCType: @encode(unsigned int) at: &max];
                [self setMaximumRecents: max];
        }
      
      [self resetCancelButtonCell];
      [self resetSearchButtonCell];
    }

  return self;
}

@end /* NSSearchFieldCell */


@implementation NSSearchFieldCell (Private)

/* Set up a default template
 */
- (NSMenu *) _buildTemplate
{
  NSMenu *template;
  NSMenuItem *item;

  template = [[NSMenu alloc] init];
  
  item = [[NSMenuItem alloc] initWithTitle: @"Recent searches"
			     action: NULL
			     keyEquivalent: @""];
  [item setTag: NSSearchFieldRecentsTitleMenuItemTag];
  [template addItem: item];
  RELEASE(item);
  
  item = [[NSMenuItem alloc] initWithTitle: @"Recent search item"
			     action: @selector(search:)
			     keyEquivalent: @""];
  [item setTag: NSSearchFieldRecentsMenuItemTag];
  [template addItem: item];
  RELEASE(item);
  
  item = [[NSMenuItem alloc] initWithTitle: @"Clear recent searches"
			     action: @selector(_clearSearches:)
			     keyEquivalent: @""];
  [item setTag: NSSearchFieldClearRecentsMenuItemTag];
  [item setTarget: self];
  [template addItem: item];
  
  RELEASE(item);
  item = [[NSMenuItem alloc] initWithTitle: @"No recent searches"
			     action: NULL
			     keyEquivalent: @""];
  [item setTag: NSSearchFieldNoRecentsMenuItemTag];
  [template addItem: item];
  RELEASE(item);
  
  return template;
}

- (void) _openPopup: (id)sender
{
  NSMenu *template;
  NSMenu *popupmenu;
  NSMenuView *mr;
  NSWindow *cvWin;
  NSRect cellFrame;
  int i;
  int recentCount = [_recent_searches count];
  NSPopUpButtonCell *pbcell = [[NSPopUpButtonCell alloc] initTextCell:nil pullsDown:NO];
  int selectedItemIndex = -1, newSelectedItemIndex;
  
  template = [self searchMenuTemplate];
  popupmenu = [[NSMenu alloc] init];
  [pbcell setAltersStateOfSelectedItem:NO];

  // Fill the popup menu 
  for (i = 0; i < [template numberOfItems]; i++)
    {
      int tag;
      NSMenuItem *item, *newItem = nil;

      item = (NSMenuItem*)[template itemAtIndex: i];
      if ([item state])
        selectedItemIndex = [popupmenu numberOfItems]; // remember index of previously selected item
      tag = [item tag];
      if (tag == NSSearchFieldRecentsTitleMenuItemTag)
        {
          if (recentCount > 0) // only show items with this tag if there are recent searches
            {
              newItem = [[item copy] autorelease];
            }
        }
      else if (tag == NSSearchFieldClearRecentsMenuItemTag)
        {
          if (recentCount > 0) // only show items with this tag if there are recent searches
            {
              newItem = [[item copy] autorelease];
              [newItem setTarget:self];
              [newItem setAction:@selector(_clearSearches:)];
            }
        }
      else if (tag == NSSearchFieldNoRecentsMenuItemTag)
        { 
          if (recentCount == 0) // only show items with this tag if there are NO recent searches
            {
              newItem = [[item copy] autorelease];
            }
        }
      else if (tag == NSSearchFieldRecentsMenuItemTag)
        {
          int j;

          for (j = 0; j < recentCount; j++)
            {
              id <NSMenuItem> searchItem = [popupmenu addItemWithTitle:[_recent_searches objectAtIndex: j]
                                                                action:@selector(_searchForRecent:)
                                                         keyEquivalent:[item keyEquivalent]];
              [searchItem setTarget: self];
            }
        }
      else // copy all other items without special tags from the template into the popup
        {
          newItem = [[item copy] autorelease];
        }

      if (newItem != nil)
        {
          [popupmenu addItem: newItem];
        }
    } 

  [pbcell setMenu:popupmenu];

  // TESTPLANT-MAL-04122016: Fix popup menu processing...
  [pbcell trackMouse: [NSApp currentEvent]
              inRect: [_control_view bounds]
              ofView: _control_view
        untilMouseUp: YES];

  // TESTPLANT-MAL-04252016: Fix search field template maintenance processing...
  // Copy over the user defined menu item states from the menu copy back to the template...
  // Discussion: Apple Cocoa maintains the state of user defined items in the template after
  // the user defined delegate method executes.  This allows the user to change/manipulate
  // their application menu items in whatever way they want.  We're going to just copy over
  // the state back for now.  However, should  user application change some other properties
  // within the menu item(s) in their callback method those property states will currently be lost...
  if ([pbcell indexOfSelectedItem] != NSNotFound)
    {
      NSMenuItem *item;
      NSEnumerator *menuEnum = [[popupmenu itemArray] objectEnumerator];
      while ((item = [menuEnum nextObject]))
        {
          int tag = [item tag];
          if (tag != NSSearchFieldRecentsTitleMenuItemTag &&
              tag != NSSearchFieldClearRecentsMenuItemTag &&
              tag != NSSearchFieldNoRecentsMenuItemTag &&
              tag != NSSearchFieldRecentsMenuItemTag &&
              [item isSeparatorItem] == NO)
            {
              [[template itemWithTitle:[item title]] setState:[item state]];
            }
        }
    }
  AUTORELEASE(popupmenu);
  AUTORELEASE(pbcell);
}

- (void) _searchForRecent: (id)sender
{
  NSString *searchTerm = [sender title];

  [self setStringValue: searchTerm];
  [self performClick: self];  // do the search
  [(id)_control_view selectText: self];
}

- (void) _clearSearches: (id)sender
{
  [self setRecentSearches: [NSArray array]];
}

- (void) _loadSearches
{
  NSArray *list;
  NSString *name = [self recentsAutosaveName];

  if (name)
    {
      list = [[NSUserDefaults standardUserDefaults] 
	         stringArrayForKey: name];
      [self setRecentSearches: list];
    }
}

- (void) _saveSearches
{
  NSArray *list = [self recentSearches];
  NSString *name = [self recentsAutosaveName];

  if (name && list)
    {
      [[NSUserDefaults standardUserDefaults] 
          setObject: list forKey: name];
    }
}

@end /* NSSearchFieldCell Private */
