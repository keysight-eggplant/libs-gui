########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: d5242088e84b15d33a691c86055a5d379e25574c
# Date: 2017-03-24 15:55:57 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 4b977f7715d1542529d06ba4dd035c71def1e696
# Date: 2017-02-05 16:56:10 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 31f52310df1070560f65479c26efcfa2fac99342
# Date: 2017-01-25 15:49:14 +0000
########## End of Keysight Technologies Notice ##########
/** <title>GSXibParserDelegate.h</title>
 
 <abstract>The XIB 5 keyed unarchiver</abstract>
 
 Copyright (C) 1996-2017 Free Software Foundation, Inc.
 
 Author:  Marcian Lytwyn <gnustep@advcsi.com>
 Date: 12/28/16
 
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

#import <Foundation/Foundation.h>
#import "GSXibKeyedUnarchiver.h"

@class GSXib5Element;

@interface GSXib5KeyedUnarchiver : GSXibKeyedUnarchiver
{
  GSXib5Element       *_IBObjectContainer;
  GSXib5Element       *_connectionRecords;
  GSXib5Element       *_objectRecords;
  GSXib5Element       *_orderedObjects;
  GSXib5Element       *_flattenedProperties;
  GSXib5Element       *_runtimeAttributes;
  NSMutableDictionary *_orderedObjectsDict;
}

- (NSRange) decodeRangeForKey: (NSString*)key;
@end
