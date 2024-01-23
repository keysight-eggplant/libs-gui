########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: fefc425636935f687354dcb8ff200fce6f740102
# Date: 2017-08-31 15:56:29 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 31f52310df1070560f65479c26efcfa2fac99342
# Date: 2017-01-25 15:49:14 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 33ed3c7f759d5a1040d27e002f351d9f34ca4080
# Date: 2016-03-08 19:39:32 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: faf6349ffda314a2ad4c601b9b3c49eac38336c3
# Date: 2015-08-13 16:33:48 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c6a5c9a81e2db87622cb6aabb593270345282c3e
# Date: 2015-06-11 17:48:41 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0
# Date: 2013-08-09 14:24:48 +0000
--------------------
# Committed by: Gregory John Casamento
# Commit ID: 7b1a15cd96cb6cb282f2088ea39e5ba04a0088b6
# Date: 2012-08-31 16:57:39 +0000
########## End of Keysight Technologies Notice ##########
#import <Foundation/NSObject.h>
#import <Foundation/NSKeyedArchiver.h>
#import "GNUstepGUI/GSXibElement.h"
#import "GNUstepGUI/GSXibLoading.h"

@interface IBAccessibilityAttribute : NSObject <NSCoding>
@end

@interface IBNSLayoutConstraint : NSObject <NSCoding>
@end

@interface IBLayoutConstant : NSObject <NSCoding>
@end

@implementation IBUserDefinedRuntimeAttribute

- (void) encodeWithCoder: (NSCoder *)coder
{
  if([coder allowsKeyedCoding])
    {
      [coder encodeObject: typeIdentifier forKey: @"typeIdentifier"];
      [coder encodeObject: keyPath forKey: @"keyPath"];
      [coder encodeObject: value forKey: @"value"];
    }
}

- (id) initWithCoder: (NSCoder *)coder
{
  if([coder allowsKeyedCoding])
    {
      [self setTypeIdentifier: [coder decodeObjectForKey: @"typeIdentifier"]];
      [self setKeyPath: [coder decodeObjectForKey: @"keyPath"]];
      [self setValue: [coder decodeObjectForKey: @"value"]];
    }
  return self;
}

- (void) setTypeIdentifier: (NSString *)type
{
  ASSIGN(typeIdentifier, type);
}

- (NSString *) typeIdentifier
{
  return typeIdentifier;
}

- (void) setKeyPath: (NSString *)kpath
{
  ASSIGN(keyPath, kpath);
}

- (NSString *) keyPath
{
  return keyPath;
}

- (void) setValue: (id)val
{
  ASSIGN(value, val);
}

- (id) value
{
  return value;
}

- (NSString*) description
{
  NSMutableString *description = [[super description] mutableCopy];
  [description appendString: @" <"];
  [description appendFormat: @" type: %@", typeIdentifier];
  [description appendFormat: @" keyPath: %@", keyPath];
  [description appendFormat: @" value: %@", value];
  [description appendString: @">"];
  return AUTORELEASE(description);
}

@end

@implementation IBUserDefinedRuntimeAttributesPlaceholder

- (void) encodeWithCoder: (NSCoder *)coder
{
  if([coder allowsKeyedCoding])
  {
    [coder encodeObject: name forKey: @"IBUserDefinedRuntimeAttributesPlaceholderName"];
    [coder encodeObject: runtimeAttributes forKey: @"userDefinedRuntimeAttributes"];
  }
}

- (id) initWithCoder: (NSCoder *)coder
{
  if([coder allowsKeyedCoding])
  {
    [self setName: [coder decodeObjectForKey: @"IBUserDefinedRuntimeAttributesPlaceholderName"]];
    [self setRuntimeAttributes: [coder decodeObjectForKey: @"userDefinedRuntimeAttributes"]];
  }
  return self;
}

- (void) setName: (NSString *)value
{
  ASSIGN(name, value);
}

- (NSString *) name
{
  return name;
}

- (void) setRuntimeAttributes: (NSArray *)attrbutes
{
  ASSIGN(runtimeAttributes, attrbutes);
}

- (NSArray *) runtimeAttributes
{
  return runtimeAttributes;
}

- (NSString*) description
{
  NSMutableString *description = [[super description] mutableCopy];
  [description appendFormat: @" runtimeAttributes: %@", runtimeAttributes];
  return AUTORELEASE(description);
}

@end

@implementation IBAccessibilityAttribute

- (void) encodeWithCoder: (NSCoder *)coder
{
}

- (id) initWithCoder: (NSCoder *)coder
{
  return self;
}

@end

@implementation IBNSLayoutConstraint
- (void) encodeWithCoder: (NSCoder *)coder
{
  // Do nothing...
}

- (id) initWithCoder: (NSCoder *)coder
{
  return self;
}
@end

@implementation IBLayoutConstant
- (void) encodeWithCoder: (NSCoder *)coder
{
  // Do nothing...
}

- (id) initWithCoder: (NSCoder *)coder
{
  return self;
}
@end
