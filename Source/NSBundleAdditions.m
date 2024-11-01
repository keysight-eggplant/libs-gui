// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Paul Landers 
// Commit ID: 2cb1263af068a7f9f7af60b49e5af602cdfd0174 
// Date: 2017-09-13 16:53:28 +0000 
// ========== End of Keysight Technologies Notice ========== 
/** <title>NSBundleAdditions</title>

   <abstract>Implementation of NSBundle Additions</abstract>

   Copyright (C) 1997, 1999 Free Software Foundation, Inc.

   Author:  Simon Frankau <sgf@frankau.demon.co.uk>
   Date: 1997
   Author:  Richard Frith-Macdonald <richard@brainstorm.co.uk>
   Date: 1999
   Author:  Gregory John Casamento <greg_casamento@yahoo.com>
   Date: 2000
   
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
#import <Foundation/NSArray.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSDebug.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSEnumerator.h>
#import <Foundation/NSString.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSUserDefaults.h>
#import "AppKit/NSNib.h"
#import "AppKit/NSNibLoading.h"
#import "GNUstepGUI/GSModelLoaderFactory.h"

#if defined(__clang__) && defined(_WIN32)
// This object file does not contain any (unique) symbol names, which would lead to conflicts in weak symbol references when
// compiling with clang for the Windows platform.  See https://reviews.llvm.org/D75989 and https://maskray.me/blog/2021-04-25-weak-symbol
@implementation NSBundleAdditions
{

}
@end
#endif

@implementation NSBundle (NSBundleAdditions)
+ (BOOL) loadNibFile: (NSString*)fileName
   externalNameTable: (NSDictionary*)context
	    withZone: (NSZone*)zone
{
  NSNib *nib = [[NSNib alloc] initWithContentsOfURL: [NSURL fileURLWithPath: fileName]];
  BOOL loaded = [nib instantiateNibWithExternalNameTable: context
                                                withZone: zone];

  RELEASE(nib);
  return loaded;
}

+ (BOOL) loadNibNamed: (NSString *)aNibName
                owner: (id)owner
{
    NSBundle	*bundle;
    if (owner == nil || aNibName == nil)
    {
        return NO;
    }
    
    /*
     * First look for the NIB in the bundle corresponding to the owning class,
     * since the class may have been loaded dynamically and the bundle may
     * contain class-specific NIB resources as well as code.
     * If that fails, try to load the NIB from the main application bundle,
     * which is where most NIB resources are to be found.
     * Possibly this is the wrong order ... since it's conceivable that an
     * application may supply an alternative NIB which it would like to have
     * used in preference to the one in the classes bundle.  However I could
     * not find the behavior documented anywhere and the current order is
     * most consistent with the the way the code behaved before I changed it.
     */
    bundle = [self bundleForClass: [owner class]];
    if (bundle != nil && [bundle loadNibNamed:aNibName owner:owner topLevelObjects:NULL] == YES)
    {
        return YES;
    }
    else
    {
        return [[self mainBundle] loadNibNamed:aNibName owner:owner topLevelObjects:NULL];
    }
}

- (BOOL) loadNibNamed: (NSString *)aNibName
	        owner: (id)owner
      topLevelObjects:(NSArray**)tlo
{
  NSDictionary	*table;
  
  if (owner == nil || aNibName == nil)
    {
      return NO;
    }
  table = [NSDictionary dictionaryWithObject: owner forKey: NSNibOwner];

 
  BOOL success = [self loadNibFile: aNibName
	   externalNameTable: table
		    withZone: [owner zone]];
    
    // Testplant-PGL 8-SEP-2017
    // when using the newer topLevelObjects API, conform to the cocoa standard of letting the caller own the TLOs.
    // these were previously retained by [GSXibLoader awake:withContext:] so we need to autorelease them.
    // see cocoa docs for loadNibNamed:owner:topLevelObjects:
  if (success && tlo && [table objectForKey:NSNibTopLevelObjects])
    {
      *tlo = [table objectForKey:NSNibTopLevelObjects];
      for (NSObject *obj in *tlo)
        {
          [obj autorelease];
        }
    }
  return success;
}

- (NSString *) pathForNibResource: (NSString *)fileName
{
  NSEnumerator		*enumerator;
  NSArray *types = [GSModelLoaderFactory supportedTypes];
  NSString *ext = [fileName pathExtension];

  NSDebugLLog(@"NIB", @"Path for NIB file %@", fileName);
  if ((ext == nil) || [ext isEqualToString:@""])
    {
      NSString *type;

      enumerator = [types objectEnumerator];
      while ((type = [enumerator nextObject]))
        {
          NSDebugLLog(@"NIB", @"Checking type %@", fileName);
          NSString *path = [self pathForResource: fileName
                                          ofType: type];
          if (path != nil)
            {
              return path;
            }
        }  
    }
  else
    {
      if ([types containsObject: ext])
        {
          NSString *path = [self pathForResource: 
                                   [fileName stringByDeletingPathExtension]
                                          ofType: ext];
          if (path != nil)
            {
              return path;
            }
        }
    }

  NSDebugLLog(@"NIB", @"Did not find NIB resource %@", fileName);
  return nil;
}

- (BOOL) loadNibFile: (NSString*)fileName
   externalNameTable: (NSDictionary*)context
	    withZone: (NSZone*)zone
{
  NSString *path = [self pathForNibResource: fileName];

  if (path != nil)
    {
      return [NSBundle loadNibFile: path
		 externalNameTable: context
			  withZone: (NSZone*)zone];
    }
  else 
    {
      return NO;
    }
}
@end
// end of NSBundleAdditions
