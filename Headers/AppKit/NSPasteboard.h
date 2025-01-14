// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Marcian Lytwyn 
// Commit ID: 189ee17b085741d979a2e3e3df25365c829940cc 
// Date: 2016-10-04 22:24:37 +0000 
// ========== End of Keysight Technologies Notice ========== 
/* 
   NSPasteboard.h

   Class to transfer data to and from the pasteboard server

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: 1996
   Author:  Richard Frith-Macdonald <rfm@gnu.org>
   
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

#ifndef _GNUstep_H_NSPasteboard
#define _GNUstep_H_NSPasteboard
#import <GNUstepBase/GSVersionMacros.h>

#import <Foundation/NSObject.h>
#import <AppKit/AppKitDefines.h>

#if defined(__cplusplus)
extern "C" {
#endif

@class NSString;
@class NSArray;
@class NSData;
@class NSFileWrapper;

/**
 * Pasteboard contains string data as written by
 * [NSPasteboard-setString:forType:] or [NSPasteboard-setPropertyList:forType:]
 */
APPKIT_EXPORT NSString *NSStringPboardType;

/**
 * Pasteboard contains color information
 */
APPKIT_EXPORT NSString *NSColorPboardType;

/**
 * Pasteboard contains generic file content information (serialized)
 * as written by [NSPasteboard-writeFileContents:] or
 * [NSPasteboard-writeFileWrapper:] 
 */
APPKIT_EXPORT NSString *NSFileContentsPboardType;

/**
 * Pasteboard contains an array of filenames (serialized)
 * as written by [NSPasteboard-setPropertyList:forType:]
 */
APPKIT_EXPORT NSString *NSFilenamesPboardType;

/**
 * Pasteboard contains font color information
 */
APPKIT_EXPORT NSString *NSFontPboardType;

/**
 * Pasteboard contains ruler color information
 */
APPKIT_EXPORT NSString *NSRulerPboardType;

/**
 * Pasteboard contains postscript code
 */
APPKIT_EXPORT NSString *NSPostScriptPboardType;

/**
 * Pasteboard contains tabular text.
 */
APPKIT_EXPORT NSString *NSTabularTextPboardType;

/**
 * Pasteboard contains text in rich text format.
 */
APPKIT_EXPORT NSString *NSRTFPboardType;

/**
 * Pasteboard contains text in rich text format with additional info
 */
APPKIT_EXPORT NSString *NSRTFDPboardType;

/**
 * Pasteboard contains a TIFF image
 */
APPKIT_EXPORT NSString *NSTIFFPboardType;

/**
 * Pasteboard contains a link to data in some document
 */
APPKIT_EXPORT NSString *NSDataLinkPboardType;

/**
 * Pasteboard contains general binary data
 */
APPKIT_EXPORT NSString *NSGeneralPboardType;

#if OS_API_VERSION(GS_API_MACOSX, GS_API_LATEST)
/**
 * Pasteboard contains a PDF document
 */
APPKIT_EXPORT NSString *NSPDFPboardType;

/**
 * Pasteboard contains a PICT diagram document
 */
APPKIT_EXPORT NSString *NSPICTPboardType;

/**
 * Pasteboard contains a URL
 */
APPKIT_EXPORT NSString *NSURLPboardType;

/**
 * Pasteboard contains HTML data
 */
APPKIT_EXPORT NSString *NSHTMLPboardType;

/**
 * Pasteboard contains VCard (address book) data
 */
APPKIT_EXPORT NSString *NSVCardPboardType;

/**
 * Pasteboard contains promised files
 */
APPKIT_EXPORT NSString *NSFilesPromisePboardType;
#endif

/**
 * The pasteboard used for drag and drop information.
 */
APPKIT_EXPORT NSString *NSDragPboard;

/**
 * The pasteboard used search and replace editing operations.
 */
APPKIT_EXPORT NSString *NSFindPboard;

/**
 * The pasteboard used for cutting and pasting font information.
 */
APPKIT_EXPORT NSString *NSFontPboard;

/**
 * The general purpose pasteboard (mostly used for cut and paste)
 */
APPKIT_EXPORT NSString *NSGeneralPboard;

/**
 * The pasteboard used for cutting and pasting ruler information.
 */
APPKIT_EXPORT NSString *NSRulerPboard;

/**
 * Exception raised when communication with the pasteboard server fails.
 */
APPKIT_EXPORT NSString *NSPasteboardCommunicationException;

  
@interface NSPasteboard : NSObject
{
  NSString	*name;		// The name of this pasteboard.
  int		changeCount;	// What we think the current count is.
  id		target;		// Proxy to the object in the server.
  id		owner;		// Local pasteboard owner.
  BOOL		useHistory;	// Want strict OPENSTEP?
}

//
// Creating and Releasing an NSPasteboard Object
//
+ (NSPasteboard*) generalPasteboard;
+ (NSPasteboard*) pasteboardWithName: (NSString*)aName;
+ (NSPasteboard*) pasteboardWithUniqueName;
- (void) releaseGlobally;

//
// Getting Data in Different Formats 
//
+ (NSPasteboard*) pasteboardByFilteringData: (NSData*)data
				     ofType: (NSString*)type;
+ (NSPasteboard*) pasteboardByFilteringFile: (NSString*)filename;
+ (NSPasteboard*) pasteboardByFilteringTypesInPasteboard: (NSPasteboard*)pboard;
+ (NSArray*) typesFilterableTo: (NSString*)type;

//
// Referring to a Pasteboard by Name 
//
- (NSString*) name;

//
// Writing Data 
//
- (int) addTypes: (NSArray*)newTypes
	   owner: (id)newOwner;
- (int) declareTypes: (NSArray*)newTypes
	       owner: (id)newOwner;
- (BOOL) setData: (NSData*)data
	 forType: (NSString*)dataType;
- (BOOL) setPropertyList: (id)propertyList
		 forType: (NSString*)dataType;
- (BOOL) setString: (NSString*)string
	   forType: (NSString*)dataType;
- (BOOL) writeFileContents: (NSString*)filename;
- (BOOL) writeFileWrapper: (NSFileWrapper*)wrapper;

//
// Determining Types 
//
- (NSString*) availableTypeFromArray: (NSArray*)types;
- (NSArray*) types;

//
// Reading Data 
//
- (int) changeCount;
- (NSData*) dataForType: (NSString*)dataType;
- (id) propertyListForType: (NSString*)dataType;
- (NSString*) readFileContentsType: (NSString*)type
			    toFile: (NSString*)filename;
- (NSFileWrapper*) readFileWrapper;
- (NSString*) stringForType: (NSString*)dataType;

@end

/**
 * The NSPasteboardOwner informal protocal defines the messages that
 * the pasteboard system will send to a pasteboard owner if they are
 * implemented.  These are needed to support lazy provision of
 * pasteboard data.
 */
@interface NSObject (NSPasteboardOwner)
/**
 * This method is called by the pasteboard system when it does not have
 * the data that has been asked for ... the pasteboard owner should
 * supply the data to the pasteboard by calling -setData:forType: or one
 * of the related methods.
 */
- (void) pasteboard: (NSPasteboard*)sender
 provideDataForType: (NSString*)type;

#if OS_API_VERSION(GS_API_NONE, GS_API_NONE)
/**
 * Implemented where GNUstep pasteboard extensions are required.<br />
 * This method is called by the pasteboard system when it does not have
 * the data that has been asked for ... the pasteboard owner should
 * supply the data to the pasteboard by calling -setData:forType: or one
 * of the related methods.
 */
- (void) pasteboard: (NSPasteboard*)sender
 provideDataForType: (NSString*)type
	 andVersion: (int)version;
#endif

/**
 * This method is called by the pasteboard system when another object
 * takes ownership of the pasteboard ... it lets the previous owner
 * know that it is no longer required to supply data.
 */
- (void) pasteboardChangedOwner: (NSPasteboard*)sender;

@end

@interface NSPasteboard (GNUstepExtensions)
+ (NSString*) mimeTypeForPasteboardType: (NSString*)type;
+ (NSString*) pasteboardTypeForMimeType: (NSString*)mimeType;
- (void) setChangeCount: (int)count;
- (void) setHistory: (unsigned)length;
@end

#if OS_API_VERSION(GS_API_MACOSX, GS_API_LATEST)
#import <Foundation/NSURL.h>

@interface NSURL (NSPasteboard)
+ (NSURL*) URLFromPasteboard: (NSPasteboard*)pasteBoard;
- (void) writeToPasteboard: (NSPasteboard*)pasteBoard;
@end

#endif
//
// Return File-related Pasteboard Types
//
APPKIT_EXPORT NSString *NSCreateFileContentsPboardType(NSString *fileType);
APPKIT_EXPORT NSString *NSCreateFilenamePboardType(NSString *fileType);
APPKIT_EXPORT NSString *NSGetFileType(NSString *pboardType);
APPKIT_EXPORT NSArray *NSGetFileTypes(NSArray *pboardTypes);

#if defined(__cplusplus)
}
#endif

#endif // _GNUstep_H_NSPasteboard
