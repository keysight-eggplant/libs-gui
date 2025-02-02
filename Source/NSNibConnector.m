// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Marcian Lytwyn 
// Commit ID: ffb26b5d3426c5e3b2fa2cd2d0ade13cbc813104 
// Date: 2016-02-01 22:08:22 +0000 
// ========== End of Keysight Technologies Notice ========== 
/* 
   <title>NSNibConnector</title>

   <abstract>Implementation of NSNibConnector and subclasses</abstract>

   Copyright (C) 1999, 2015 Free Software Foundation, Inc.

   Author:  Richard Frith-Macdonald <richard@branstorm.co.uk>
   Date: 1999
   Author: Fred Kiefer <fredkiefer@gmx.de>
   Date: August 2015
   
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
#import <Foundation/NSCoder.h>
#import <Foundation/NSException.h>
#import <Foundation/NSString.h>
#import "AppKit/NSControl.h"
#import "AppKit/NSNibConnector.h"

@implementation	NSNibConnector

- (void) dealloc
{
  RELEASE(_src);
  RELEASE(_dst);
  RELEASE(_tag);
  [super dealloc];
}

- (id) destination
{
  return _dst;
}

- (void) encodeWithCoder: (NSCoder*)aCoder
{
  if ([aCoder allowsKeyedCoding])
    {
      if (_src != nil)
	{
	  [aCoder encodeObject: _src forKey: @"NSSource"];
	}
      if (_dst != nil)
	{
	  [aCoder encodeObject: _dst forKey: @"NSDestination"];
	}
      if (_tag != nil)
	{
	  [aCoder encodeObject: _tag forKey: @"NSLabel"];
	}
    }
  else
    {
      [aCoder encodeObject: _src];
      [aCoder encodeObject: _dst];
      [aCoder encodeObject: _tag];
    }
}

- (void) establishConnection
{
}

- (id) initWithCoder: (NSCoder*)aDecoder
{
  if ([aDecoder allowsKeyedCoding])
    {
      if ([aDecoder containsValueForKey: @"NSDestination"])
	{
	  ASSIGN(_dst, [aDecoder decodeObjectForKey: @"NSDestination"]);
	}
      if ([aDecoder containsValueForKey: @"NSSource"])
	{
	  ASSIGN(_src, [aDecoder decodeObjectForKey: @"NSSource"]);
	}
      if ([aDecoder containsValueForKey: @"NSLabel"])
	{      
	  ASSIGN(_tag, [aDecoder decodeObjectForKey: @"NSLabel"]);
	}
    }
  else
    {
      [aDecoder decodeValueOfObjCType: @encode(id) at: &_src];
      [aDecoder decodeValueOfObjCType: @encode(id) at: &_dst];
      [aDecoder decodeValueOfObjCType: @encode(id) at: &_tag];
    }
  return self;
}

- (BOOL) isEqual: (id)object
{
  BOOL result = NO;

  if([object isKindOfClass: [NSNibConnector class]] == NO)
    {
      return NO;
    }

  if(self == object)
    {
      result = YES;
    }
  else if([[self source] isEqual: [object source]] &&
	  [[self destination] isEqual: [object destination]] &&
	  [[self label] isEqual: [object label]] &&
	  ([self class] == [object class]))
    {
      result = YES;
    }
  return result;
}

- (NSString*) label
{
  return _tag;
}

- (void) replaceObject: (id)anObject withObject: (id)anotherObject
{
  if (_src == anObject)
    {
      ASSIGN(_src, anotherObject);
    }
  if (_dst == anObject)
    {
      ASSIGN(_dst, anotherObject);
    }
  if (_tag == anObject)
    {
      ASSIGN(_tag, anotherObject);
    }
}

- (id) source
{
  return _src;
}

- (void) setDestination: (id)anObject
{
  ASSIGN(_dst, anObject);
}

- (void) setLabel: (NSString*)label
{
  ASSIGN(_tag, label);
}

- (void) setSource: (id)anObject
{
  ASSIGN(_src, anObject);
}

- (NSString *)description
{
  NSString *desc = [NSString stringWithFormat: @"<%@ src=%@ dst=%@ label=%@>",
			     [super description],
			     [self source],
			     [self destination],
			     [self label]];
  return desc;
}
@end

@implementation	NSNibControlConnector
- (void) establishConnection
{
  SEL sel = NSSelectorFromString(_tag);
	      
  [_src setTarget: _dst];
  [_src setAction: sel];
}
@end

@implementation	NSNibOutletConnector
- (void) establishConnection
{
  NS_DURING
    {
      if (_src != nil)
	{
          NSString *selName;
          SEL sel; 	 
          
          selName = [NSString stringWithFormat: @"set%@%@:", 	 
                       [[_tag substringToIndex: 1] uppercaseString], 	 
                      [_tag substringFromIndex: 1]]; 	 
          sel = NSSelectorFromString(selName); 	 
          
          if (sel && [_src respondsToSelector: sel]) 	 
            { 	 
              [_src performSelector: sel withObject: _dst]; 	 
            } 	 
          else 	 
            { 	 
              /*
               * We cannot use the KVC mechanism here, as this would always retain _dst
               * and it could also affect _setXXX methods and _XXX ivars that aren't
               * affected by the Cocoa code.
               */ 	 
              const char *name = [_tag cString];
              Class class = object_getClass(_src);
              Ivar ivar = class_getInstanceVariable(class, name);
              
              if (ivar != 0)
                {
                  object_setIvar(_src, ivar, _dst);
                }
            }
	}
    }
  NS_HANDLER
    {
      NSLog(@"Error while establishing connection %@: %@", self, [localException reason]);
    }
  NS_ENDHANDLER;
}
@end
