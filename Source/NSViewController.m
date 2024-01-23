########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: de5f907dcae55a0a0a8af1653c5e6c379ab2a4bc
# Date: 2015-07-08 22:21:16 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0
# Date: 2013-08-09 14:24:48 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: c9f3f71f41d44759377cd69fc8f7a1da773dc27a
# Date: 2013-02-21 22:23:36 +0000
--------------------
# Committed by: Jonathan Gillaspie
# Commit ID: b40571e9c5377426a8d0bf0ff2d9bc375b4fd1de
# Date: 2013-02-13 20:18:52 +0000
########## End of Keysight Technologies Notice ##########
/* 
 NSViewController.m
 
 Copyright (C) 2010 Free Software Foundation, Inc.
 
 Author:  David Wetzel <dave@turbocat.de>
 Date: 2010

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
#import <Foundation/NSBundle.h>
#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSString.h>
#import "AppKit/NSKeyValueBinding.h"
#import "AppKit/NSNib.h"
#import "AppKit/NSView.h"
#import "AppKit/NSViewController.h"


@implementation NSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super init];
  if (self == nil)
    return nil;
  
  ASSIGN(_nibName, nibNameOrNil);
  ASSIGN(_nibBundle, nibBundleOrNil);
  
  return self;
}

- (void) dealloc
{
  // View Controllers are expect to release their own top-level objects
  [_topLevelObjects makeObjectsPerformSelector: @selector(release)];
  DESTROY(_nibName);
  DESTROY(_nibBundle);
  DESTROY(_representedObject);
  DESTROY(_title);
  DESTROY(_topLevelObjects);
  DESTROY(_editors);
  DESTROY(_autounbinder);
  DESTROY(_designNibBundleIdentifier);
  DESTROY(view);

  [super dealloc];
}

- (void)setRepresentedObject:(id)representedObject
{
  ASSIGN(_representedObject, representedObject);
}

- (id)representedObject
{
  return _representedObject;
}

- (void)setTitle:(NSString *)title
{
  ASSIGN(_title, title);
}

- (NSString *)title
{
  return _title;
}

- (NSView *)view
{
  if (view == nil && !_vcFlags.nib_is_loaded)
    {
      [self loadView];
    }
  return view;
}

- (void)setView:(NSView *)aView
{
  if (view != aView)
    {
      ASSIGN(view, aView);
    }
}

- (void)loadView
{
  NSNib *nib;

  if (_vcFlags.nib_is_loaded || ([self nibName] == nil))
    {
      return;
    }

  nib = [[NSNib alloc] initWithNibNamed: [self nibName]
                                 bundle: [self nibBundle]];
  if ((nib != nil) && [nib instantiateNibWithOwner: self
                                    topLevelObjects: &_topLevelObjects])
    {
      _vcFlags.nib_is_loaded = YES;
      // FIXME: Need to resolve possible retain cycles here
    }
  else
    {
      if (_nibName != nil)
        {
	  NSLog(@"%@: could not load nib named %@.nib", 
                [self class], _nibName);
	}
    }
  RETAIN(_topLevelObjects);
  RELEASE(nib);
}

- (NSString *)nibName
{
  return _nibName;
}

- (NSBundle *)nibBundle
{
  return _nibBundle;
}

- (id) initWithCoder: (NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if (!self)
    {
      return nil;
    }

  if ([aDecoder allowsKeyedCoding])
    {
      NSView *aView = [aDecoder decodeObjectForKey: @"NSView"];
      [self setView: aView];
    }
  else
    {
      NSView *aView;

      [aDecoder decodeValueOfObjCType: @encode(id) at: &aView];
      [self setView: aView];
    }
  return self;
}
  	 
- (void) encodeWithCoder: (NSCoder *)aCoder
{
  [super encodeWithCoder: aCoder];

  if ([aCoder allowsKeyedCoding])
    {
      [aCoder encodeObject: [self view] forKey: @"NSView"];
    }
  else
    {
      [aCoder encodeObject: [self view]];
    }
}
@end

@implementation NSViewController (NSEditorRegistration)
- (void) objectDidBeginEditing: (id)editor
{
  // Add editor to _editors
}

- (void) objectDidEndEditing: (id)editor
{
  // Remove editor from _editors
}

@end

@implementation NSViewController (NSEditor)
- (void)commitEditingWithDelegate:(id)delegate 
                didCommitSelector:(SEL)didCommitSelector 
                      contextInfo:(void *)contextInfo
{
  // Loop over all elements of _editors
  id editor = nil;
  BOOL res = [self commitEditing];

  if (delegate && [delegate respondsToSelector: didCommitSelector])
    {
      void (*didCommit)(id, SEL, id, BOOL, void*);

      didCommit = (void (*)(id, SEL, id, BOOL, void*))[delegate methodForSelector: 
								 didCommitSelector];
      didCommit(delegate, didCommitSelector, editor, res, contextInfo);
    }
  
}

- (BOOL)commitEditing
{
  // Loop over all elements of _editors
  [self notImplemented: _cmd];

  return NO;
}

- (void)discardEditing
{
  // Loop over all elements of _editors
  [self notImplemented: _cmd];
}

@end
