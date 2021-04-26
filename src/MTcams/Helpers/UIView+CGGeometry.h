//
//  CGGeometry
//  MTcams
//
//  Created by Milovan Tomasevic on 06/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCGeometry.h"

@interface UIView (CGGeometry)

// Size
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat halfWidth;
@property (nonatomic, assign, readonly) CGFloat halfHeight;
@property (nonatomic, assign) CGSize size;

// Position
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign, readonly) CGFloat minX;
@property (nonatomic, assign, readonly) CGFloat maxX;

@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign, readonly) CGFloat minY;
@property (nonatomic, assign, readonly) CGFloat maxY;
@property (nonatomic, assign) CGPoint origin;

- (void)setOriginWithX:(CGFloat)x YcenteredIn:(CGRect)parentFrame;
- (void)setOriginWithY:(CGFloat)y XcenteredIn:(CGRect)parentFrame;

@end
