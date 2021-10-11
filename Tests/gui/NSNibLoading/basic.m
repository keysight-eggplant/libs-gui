#import "ObjectTesting.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSFileManager.h>
#import <AppKit/NSApplication.h>
#import <AppKit/NSImage.h>
#import <AppKit/NSNibLoading.h>

// For some nib/xibs the AppDelegate is defined...
@interface AppDelegate : NSObject
{
  IBOutlet NSWindow *window;
}
@end

@implementation AppDelegate
@end


int main()
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];
  NSArray **testObjects;
  BOOL success = NO;
  NSFileManager *mgr = [NSFileManager defaultManager];
  NSString *path = [mgr currentDirectoryPath];
  NSBundle *bundle = [[NSBundle alloc] initWithPath: path];

  START_SET("NSNibLoading GNUstep basic")

  NS_DURING
  {
    [NSApplication sharedApplication];
  }
  NS_HANDLER
  {
    if ([[localException name] isEqualToString: NSInternalInconsistencyException ])
       SKIP("It looks like GNUstep backend is not yet installed")
  }
  NS_ENDHANDLER;

  if ([[path lastPathComponent] isEqualToString: @"obj"])
    {
      path = [path stringByDeletingLastPathComponent];
    }
  
  pass(bundle != nil, "NSBundle was initialized");

  NS_DURING
    {
      success = [bundle loadNibNamed: @"Test-gorm"
                               owner: [NSApplication sharedApplication]
                     topLevelObjects: testObjects];
      
      pass(success == YES, ".gorm file was loaded properly using loadNibNamed:owner:topLevelObjects:");
      
      success = [bundle loadNibNamed: @"Test-xib"
                               owner: [NSApplication sharedApplication]
                     topLevelObjects: testObjects];
      
      pass(success == YES, ".xib file was loaded properly using loadNibNamed:owner:topLevelObjects:");
      
      success = [bundle loadNibNamed: @"Test-nib"
                               owner: [NSApplication sharedApplication]
                     topLevelObjects: testObjects];
      
      pass(success == YES, ".nib file was loaded properly using loadNibNamed:owner:topLevelObjects:");
    }
  NS_HANDLER
    {
      NSLog(@"%@", [localException reason]);
    }
  NS_ENDHANDLER;
  
  END_SET("NSNibLoading GNUstep basic")

  [arp release];
  return 0;
}
