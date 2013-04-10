//
//  MyDocument.m
//  BezierBuilder
//
//  Created by Dave DeLong on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyDocument.h"
#import "BezierPoint.h"

#import "CodeBuilder.h"
#import "NSBezierPathCodeBuilder.h"
#import "CGPathRefCodeBuilder.h"

@implementation MyDocument

@synthesize bezierView, bezierCodeView;
@synthesize codeOption;
@synthesize originControl;
@synthesize codeStyleControl;
@synthesize customPointsField;

- (void) rebuildSteps {
	
	Class builderClass = Nil;
	if ([codeStyleControl selectedSegment] == 0) {
		builderClass = [NSBezierPathCodeBuilder class];
	}
	else {
		builderClass = [CGPathRefCodeBuilder class];
	}
	
	CodeBuilder *builder = [[builderClass alloc] init];
	[builder setBezierPoints:[bezierView bezierPoints]];
	if ([originControl selectedSegment] == 1) {
		[builder setYOrigin:[bezierView bounds].size.height];
	}
	else {
		[builder setYOrigin:0.0];
	}
	[bezierCodeView setString:[builder codeForBezierPoints]];
	[builder release];
}

- (void) codeOptionChanged:(id)sender {
	[self rebuildSteps];
}

- (void) loadCustomPoints:(id)sender {
    NSString* pointsText = [self.customPointsField stringValue];

    // Sample Data
    [self addBezierPointsFromString:pointsText];
    [self elementsDidChangeInBezierView:bezierView];
}

- (void) addBezierPointsFromString:(NSString*)string {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // Remove white space and brackets
    NSString* newString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"{" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    NSArray *numbers = [newString componentsSeparatedByString:@","];
    
    // Iterate thru the number
    // sequence is first 2 number is point 1,
    // 3rd and 4th is control point 1
    // 5th and 6th is control point 2
    // 6th and 7th is point 2
    // repeat
    int nIndex = 0;
    
    for (nIndex=0; nIndex<[numbers count]; nIndex++) {
        
        CGPoint local_point = CGPointZero;
        CGPoint control1 = CGPointZero;
        CGPoint control2 = CGPointZero;
        float bezierViewHeight = [bezierView bounds].size.height;
        
        if (nIndex == 0) {
            // First one
            float fFirstNumber = [[numbers objectAtIndex:nIndex] floatValue];
            nIndex++;
            float fSecondNumber = bezierViewHeight- [[numbers objectAtIndex:nIndex] floatValue];
            
            local_point = CGPointMake(fFirstNumber, fSecondNumber);
            control1 = local_point;
            control2 = local_point;
        }
        else {
            // control1
            float fFirstNumber = [[numbers objectAtIndex:nIndex] floatValue];
            nIndex++;
            float fSecondNumber = bezierViewHeight- [[numbers objectAtIndex:nIndex] floatValue];
            control1 = CGPointMake(fFirstNumber, fSecondNumber);
            
            // control2
            nIndex++;
            fFirstNumber = [[numbers objectAtIndex:nIndex] floatValue];
            nIndex++;
            fSecondNumber = bezierViewHeight- [[numbers objectAtIndex:nIndex] floatValue];
            control2 = CGPointMake(fFirstNumber, fSecondNumber);
            
            // local_point
            nIndex++;
            fFirstNumber = [[numbers objectAtIndex:nIndex] floatValue];
            nIndex++;
            fSecondNumber = bezierViewHeight- [[numbers objectAtIndex:nIndex] floatValue];
            local_point = CGPointMake(fFirstNumber, fSecondNumber);
        }
        
        BezierPoint *newPoint = [[BezierPoint alloc] init];
        [newPoint setMainPoint:NSPointFromCGPoint(local_point)];
        [newPoint setControlPoint1:NSPointFromCGPoint(control1)];
        [newPoint setControlPoint2:NSPointFromCGPoint(control2)];
        [(NSMutableArray*)bezierView.bezierPoints addObject:newPoint];
    }
}

- (void) elementsDidChangeInBezierView:(BezierView *)view {
	[self rebuildSteps];
	[bezierView setNeedsDisplay:YES];
}

- (id)init
{
    self = [super init];
    if (self) {
 
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@end
