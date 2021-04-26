//
//  CGGeometry
//  MTcams
//
//  Created by Milovan Tomasevic on 06/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "UIView+CGGeometry.h"

@implementation UIView (CGGeometry)

#pragma mark - Size

- (void)setWidth:(CGFloat)width {self.frame = CGRectWithWidth(self.frame, width);}
- (CGFloat)width {return self.frame.size.width;}
- (CGFloat)halfWidth {return (self.width * 0.5);}

- (void)setHeight:(CGFloat)height {self.frame = CGRectWithHeight(self.frame, height);}
- (CGFloat)height {return self.frame.size.height;}
- (CGFloat)halfHeight {return (self.height * 0.5);}

- (void)setSize:(CGSize)size {self.frame = CGRectWidthSize(self.frame, size);}
- (CGSize)size {return self.frame.size;}

#pragma mark - Position

- (void)setX:(CGFloat)x {self.frame = CGRectWithX(self.frame, x);}
- (CGFloat)x {return self.frame.origin.x;}
- (CGFloat)minX {return CGRectGetMinX(self.frame);}
- (CGFloat)maxX {return CGRectGetMaxX(self.frame);}

- (void)setY:(CGFloat)y {self.frame = CGRectWithY(self.frame, y);}
- (CGFloat)y {return self.frame.origin.y;}
- (CGFloat)minY {return CGRectGetMinY(self.frame);}
- (CGFloat)maxY {return CGRectGetMaxY(self.frame);}

- (void)setOrigin:(CGPoint)origin {self.frame = CGRectWithOrigin(self.frame, origin);}
- (CGPoint)origin {return self.frame.origin;}

#pragma mark -

- (void)setOriginWithX:(CGFloat)x YcenteredIn:(CGRect)parentFrame {
    self.origin = CGPointMake(x, (parentFrame.size.height/2 - self.halfHeight));
}

- (void)setOriginWithY:(CGFloat)y XcenteredIn:(CGRect)parentFrame {
    self.origin = CGPointMake(parentFrame.size.width/2 - self.halfWidth, y);
}

@end
