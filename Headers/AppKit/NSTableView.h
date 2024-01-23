########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: de5ca5d2fba1744f5643bdf8510b852c8d5bd6e8
# Date: 2017-03-10 15:04:00 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 74a945ccf0dc8c716f214e08c94cbf347ef771f7
# Date: 2017-03-04 21:53:53 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: b3b138171d824eff0f643af19774ce7074113002
# Date: 2017-02-01 00:30:00 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 00fa6f58630e243832083b077da9b0615d565bac
# Date: 2017-01-30 21:19:28 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: b532d9e83ecf18271bb63dcf323bc20899ee8762
# Date: 2017-01-30 16:15:49 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 31f52310df1070560f65479c26efcfa2fac99342
# Date: 2017-01-25 15:49:14 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 49bf74a7980f5437806283b5d2b271999dea30bb
# Date: 2016-12-22 17:14:27 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 8d6d271138249fc3a1aa9d14ba4e92d549677206
# Date: 2016-12-06 23:44:45 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c950044cfcf5058adc19378da96151ead3a0dac3
# Date: 2016-10-05 17:22:21 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 8fd5ffdfb709a5444b1fd5b8f03f759f83ae6c18
# Date: 2015-08-08 21:13:26 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c6a5c9a81e2db87622cb6aabb593270345282c3e
# Date: 2015-06-11 17:48:41 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 13202adda5cdcebc4d46c711693cd9c7a827af05
# Date: 2014-12-04 21:55:21 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 1d8e1bb0b50d83e249fe941753f76c2855605f7a
# Date: 2014-03-06 16:48:06 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 3860611cea4a7249617b3d488e10a6cfd4eeefc2
# Date: 2013-12-18 15:04:29 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: ab663c24b33e1e4a30c44513ad6b40169ded0b81
# Date: 2013-12-07 20:51:40 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 0fe05a39f25b15cd39e249177b78b84850ce33bc
# Date: 2013-11-01 15:45:42 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: cdfe249de8173ffa8f24eec7c0e754b2e2b50848
# Date: 2013-10-30 20:55:04 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0
# Date: 2013-08-09 14:24:48 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 317dfe3470ad158dd4ec23fc91fdd97d4e7780f6
# Date: 2012-09-04 21:44:17 +0000
########## End of Keysight Technologies Notice ##########
/* 
   NSTableView.h

   The table class.
   
   Copyright (C) 2000 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: March 2000
   
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

#ifndef _GNUstep_H_NSTableView
#define _GNUstep_H_NSTableView

#import <AppKit/NSControl.h>
#import <AppKit/NSDragging.h>
#import <AppKit/NSUserInterfaceValidation.h>

@class NSArray;
@class NSIndexSet;
@class NSMutableIndexSet;
@class NSTableColumn;
@class NSTableHeaderView;
@class NSText;
@class NSImage;
@class NSURL;

typedef enum _NSTableViewDropOperation {
  NSTableViewDropOn,
  NSTableViewDropAbove
} NSTableViewDropOperation;

enum {
    NSTableViewGridNone                        = 0,
    NSTableViewSolidVerticalGridLineMask       = 1 << 0,
    NSTableViewSolidHorizontalGridLineMask     = 1 << 1,
    NSTableViewDashedHorizontalGridLineMask    = 1 << 3
};
typedef NSUInteger NSTableViewGridLineStyle;

#if OS_API_VERSION(MAC_OS_X_VERSION_10_4, GS_API_LATEST)
typedef enum _NSTableViewColumnAutoresizingStyle
{
    NSTableViewNoColumnAutoresizing = 0,
    NSTableViewUniformColumnAutoresizingStyle,
    NSTableViewSequentialColumnAutoresizingStyle,
    NSTableViewReverseSequentialColumnAutoresizingStyle,
    NSTableViewLastColumnOnlyAutoresizingStyle,
    NSTableViewFirstColumnOnlyAutoresizingStyle
} NSTableViewColumnAutoresizingStyle;
#endif

#if OS_API_VERSION(MAC_OS_X_VERSION_10_5, GS_API_LATEST)
typedef enum _NSTableViewSelectionHighlightStyle
{
  NSTableViewSelectionHighlightStyleNone = -1,
  NSTableViewSelectionHighlightStyleRegular = 0,
  NSTableViewSelectionHighlightStyleSourceList = 1
} NSTableViewSelectionHighlightStyle;
#endif

#if OS_API_VERSION(MAC_OS_X_VERSION_10_7, GS_API_LATEST)
typedef enum _NSTableViewAnimationOptions
{
  NSTableViewAnimationEffectNone = 0x0,
  NSTableViewAnimationEffectFade = 0x1,
  NSTableViewAnimationEffectGap  = 0x2,
  NSTableViewAnimationSlideUp    = 0x10,
  NSTableViewAnimationSlideDown  = 0x20,
  NSTableViewAnimationSlideLeft  = 0x30,
  NSTableViewAnimationSlideRight = 0x40,
} NSTableViewAnimationOptions;
#endif

/*
 * Nib compatibility struct.  This structure is used to
 * pull the attributes out of the nib that we need to fill
 * in the flags.
 */
typedef struct _tableViewFlags
{
#if GS_WORDS_BIGENDIAN == 1
  unsigned int columnOrdering:1;
  unsigned int columnResizing:1;
  unsigned int drawsGrid:1;
  unsigned int emptySelection:1;
  unsigned int multipleSelection:1;
  unsigned int columnSelection:1;
  unsigned int unknown1:1;
  unsigned int columnAutosave:1;
  unsigned int alternatingRowBackgroundColors:1;
  unsigned int unknown2:3;
  unsigned int _unused:20;
#else
  unsigned int _unused:20;
  unsigned int unknown2:3;
  unsigned int alternatingRowBackgroundColors:1;
  unsigned int columnAutosave:1;
  unsigned int unknown1:1;
  unsigned int columnSelection:1;
  unsigned int multipleSelection:1;
  unsigned int emptySelection:1;
  unsigned int drawsGrid:1;
  unsigned int columnResizing:1;
  unsigned int columnOrdering:1;
#endif
} GSTableViewFlags;


@interface NSTableView : NSControl <NSUserInterfaceValidations>
{
  /*
   * Real Ivars
   */
  id                 _dataSource;
  NSMutableArray    *_tableColumns;
  NSMutableArray    *_tableColumnsHidden;
  BOOL               _drawsGrid;
  NSColor           *_gridColor;
  NSColor           *_backgroundColor;
  NSTableViewSelectionHighlightStyle _selectionHighlightStyle;
  CGFloat            _rowHeight;
  NSSize             _intercellSpacing;
  id                 _delegate;
  NSTableHeaderView *_headerView;
  NSView            *_cornerView;
  SEL                _action;
  SEL                _doubleAction;
  id                 _target;
  NSInteger          _clickedRow;
  NSInteger          _clickedColumn;
  NSTableColumn     *_highlightedTableColumn;
  NSMutableIndexSet *_selectedColumns;
  NSMutableIndexSet *_selectedRows;
  NSInteger          _selectedColumn;
  NSInteger          _selectedRow;
  BOOL               _allowsMultipleSelection;
  BOOL               _allowsEmptySelection;
  BOOL               _allowsColumnSelection;
  BOOL               _allowsColumnResizing;
  BOOL               _allowsColumnReordering;
  BOOL               _autoresizesAllColumnsToFit;
  BOOL               _selectingColumns;
  BOOL               _usesAlternatingRowBackgroundColors;
  NSText            *_textObject;
  NSInteger          _editedRow;
  NSInteger          _editedColumn;
  NSCell            *_editedCell;
  BOOL               _autosaveTableColumns;
  NSString          *_autosaveName;
  BOOL              _verticalMotionDrag;
  NSArray           *_sortDescriptors;
  CGFloat            _lastRemainingWidth;
  BOOL               _disableAutosave;
  NSTableViewColumnAutoresizingStyle _columnAutoresizingStyle;

  /*
   * Ivars Acting as Control... 
   */
  BOOL      _isValidating;

  /*
   * Ivars Acting as Cache 
   */
  BOOL         _reloadNumberOfRows;
  NSInteger    _numberOfRows;
  NSInteger    _numberOfColumns;
  /* YES if _delegate responds to
     tableView:willDisplayCell:forTableColumn:row: */
  BOOL   _del_responds;
  /* YES if _dataSource responds to
     tableView:setObjectValue:forTableColumn:row: */
  BOOL   _dataSource_editable;

  /*
   * We cache column origins (precisely, the x coordinate of the left
   * origin of each column).  When a column width is changed through
   * [NSTableColumn setWidth:], then [NSTableView tile] gets called,
   * which updates the cache.  */
  CGFloat *_columnOrigins;

  /*
   *  We keep the superview's width in order to know when to
   *  size the last column to fit
   */
  CGFloat _superview_width;

  /* if YES [which happens only during a sizeToFit], we are doing
     computations on sizes so we ignore tile (produced for example by
     the NSTableColumns) during the computation.  We perform a global
     tile at the end */
  BOOL _tilingDisabled;

  NSDragOperation _draggingSourceOperationMaskForLocal;
  NSDragOperation _draggingSourceOperationMaskForRemote;

  NSInteger _beginEndUpdates;
  NSTableViewGridLineStyle _gridStyleMask;
}

/* Data Source */
- (void) setDataSource: (id)anObject;
- (id) dataSource;

/* Loading data */
- (void) reloadData;

/* Target-action */
- (void) setDoubleAction: (SEL)aSelector;
- (SEL) doubleAction;
- (NSInteger) clickedColumn;
- (NSInteger) clickedRow;

/* Configuration */ 
- (void) setAllowsColumnReordering: (BOOL)flag;
- (BOOL) allowsColumnReordering;
- (void) setAllowsColumnResizing: (BOOL)flag;
- (BOOL) allowsColumnResizing;
- (void) setAllowsMultipleSelection: (BOOL)flag;
- (BOOL) allowsMultipleSelection; 
- (void) setAllowsEmptySelection: (BOOL)flag;
- (BOOL) allowsEmptySelection;
- (void) setAllowsColumnSelection: (BOOL)flag;
- (BOOL) allowsColumnSelection;

/* Drawing Attributes */
- (void) setIntercellSpacing: (NSSize)aSize;
- (NSSize) intercellSpacing;
- (void) setRowHeight: (CGFloat)rowHeight;
- (CGFloat) rowHeight;
- (void) setBackgroundColor: (NSColor *)aColor;
- (NSColor *) backgroundColor;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_3, GS_API_LATEST)
- (void) setUsesAlternatingRowBackgroundColors: (BOOL)useAlternatingRowColors;
- (BOOL) usesAlternatingRowBackgroundColors;
#endif
#if OS_API_VERSION(MAC_OS_X_VERSION_10_5, GS_API_LATEST)
- (void)setSelectionHighlightStyle: (NSTableViewSelectionHighlightStyle)s;
- (NSTableViewSelectionHighlightStyle) selectionHighlightStyle;
#endif

/* Columns */
- (void) addTableColumn: (NSTableColumn *)aColumn;
- (void) removeTableColumn: (NSTableColumn *)aColumn;
- (void) moveColumn: (NSInteger)columnIndex toColumn: (NSInteger)newIndex;
- (NSArray *) tableColumns;
- (NSInteger) columnWithIdentifier: (id)identifier;
- (NSTableColumn *) tableColumnWithIdentifier: (id)anObject;

/* Selecting Columns and Rows */
- (void) selectColumn: (NSInteger) columnIndex byExtendingSelection: (BOOL)flag;
- (void) selectRow: (NSInteger) rowIndex byExtendingSelection: (BOOL)flag;
- (void) selectColumnIndexes: (NSIndexSet *)indexes byExtendingSelection: (BOOL)extend;
- (void) selectRowIndexes: (NSIndexSet *)indexes byExtendingSelection: (BOOL)extend;
- (NSIndexSet *) selectedColumnIndexes;
- (NSIndexSet *) selectedRowIndexes;
- (void) deselectColumn: (NSInteger)columnIndex;
- (void) deselectRow: (NSInteger)rowIndex;
- (NSInteger) numberOfSelectedColumns;
- (NSInteger) numberOfSelectedRows;
- (NSInteger) selectedColumn;
- (NSInteger) selectedRow;
- (BOOL) isColumnSelected: (NSInteger)columnIndex;
- (BOOL) isRowSelected: (NSInteger)rowIndex;
- (NSEnumerator *) selectedColumnEnumerator;
- (NSEnumerator *) selectedRowEnumerator;
- (void) selectAll: (id)sender;
- (void) deselectAll: (id)sender;

/* Table Dimensions */
- (NSInteger) numberOfColumns;
- (NSInteger) numberOfRows;

/* Grid Drawing attributes */
- (void) setDrawsGrid: (BOOL)flag;
- (BOOL) drawsGrid;
- (void) setGridColor: (NSColor *)aColor;
- (NSColor *) gridColor;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_3, GS_API_LATEST)
- (void) setGridStyleMask: (NSTableViewGridLineStyle)gridType;
- (NSTableViewGridLineStyle) gridStyleMask;
#endif

/* Proving Cells */

#if OS_API_VERSION(MAC_OS_X_VERSION_10_5, GS_API_LATEST)
- (NSCell *) preparedCellAtColumn: (NSInteger)columnIndex row: (NSInteger)rowIndex;
#endif

/* Editing Cells */
/* ALL TODOS */
- (void) editColumn: (NSInteger)columnIndex 
                row: (NSInteger)rowIndex 
          withEvent: (NSEvent *)theEvent 
             select: (BOOL)flag;
- (NSInteger) editedRow;
- (NSInteger) editedColumn;

/* Auxiliary Components */
- (void) setHeaderView: (NSTableHeaderView*)aHeaderView;
- (NSTableHeaderView*) headerView;
- (void) setCornerView: (NSView*)aView;
- (NSView*) cornerView;

/* Layout */
- (NSRect) rectOfColumn: (NSInteger)columnIndex;
- (NSRect) rectOfRow: (NSInteger)rowIndex;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_5, GS_API_LATEST)
- (NSIndexSet *) columnIndexesInRect: (NSRect)aRect;
#endif
- (NSRange) columnsInRect: (NSRect)aRect;
- (NSRange) rowsInRect: (NSRect)aRect;
- (NSInteger) columnAtPoint: (NSPoint)aPoint;
- (NSInteger) rowAtPoint: (NSPoint)aPoint;
- (NSRect) frameOfCellAtColumn: (NSInteger)columnIndex 
			   row: (NSInteger)rowIndex;
- (void) setAutoresizesAllColumnsToFit: (BOOL)flag;
- (BOOL) autoresizesAllColumnsToFit;
- (void) sizeLastColumnToFit;
- (void) noteNumberOfRowsChanged;
- (void) tile;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_4, GS_API_LATEST)
- (NSTableViewColumnAutoresizingStyle) columnAutoresizingStyle;
- (void) setColumnAutoresizingStyle: (NSTableViewColumnAutoresizingStyle)style;
- (void) noteHeightOfRowsWithIndexesChanged: (NSIndexSet*)indexes;
#endif

/* Drawing */
- (void) drawRow: (NSInteger)rowIndex clipRect: (NSRect)clipRect;
- (void) drawGridInClipRect: (NSRect)aRect;
- (void) highlightSelectionInClipRect: (NSRect)clipRect;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_3, GS_API_LATEST)
- (void) drawBackgroundInClipRect: (NSRect)clipRect;
#endif

/* Scrolling */
- (void) scrollRowToVisible: (NSInteger)rowIndex;
- (void) scrollColumnToVisible: (NSInteger)columnIndex;

/* Text delegate methods */
- (BOOL) textShouldBeginEditing: (NSText *)textObject;
- (void) textDidBeginEditing: (NSNotification *)aNotification;
- (void) textDidChange: (NSNotification *)aNotification;
- (BOOL) textShouldEndEditing: (NSText *)textObject;
- (void) textDidEndEditing: (NSNotification *)aNotification;

/* Persistence */
- (NSString *) autosaveName;
- (BOOL) autosaveTableColumns;
- (void) setAutosaveName: (NSString *)name;
- (void) setAutosaveTableColumns: (BOOL)flag;

/* Delegate */
- (void) setDelegate: (id)anObject;
- (id) delegate;

/* indicator image */
/* NB: ALL TODOS */
- (NSImage *) indicatorImageInTableColumn: (NSTableColumn *)aTableColumn;
- (void) setIndicatorImage: (NSImage *)anImage
	     inTableColumn: (NSTableColumn *)aTableColumn;

/* highlighting columns */
/* NB: ALL TODOS */
- (NSTableColumn *) highlightedTableColumn;
- (void) setHighlightedTableColumn: (NSTableColumn *)aTableColumn;

/* dragging rows */
/* NB: ALL TODOS */
- (NSImage*) dragImageForRows: (NSArray*)dragRows
                        event: (NSEvent*)dragEvent
              dragImageOffset: (NSPoint*)dragImageOffset;
- (void) setDropRow: (NSInteger)row
      dropOperation: (NSTableViewDropOperation)operation;
- (void) setVerticalMotionCanBeginDrag: (BOOL)flag;
- (BOOL) verticalMotionCanBeginDrag;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_4, GS_API_LATEST)
- (BOOL) canDragRowsWithIndexes: (NSIndexSet*)indexes 
                        atPoint: (NSPoint)point;
- (NSImage *) dragImageForRowsWithIndexes: (NSIndexSet*)rows
                             tableColumns: (NSArray*)cols
                                    event: (NSEvent*)event
                                   offset: (NSPoint*)offset;
- (void) setDraggingSourceOperationMask: (NSDragOperation)mask
                               forLocal: (BOOL)isLocal;
#endif

/* sorting */
#if OS_API_VERSION(MAC_OS_X_VERSION_10_3, GS_API_LATEST)
- (void) setSortDescriptors: (NSArray *)array;
- (NSArray *) sortDescriptors;
#endif

#if OS_API_VERSION(MAC_OS_X_VERSION_10_6, GS_API_LATEST)
- (void) reloadDataForRowIndexes: (NSIndexSet*)rowIndexes columnIndexes: (NSIndexSet*)columnIndexes;
#endif

#if OS_API_VERSION(MAC_OS_X_VERSION_10_7, GS_API_LATEST)
- (void) beginUpdates;
- (void) endUpdates;
- (NSInteger) columnForView: (NSView*)view;
- (void) insertRowsAtIndexes: (NSIndexSet*)indexes withAnimation: (NSTableViewAnimationOptions)animationOptions;
- (void) removeRowsAtIndexes: (NSIndexSet*)indexes withAnimation: (NSTableViewAnimationOptions)animationOptions;
- (NSInteger) rowForView: (NSView*)view;
#endif

@end /* interface of NSTableView */

@interface NSTableView (GNUPrivate)
- (void) _sendDoubleActionForColumn: (NSInteger)columnIndex;
- (void) _selectColumn: (NSInteger)columnIndex  
	     modifiers: (unsigned int)modifiers;
@end

/* 
 * Informal protocol NSTableDataSource 
 */

@protocol NSTableViewDataSource
#if OS_API_VERSION(MAC_OS_X_VERSION_10_6, GS_API_LATEST) && GS_PROTOCOLS_HAVE_OPTIONAL
@optional
#else
@end
@interface NSObject (NSTableDataSource)
#endif

/**
 * Returns the number of records that the data source manages for <em>aTableView</em>.
 */
- (NSInteger) numberOfRowsInTableView: (NSTableView *)aTableView;
- (id) tableView: (NSTableView *)aTableView 
objectValueForTableColumn: (NSTableColumn *)aTableColumn 
	     row: (NSInteger)rowIndex;
- (void) tableView: (NSTableView *)aTableView 
    setObjectValue: (id)anObject 
    forTableColumn: (NSTableColumn *)aTableColumn
	       row: (NSInteger)rowIndex;

/* Dragging */
- (BOOL) tableView: (NSTableView*)tableView
        acceptDrop: (id <NSDraggingInfo>)info
               row: (NSInteger)row
     dropOperation: (NSTableViewDropOperation)operation;
- (NSDragOperation) tableView: (NSTableView*)tableView
                 validateDrop: (id <NSDraggingInfo>)info
                  proposedRow: (NSInteger)row
	proposedDropOperation: (NSTableViewDropOperation)operation;
- (BOOL) tableView: (NSTableView*)tableView
         writeRows: (NSArray*)rows
      toPasteboard: (NSPasteboard*)pboard;

#if OS_API_VERSION(MAC_OS_X_VERSION_10_3, GS_API_LATEST)
- (void) tableView: (NSTableView*)tableView
  sortDescriptorsDidChange: (NSArray *)oldSortDescriptors;
#endif

#if OS_API_VERSION(MAC_OS_X_VERSION_10_4, GS_API_LATEST)
- (BOOL) tableView: (NSTableView*)tableView
writeRowsWithIndexes: (NSIndexSet*)rows
      toPasteboard: (NSPasteboard*)pboard;
- (NSArray *) tableView: (NSTableView *)aTableView
namesOfPromisedFilesDroppedAtDestination: (NSURL *)dropDestination
forDraggedRowsWithIndexes: (NSIndexSet *)indexSet;
#endif
@end

APPKIT_EXPORT NSString *NSTableViewColumnDidMoveNotification;
APPKIT_EXPORT NSString *NSTableViewColumnDidResizeNotification;
APPKIT_EXPORT NSString *NSTableViewSelectionDidChangeNotification;
APPKIT_EXPORT NSString *NSTableViewSelectionIsChangingNotification;

/*
 * Methods Implemented by the Delegate
 */

@protocol NSTableViewDelegate <NSObject>
#if OS_API_VERSION(MAC_OS_X_VERSION_10_6, GS_API_LATEST) && GS_PROTOCOLS_HAVE_OPTIONAL
@optional
#else
@end
@interface NSObject (NSTableViewDelegate)
#endif
- (BOOL) selectionShouldChangeInTableView: (NSTableView *)aTableView;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_3, GS_API_LATEST)
- (void) tableView: (NSTableView*)tableView
didClickTableColumn: (NSTableColumn *)tableColumn;
- (void) tableView: (NSTableView*)tableView
didDragTableColumn: (NSTableColumn *)tableColumn;
- (void) tableView: (NSTableView*)tableView
mouseDownInHeaderOfTableColumn: (NSTableColumn *)tableColumn;
#endif
- (BOOL)tableView: (NSTableView *)aTableView 
shouldEditTableColumn: (NSTableColumn *)aTableColumn 
	      row: (NSInteger)rowIndex;
- (BOOL) tableView: (NSTableView *)aTableView 
   shouldSelectRow: (NSInteger)rowIndex;
- (BOOL) tableView: (NSTableView *)aTableView 
shouldSelectTableColumn: (NSTableColumn *)aTableColumn;
- (void) tableView: (NSTableView *)aTableView 
   willDisplayCell: (id)aCell 
    forTableColumn: (NSTableColumn *)aTableColumn
	       row: (NSInteger)rowIndex;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_5, GS_API_LATEST)
- (NSCell *) tableView: (NSTableView *)aTableView 
dataCellForTableColumn: (NSTableColumn *)aTableColumn
		   row: (NSInteger)rowIndex;
#endif
- (void) tableViewColumnDidMove: (NSNotification *)aNotification;
- (void) tableViewColumnDidResize: (NSNotification *)aNotification;
- (void) tableViewSelectionDidChange: (NSNotification *)aNotification;
- (void) tableViewSelectionIsChanging: (NSNotification *)aNotification;
#if OS_API_VERSION(MAC_OS_X_VERSION_10_4, GS_API_LATEST)
- (CGFloat) tableView: (NSTableView *)tableView
          heightOfRow: (NSInteger)row;
- (NSString *) tableView: (NSTableView *)tableView
          toolTipForCell: (NSCell *)cell
                    rect: (NSRect *)rect
             tableColumn: (NSTableColumn *)col
                     row: (NSInteger)row
           mouseLocation: (NSPoint)mouse;
#endif

#if OS_API_VERSION(MAC_OS_X_VERSION_10_5, GS_API_LATEST)
- (BOOL)tableView:(NSTableView*)tableView isGroupRow:(NSInteger)row;
- (NSCell *)tableView:(NSTableView*)tableView dataCellForTableColumn:(NSTableColumn*)tableColumn row:(NSInteger)row;
- (NSIndexSet *)tableView:(NSTableView*)tableView selectionIndexesForProposedSelection:(NSIndexSet*)proposedSelectionIndexes;
#endif

@end

#endif /* _GNUstep_H_NSTableView */
