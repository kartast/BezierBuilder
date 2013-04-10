//
//  CustomSheetController.h
//  BezierBuilder
//
//  Created by karta on 10/4/13.
//
//

#import <Cocoa/Cocoa.h>

typedef void (^CustomCompletionHandler)(NSUInteger result);

@interface CustomSheetController : NSWindowController

- (void)beginSheetModalForWindow:(NSWindow *)window completionHandler:(CustomCompletionHandler)aHandler;

// Convenience methods for subclasses to use
- (void)endSheetWithReturnCode:(NSUInteger)result;
- (void)sheetWillDisplay; // Default does nothing

@end
