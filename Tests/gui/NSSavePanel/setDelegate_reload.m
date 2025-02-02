// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Frank Le Grand 
// Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0 
// Date: 2013-08-09 14:24:48 +0000 
// ========== End of Keysight Technologies Notice ========== 
/*
copyright 2005 Alexander Malmberg <alexander@malmberg.org>

Test that the file lists in NSSavePanel are reloaded properly when the
delegate changes.
*/

#include "Testing.h"

#include <AppKit/AppKit.h>

@implementation NSSavePanel (TestDelegate)

- (NSMatrix *)lastColumnMatrix
{
  return [_browser matrixInColumn: [_browser lastColumn]];
}

@end

@interface Delegate : NSObject
@end

@implementation Delegate

static BOOL pressed;
static NSSavePanel *sp;

+ (BOOL) panel: (NSSavePanel *)p
shouldShowFilename: (NSString *)fname
{
  if ([[fname lastPathComponent] isEqual: @"B"])
    {
      return NO;
    }
  return YES;
}

@end

int main(int argc, char **argv)
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];
  NSSavePanel *p;
  NSMatrix *m;

  [NSApplication sharedApplication];
  
  p = [NSSavePanel savePanel];
  [p setShowsHiddenFiles: NO];
  [p setDirectory: [[[[[NSBundle mainBundle] bundlePath]
                       stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]
                     stringByAppendingPathComponent: @"dummy"]];
  
  m = [p lastColumnMatrix];
  pass([m numberOfRows] == 2
       && [[[m cellAtRow: 0 column: 0] stringValue] isEqual: @"A"]
       && [[[m cellAtRow: 1 column: 0] stringValue] isEqual: @"B"],
       "browser initially contains all files");
  
  [p setDelegate: [Delegate self]];
  m = [p lastColumnMatrix];
  pass([m numberOfRows] == 1
       && [[[m cellAtRow: 0 column: 0] stringValue] isEqual: @"A"],
       "browser is reloaded after -setDelegate:");
  
  /* Not really a -setDelegate: issue, but the other methods involved are
     documented as doing the wrong thing.  */
  [p setDelegate: nil];
  m = [p lastColumnMatrix];
  testHopeful = YES;
  pass([m numberOfRows] == 2
       && [[[m cellAtRow: 0 column: 0] stringValue] isEqual: @"A"]
       && [[[m cellAtRow: 1 column: 0] stringValue] isEqual: @"B"],
       "browser contains all files after resetting delegate");
  testHopeful = NO;
  
  [p setDelegate: [Delegate self]];
  m = [p lastColumnMatrix];
  pass([m numberOfRows] == 1
       && [[[m cellAtRow: 0 column: 0] stringValue] isEqual: @"A"],
       "browser is reloaded after -setDelegate: (2)");
  
  [arp release];
  return 0;
}
