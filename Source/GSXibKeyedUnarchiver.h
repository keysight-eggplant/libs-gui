// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Marcian Lytwyn 
// Commit ID: 4b977f7715d1542529d06ba4dd035c71def1e696 
// Date: 2017-02-05 16:56:10 +0000 
// ========== End of Keysight Technologies Notice ========== 
/** <title>GSXibKeyedUnarchiver.h</title>
 
 <abstract>
 These are templates for use with OSX XIB 5 files.  These classes are the
 templates and other things which are needed for reading XIB 5 files.
 </abstract>
 
 Copyright (C) 1997, 1999 Free Software Foundation, Inc.
 
 File created by Marcian Lytwyn on 12/30/16 from original code by:
 
 Author: Gregory John Casamento
 Date: 2003, 2005
 
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

@class GSXibElement;

@interface GSXibKeyedUnarchiver : NSKeyedUnarchiver
{
  NSMutableDictionary *objects;
  NSMutableArray *stack;
  GSXibElement *currentElement;
  NSMutableDictionary *decoded;
}

- (void) _initCommon;
- (id) decodeObjectForXib: (GSXibElement*)element
             forClassName: (NSString*)classname
                   withID: (NSString*)objID;
- (id) _decodeArrayOfObjectsForElement: (GSXibElement*)element;
- (id) _decodeDictionaryOfObjectsForElement: (GSXibElement*)element;
- (id) objectForXib: (GSXibElement*)element;
@end
