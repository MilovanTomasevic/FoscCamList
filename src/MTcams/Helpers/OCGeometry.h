//
//  CGGeometry.h
//  MTcams
//
//  Created by Milovan Tomasevic on 06/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#ifndef OCGeometry_h
#define OCGeometry_h

#pragma mark - Position

CG_INLINE CGRect CGRectWithX(CGRect r, CGFloat x) {
    r.origin.x = x; return r;
}

CG_INLINE CGRect CGRectWithY(CGRect r, CGFloat y) {
    r.origin.y = y; return r;
}

CG_INLINE CGRect CGRectWithOrigin(CGRect r, CGPoint origin) {
    r.origin = origin; return r;
}

#pragma mark - Size

// CGRect
CG_INLINE CGRect CGRectWithWidth(CGRect r, CGFloat w) {
    r.size.width = w; return r;
}

CG_INLINE CGRect CGRectWithHeight(CGRect r, CGFloat h) {
    r.size.height = h; return r;
}

CG_INLINE CGRect CGRectWidthSize(CGRect r, CGSize size) {
    r.size = size; return r;
}

// CGSize
CG_INLINE CGSize CGSizeMakeSquare(CGFloat s) {
    return CGSizeMake(s, s);
}

CG_INLINE CGFloat CGHalfWidth(CGRect r) {
    return r.size.width * 0.5;
}

CG_INLINE CGFloat CGHalfHeight(CGRect r) {
    return r.size.height * 0.5;
}

#endif /* OCGeometry_h */
