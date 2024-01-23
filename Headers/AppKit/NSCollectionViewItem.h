########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: 3238f42ec6968f85f910ba78e04a2fddf83e3e6e
# Date: 2015-06-26 00:29:04 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: d1bb44a910acbce4439269e2b98b2dac07bedee8
# Date: 2013-03-01 00:04:56 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: c9f3f71f41d44759377cd69fc8f7a1da773dc27a
# Date: 2013-02-21 22:23:36 +0000
########## End of Keysight Technologies Notice ##########
/* -*-objc-*-
   NSCollectionViewItem.h

   Copyright (C) 2013 Free Software Foundation, Inc.

   Author: Doug Simons (doug.simons@testplant.com)
           Frank LeGrand (frank.legrand@testplant.com)
   Date: February 2013
   
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

#ifndef _GNUstep_H_NSCollectionViewItem
#define _GNUstep_H_NSCollectionViewItem

#import <GNUstepBase/GSVersionMacros.h>
#import <Foundation/NSArray.h>

#import <AppKit/NSCollectionView.h>
#import <AppKit/NSDragging.h>
#import <AppKit/NSImageView.h>
#import <AppKit/NSNibDeclarations.h>
#import <AppKit/NSTextField.h>
#import <AppKit/NSView.h>
#import <AppKit/NSViewController.h>


@interface NSCollectionViewItem : NSViewController
{
  IBOutlet NSTextField *textField;
  IBOutlet NSImageView *imageView;
  BOOL _isSelected;
}

- (NSCollectionView *)collectionView;
- (NSArray *)draggingImageComponents;

- (void)setSelected:(BOOL)shouldBeSelected;
- (BOOL)isSelected;

- (NSTextField *)textField;
- (void)setTextField:(NSTextField *)aTextField;

- (NSImageView *)imageView;
- (void)setImageView:(NSImageView *)anImageView;

@end

#endif /* _GNUstep_H_NSCollectionView */
