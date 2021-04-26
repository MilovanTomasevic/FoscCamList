//
//  OCCameraGuestureRecognizer.m
//  MTcams
//
//  Created by administrator on 4/6/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "OCCameraGuestureRecognizer.h"

#import "OCCameraGuestureRecognizer.h"

static const float kMinSpeedForPan = 10.0; //higher number less small vibrations will be detected as pan gesture
static const float kSlopeMoveDetect = 0.2; //lower this number to get more area for X and Y directions

@implementation OCCameraGuestureRecognizer{
    UICameraPanGestureEvent _lastPanEvent;
    UICameraZoomGestureEvent _lastZoomEvent;
    UIPanGestureRecognizer* _panRecognizer;
    UIPinchGestureRecognizer* _pinchRecognizer;
    
    UIView* view;
}

-(id)init{
    self = [super init];
    if(self){
        _lastPanEvent = UICameraPanGestureEventStop;
        _lastZoomEvent = UICameraZoomGestureEventStop;
        
        _panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        _panRecognizer.minimumNumberOfTouches = 1;
        _panRecognizer.maximumNumberOfTouches = 1;
        
        _pinchRecognizer= [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    }
    return self;
}

-(void)addGestureRecognizer:(UIView*) forView{
    view = forView;
    [view addGestureRecognizer:_pinchRecognizer];
    [view addGestureRecognizer:_panRecognizer];
}

-(void)removeGestureRecognizer{
    [view removeGestureRecognizer:_pinchRecognizer];
    [view removeGestureRecognizer:_panRecognizer];
}

- (void)pan:(UIPanGestureRecognizer *)sender
{
    CGPoint velocity = CGPointMake(0, 0);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            velocity = [sender velocityInView:sender.view];
            if(sqrt(fabs(velocity.x)+fabs(velocity.y))>kMinSpeedForPan){ // ignore to small moves(trembling)
                // detect is movment of x, y or slope type
                if( (fabs(velocity.y) > fabs(velocity.x*(1.0-kSlopeMoveDetect))) && (fabs(velocity.y) < fabs(velocity.x*(1.0+kSlopeMoveDetect))) ){
                    if (velocity.y > 0) {
                        if (velocity.x > 0) {
                            [self handleDirection:UICameraPanGestureEventDownRight];
                        } else {
                            [self handleDirection:UICameraPanGestureEventDownLeft];
                        }
                    } else {
                        if (velocity.x > 0) {
                            [self handleDirection:UICameraPanGestureEventUpRight];
                        } else {
                            [self handleDirection:UICameraPanGestureEventUpLeft];
                        }
                    }
                }else{
                    if (fabs(velocity.y) > fabs(velocity.x)){
                        if (velocity.y > 0) {
                            [self handleDirection:UICameraPanGestureEventDown];
                        } else {
                            [self handleDirection:UICameraPanGestureEventUp];
                        }
                    }else{
                        if (velocity.x > 0) {
                            [self handleDirection:UICameraPanGestureEventRight];
                        } else {
                            [self handleDirection:UICameraPanGestureEventLeft];
                        }
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self handleDirection:UICameraPanGestureEventStop];
            break;
        }
        default:
            break;
    }
}

- (void)handleDirection:(UICameraPanGestureEvent) newDirection{
    if(_lastPanEvent!=newDirection){
        _lastPanEvent = newDirection;
        if ([self.delegate respondsToSelector:@selector(onPanEvent:)]) {
            [self.delegate onPanEvent: newDirection];
        }
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            if (sender.velocity > 0.0) {
                [self handleZoom:UICameraZoomGestureEventZoomIn];
            } else {
                [self handleZoom:UICameraZoomGestureEventZoomOut];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self handleZoom:UICameraZoomGestureEventStop];
            break;
        }
        default:
            break;
    }
}

- (void)handleZoom:(UICameraZoomGestureEvent) newZoomDirection{
    if(_lastZoomEvent!=newZoomDirection){
        _lastZoomEvent = newZoomDirection;
        if ([self.delegate respondsToSelector:@selector(onZoomEvent:)]) {
            [self.delegate onZoomEvent:newZoomDirection];
        }
    }
}


@end
