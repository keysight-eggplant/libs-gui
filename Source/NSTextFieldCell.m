########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: b2e13f848c45148684642b4f1113a8b880e2cfe3
# Date: 2018-08-24 20:03:40 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 3e2f3f27b18f70756b15b87e61e064781f47cfbf
# Date: 2017-08-15 18:40:10 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c7d2c43dc608d38331a3d398b2a55a1c4a104186
# Date: 2017-08-15 17:01:12 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 4c396274daead8095a07010f54d749b90d3fe7e0
# Date: 2016-11-11 23:47:35 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: de5f907dcae55a0a0a8af1653c5e6c379ab2a4bc
# Date: 2015-07-08 22:21:16 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0
# Date: 2013-08-09 14:24:48 +0000
--------------------
# Committed by: Doug Simons
# Commit ID: 6f9a0ad102eaaa7bf5f37f38f1d41fb8535bd2e7
# Date: 2013-04-22 20:12:01 +0000
########## End of Keysight Technologies Notice ##########
/** <title>NSTextFieldCell</title>

   <abstract>Cell class for the text field entry control</abstract>

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author: Scott Christley <scottc@net-community.com>
   Date: 1996
   Author: Nicola Pero <n.pero@mi.flashnet.it>
   Date: November 1999
   
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

#import "config.h"
#import <Foundation/NSNotification.h>
#import "AppKit/NSAttributedString.h"
#import "AppKit/NSColor.h"
#import "AppKit/NSControl.h"
#import "AppKit/NSEvent.h"
#import "AppKit/NSFont.h"
#import "AppKit/NSGraphics.h"
#import "AppKit/NSStringDrawing.h"
#import "AppKit/NSTextField.h"
#import "AppKit/NSTextFieldCell.h"
#import "AppKit/NSText.h"

@implementation NSTextFieldCell

+ (void) initialize
{
  if (self == [NSTextFieldCell class])
    {
      [self setVersion: 2];
    }
}

//
// Initialization
//
- (id) initTextCell: (NSString *)aString
{
  self = [super initTextCell: aString];
  if (self == nil)
    return self;

  ASSIGN(_text_color, [NSColor textColor]);
  ASSIGN(_background_color, [NSColor textBackgroundColor]);
//  _textfieldcell_draws_background = NO;
  _action_mask = NSKeyUpMask | NSKeyDownMask;
  return self;
}

- (void) dealloc
{
  RELEASE(_background_color);
  RELEASE(_text_color);
  RELEASE(_placeholder);
  [super dealloc];
}

- (id) copyWithZone: (NSZone*)zone
{
  NSTextFieldCell *c = [super copyWithZone: zone];

  RETAIN(_background_color);
  RETAIN(_text_color);
  c->_placeholder = [_placeholder copyWithZone: zone];

  return c;
}

//
// Modifying Graphic Attributes 
//
- (void) setBackgroundColor: (NSColor *)aColor
{
  ASSIGN (_background_color, aColor);
  if (_control_view)
    if ([_control_view isKindOfClass: [NSControl class]])
      [(NSControl *)_control_view updateCell: self];
}

/** <p>Returns the color used to draw the background</p>
    <p>See Also: -setBackgroundColor:</p>
 */
- (NSColor *) backgroundColor
{
  return _background_color;
}


/** <p>Sets whether the NSTextFieldCell draw its background color</p>
    <p>See Also: -drawsBackground</p>
 */
- (void) setDrawsBackground: (BOOL)flag
{
  _textfieldcell_draws_background = flag;
  if (_control_view)
    if ([_control_view isKindOfClass: [NSControl class]])
      [(NSControl *)_control_view updateCell: self];
}

/** <p>Returns whether the NSTextFieldCell draw its background color</p>
    <p>See Also: -setBackgroundColor:</p>
 */
- (BOOL) drawsBackground
{
  return _textfieldcell_draws_background;
}

/** <p>Sets the text color to aColor</p>
    <p>See Also: -textColor</p>
 */
- (void) setTextColor: (NSColor *)aColor
{
  ASSIGN (_text_color, aColor);
  if (_control_view)
    if ([_control_view isKindOfClass: [NSControl class]])
      [(NSControl *)_control_view updateCell: self];
}

/** <p>Returns the text color</p>
    <p>See Also: -setTextColor:</p>
 */
- (NSColor *) textColor
{
  return _text_color;
}

- (void) setBezelStyle: (NSTextFieldBezelStyle)style
{
  _bezelStyle = style;
}

- (NSTextFieldBezelStyle) bezelStyle
{
  return _bezelStyle;
}

- (NSAttributedString*) placeholderAttributedString
{
  if (_textfieldcell_placeholder_is_attributed_string == YES)
    {
      return (NSAttributedString*)_placeholder;
    }
  else
    {
      return nil;
    }
}

- (NSString*) placeholderString
{
  if (_textfieldcell_placeholder_is_attributed_string == YES)
    {
      return nil;
    }
  else
    {
      return (NSString*)_placeholder;
    }
}

- (void) setPlaceholderAttributedString: (NSAttributedString*)string
{
  ASSIGN(_placeholder, string);
  _textfieldcell_placeholder_is_attributed_string = YES;
}

- (void) setPlaceholderString: (NSString*)string
{
  ASSIGN(_placeholder, string);
  _textfieldcell_placeholder_is_attributed_string = NO;
}

- (NSText *) setUpFieldEditorAttributes: (NSText *)textObject
{
  textObject = [super setUpFieldEditorAttributes: textObject];
  [textObject setDrawsBackground: _textfieldcell_draws_background];
  [textObject setBackgroundColor: _background_color];
  [textObject setTextColor: _text_color];
  return textObject;
}

- (void) _drawBackgroundWithFrame: (NSRect)cellFrame 
                           inView: (NSView*)controlView
{
  if (_textfieldcell_draws_background)
    {
      if ([self isEnabled])
        {
          [_background_color set];
        }
      else
        {
          [[NSColor controlBackgroundColor] set];
        }
      NSRectFill([self drawingRectForBounds: cellFrame]);
    }     
}

- (void) _drawBorderAndBackgroundWithFrame: (NSRect)cellFrame 
                                    inView: (NSView*)controlView
{
  // FIXME: Should use the bezel style if set.
  [super _drawBorderAndBackgroundWithFrame: cellFrame inView: controlView];
  [self _drawBackgroundWithFrame: cellFrame inView: controlView];
}

- (void) drawInteriorWithFrame: (NSRect)cellFrame inView: (NSView*)controlView
{
  if (_cell.in_editing)
    [self _drawEditorWithFrame: cellFrame inView: controlView];
  else
    {
      NSRect titleRect;

      /* Make sure we are a text cell; titleRect might return an incorrect
         rectangle otherwise. Note that the type could be different if the
         user has set an image on us, which we just ignore (OS X does so as
         well). */
      _cell.type = NSTextCellType;
      titleRect = [self titleRectForBounds: cellFrame];

      // Testplant-MAL-2015-07-08: keeping testplant branch code...
	  NSAttributedString *string = [self _drawAttributedString];
	  NSSize size = [string size];
	  if (size.width > titleRect.size.width && [string length] > 4)
	    {
		  NSLineBreakMode mode = [self lineBreakMode];
		  if (mode == NSLineBreakByTruncatingHead || mode == NSLineBreakByTruncatingTail || mode == NSLineBreakByTruncatingMiddle)
		    {
			  string = [[string mutableCopy] autorelease];
			  //unichar ell = 0x2026;
			  NSString *ellipsis = @"..."; //[NSString stringWithCharacters:&ell length:1];
		      do {
			    NSRange replaceRange;
			    if (mode == NSLineBreakByTruncatingHead)
			      replaceRange = NSMakeRange(0,4);
			    else if (mode == NSLineBreakByTruncatingTail)
			      replaceRange = NSMakeRange([string length]-4,4);
			    else
			      replaceRange = NSMakeRange(([string length] / 2)-2, 4);
			    [(NSMutableAttributedString *)string replaceCharactersInRange:replaceRange withString:ellipsis];
			  } while ([string length] > 4 && [string size].width > titleRect.size.width);
    }
}
      [string drawWithRect: titleRect options: NSStringDrawingUsesLineFragmentOrigin];
    }
}

/* 
   Attributed string that will be displayed.
 */
- (NSAttributedString*) _drawAttributedString
{
  NSAttributedString *attrStr;

  attrStr = [super _drawAttributedString];
  if ((attrStr == nil) || ([[attrStr string] length] == 0))
    {
      attrStr = [self placeholderAttributedString];
      if ((attrStr == nil) || ([[attrStr string] length] == 0))
        {
          NSString *string;
          NSDictionary *attributes;
          NSMutableDictionary *newAttribs;
      
          string = [self placeholderString];
          if (string == nil)
            {
              return nil;
            }

          attributes = [self _nonAutoreleasedTypingAttributes];
          newAttribs = [NSMutableDictionary 
                           dictionaryWithDictionary: attributes];
          [newAttribs setObject: [NSColor disabledControlTextColor]
                      forKey: NSForegroundColorAttributeName];
          
          return AUTORELEASE([[NSAttributedString alloc]
                                 initWithString: string
                                 attributes: newAttribs]);
        }
      else
        {
          return attrStr;
        }
    }
  else
    {
      return attrStr;
    }
}

- (void) _updateFieldEditor: (NSText*)textObject
{
  [super _updateFieldEditor: textObject];
  [textObject setDrawsBackground: _textfieldcell_draws_background];
  [textObject setBackgroundColor: _background_color];
  [textObject setTextColor: _text_color];
}

- (BOOL) isOpaque
{
  if (_textfieldcell_draws_background == NO 
      || _background_color == nil 
      || [_background_color alphaComponent] < 1.0)
    return NO;
  else
    return YES;   
}

//
// NSCoding protocol
//
- (void) encodeWithCoder: (NSCoder*)aCoder
{
  BOOL tmp;

  [super encodeWithCoder: aCoder];

  if ([aCoder allowsKeyedCoding])
    {
      [aCoder encodeObject: [self backgroundColor] forKey: @"NSBackgroundColor"];
      [aCoder encodeObject: [self textColor] forKey: @"NSTextColor"];
      [aCoder encodeBool: [self drawsBackground] forKey: @"NSDrawsBackground"];
      if ([self isBezeled])
        {
          [aCoder encodeInt: [self bezelStyle] forKey: @"NSTextBezelStyle"];
        }
      if ([self placeholderString])
        [aCoder encodeObject: [self placeholderString] forKey: @"NSPlaceholderString"];
    }
  else
    {
      [aCoder encodeValueOfObjCType: @encode(id) at: &_background_color];
      [aCoder encodeValueOfObjCType: @encode(id) at: &_text_color];
      tmp = _textfieldcell_draws_background;
      [aCoder encodeValueOfObjCType: @encode(BOOL) at: &tmp];
    }
}

- (id) initWithCoder: (NSCoder*)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if (self == nil)
    return self;
 
  if ([aDecoder allowsKeyedCoding])
    {
      if ([aDecoder containsValueForKey: @"NSBackgroundColor"])
        {
          [self setBackgroundColor: [aDecoder decodeObjectForKey: 
                                                  @"NSBackgroundColor"]];
        }
      if ([aDecoder containsValueForKey: @"NSTextColor"])
        {
          [self setTextColor: [aDecoder decodeObjectForKey: @"NSTextColor"]];
        }
      if ([aDecoder containsValueForKey: @"NSDrawsBackground"])
        {
          [self setDrawsBackground: [aDecoder decodeBoolForKey: 
                                                  @"NSDrawsBackground"]];
        }
      if ([aDecoder containsValueForKey: @"NSTextBezelStyle"])
        {
          [self setBezelStyle: [aDecoder decodeIntForKey: 
                                             @"NSTextBezelStyle"]];
        }
      if ([aDecoder containsValueForKey: @"NSPlaceholderString"])
        {
          [self setPlaceholderString: [aDecoder decodeObjectForKey: @"NSPlaceholderString"]];
        }
    }
  else
    {
      BOOL tmp;

      if ([aDecoder versionForClassName:@"NSTextFieldCell"] < 2)
        {
          /* Replace the old default _action_mask with the new default one
             if it's set. There isn't really a way to modify this value
             on an NSTextFieldCell encoded in a .gorm file. The old default value
             causes problems with newer NSTableViews which uses this to discern 
             whether it should trackMouse:inRect:ofView:untilMouseUp: or not.
             This also disables the action from being sent on an uneditable and
             unselectable text fields.
          */
          if (_action_mask == NSLeftMouseUpMask)
            {
              _action_mask = NSKeyUpMask | NSKeyDownMask;
            }
        }

      [aDecoder decodeValueOfObjCType: @encode(id) at: &_background_color];
      [aDecoder decodeValueOfObjCType: @encode(id) at: &_text_color];
      [aDecoder decodeValueOfObjCType: @encode(BOOL) at: &tmp];
      _textfieldcell_draws_background = tmp;
    }

  return self;
}

@end
