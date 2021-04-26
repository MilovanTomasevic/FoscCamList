//
//  PageControl.m
//  MTcams
//
//  Created by administrator on 5/22/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "PageControl.h"

@implementation PageControl


- (void) drawRect: (CGRect)rect
{

    // get the current context
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    
    // save the context
    CGContextSaveGState(context);
    
    // allow antialiasing
    CGContextSetAllowsAntialiasing(context, TRUE);
    
    // get the caller's diameter if it has been set or use the default one
    CGFloat diametar = 11.f;
    CGFloat space = 12.f;
    
    //geometry
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages * diametar + MAX(0, self.numberOfPages - 1) * space;
    CGFloat x = CGRectGetMaxX(currentBounds) - dotsWidth / 2 ;
    CGFloat y = CGRectGetMaxY(currentBounds) - diametar / 2;
    
    // get the caller's colors it they have been set or use the defaults
    // custom colour
    
    UIColor *selectedColor;
    UIColor *nonSelectedColor;
    
    selectedColor = [UIColor orangeColor];
    nonSelectedColor = [UIColor whiteColor];
    
    // actually draw the dots
    
    for (int i =0; i < self.numberOfPages; i++) {
        
        CGRect dotRect = CGRectMake(x, y, diametar, diametar);
        if (i == self.currentPage) {
            CGContextSetFillColorWithColor(context, selectedColor.CGColor) ;
            CGContextFillEllipseInRect(context, CGRectInset(dotRect, -0.5f, -0.5f)) ;
        }else{
            CGContextSetFillColorWithColor(context, nonSelectedColor.CGColor) ;
            CGContextFillEllipseInRect(context, CGRectInset(dotRect, -0.5f, -0.5f)) ;
        }
        x += diametar + space;
    }
    CGContextRestoreGState(context);
}

-(void) setCurrentPage:(NSInteger)page{
    [super setCurrentPage:page];
    [self setNeedsDisplay];
}
@end
