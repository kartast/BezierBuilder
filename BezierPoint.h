//
//  BezierPoint.h
//  BezierBuilder
//
//  Created by Dave DeLong on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BezierPoint : NSObject {
    NSPoint mainPoint;
    NSPoint controlPoint1;
    NSPoint controlPoint2;
}

@property NSPoint mainPoint;
@property NSPoint controlPoint1;
@property NSPoint controlPoint2;

@end
