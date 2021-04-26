//
//  OCCameraGuestureRecognizer.h
//  MTcams
//
//  Created by administrator on 4/6/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol OCCameraGuestureDelegate <NSObject>


// do not change order !!!
typedef NS_ENUM(NSUInteger, UICameraPanGestureEvent) {
    UICameraPanGestureEventStop,
    UICameraPanGestureEventUp,
    UICameraPanGestureEventUpRight,
    UICameraPanGestureEventRight,
    UICameraPanGestureEventDownRight,
    UICameraPanGestureEventDown,
    UICameraPanGestureEventDownLeft,
    UICameraPanGestureEventLeft,
    UICameraPanGestureEventUpLeft
};

typedef NS_ENUM(NSUInteger, UICameraZoomGestureEvent) {
    UICameraZoomGestureEventZoomIn,
    UICameraZoomGestureEventZoomOut,
    UICameraZoomGestureEventStop
};

- (void)onPanEvent:(UICameraPanGestureEvent)event;

- (void)onZoomEvent:(UICameraZoomGestureEvent)event;

@end

@interface OCCameraGuestureRecognizer : NSObject

/*! @brief property for set delegate method */
@property (nonatomic, strong) id <OCCameraGuestureDelegate> delegate;

-(void)addGestureRecognizer:(UIView*) forView;

-(void)removeGestureRecognizer;

@end


