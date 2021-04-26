
//
//  MarqueeTextField.m
//
//  Created by Charles Powell on 1/31/11.
//  Copyright (c) 2011-2015 Charles Powell. All rights reserved.
//

#import "MarqueeTextField.h"
#import <QuartzCore/QuartzCore.h>

// Notification strings
NSString *const kMarqueeTextFieldControllerRestartNotification = @"MarqueeTextFieldViewControllerRestart";
NSString *const kMarqueeTextFieldShouldLabelizeNotification = @"MarqueeTextFieldShouldLabelizeNotification";
NSString *const kMarqueeTextFieldShouldAnimateNotification = @"MarqueeTextFieldShouldAnimateNotification";
NSString *const kMarqueeTextFieldAnimationCompletionBlock = @"MarqueeTextFieldAnimationCompletionBlock";


//static const CFTimeInterval kMinimumPressDuration = 0.5;


// Animation completion block
typedef void(^MLAnimationCompletionBlock)(BOOL finished);

// iOS Version check for iOS 8.0.0
#define SYSTEM_VERSION_IS_8_0_X ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"8.0"])

// Helpers
@interface UIView (MarqueeTextFieldHelpers)
- (UIViewController *)firstAvailableViewController;
- (id)traverseResponderChainForFirstViewController;
@end

@interface CAMediaTimingFunction (MarqueeTextFieldHelpers)
- (NSArray *)controlPoints;
- (CGFloat)durationPercentageForPositionPercentage:(CGFloat)positionPercentage withDuration:(NSTimeInterval)duration;
@end

@interface MarqueeTextField()

@property (nonatomic, strong) UITextField *subtextField;

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign, readonly) BOOL labelShouldScroll;
@property (nonatomic, weak) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, assign) CGRect homeLabelFrame;
@property (nonatomic, assign) CGFloat awayOffset;
@property (nonatomic, assign, readwrite) BOOL isPaused;

// Support
@property (nonatomic, strong) NSArray *gradientColors;
CGPoint MLOffsetCGPoint(CGPoint point, CGFloat offset);

@end


@implementation MarqueeTextField

#pragma mark - Class Methods and handlers

+ (void)restartLabelsOfController:(UIViewController *)controller {
    [MarqueeTextField notifyController:controller
                           withMessage:kMarqueeTextFieldControllerRestartNotification];
}

+ (void)controllerViewWillAppear:(UIViewController *)controller {
    [MarqueeTextField restartLabelsOfController:controller];
}

+ (void)controllerViewDidAppear:(UIViewController *)controller {
    [MarqueeTextField restartLabelsOfController:controller];
}

+ (void)controllerViewAppearing:(UIViewController *)controller {
    [MarqueeTextField restartLabelsOfController:controller];
}

+ (void)controllerLabelsShouldLabelize:(UIViewController *)controller {
    [MarqueeTextField notifyController:controller
                           withMessage:kMarqueeTextFieldShouldLabelizeNotification];
}

+ (void)controllerLabelsShouldAnimate:(UIViewController *)controller {
    [MarqueeTextField notifyController:controller
                           withMessage:kMarqueeTextFieldShouldAnimateNotification];
}

+ (void)notifyController:(UIViewController *)controller withMessage:(NSString *)message
{
    if (controller && message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:message
                                                            object:nil
                                                          userInfo:[NSDictionary dictionaryWithObject:controller
                                                                                               forKey:@"controller"]];
    }
}

- (void)viewControllerShouldRestart:(NSNotification *)notification {
    UIViewController *controller = [[notification userInfo] objectForKey:@"controller"];
    if (controller == [self firstAvailableViewController]) {
        [self restartLabel];
    }
}

- (void)labelsShouldLabelize:(NSNotification *)notification {
    UIViewController *controller = [[notification userInfo] objectForKey:@"controller"];
    if (controller == [self firstAvailableViewController]) {
        self.labelize = YES;
    }
}

- (void)labelsShouldAnimate:(NSNotification *)notification {
    UIViewController *controller = [[notification userInfo] objectForKey:@"controller"];
    if (controller == [self firstAvailableViewController]) {
        self.labelize = NO;
    }
}

#pragma mark - Initialization and Label Config

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame duration:kMarqueeScrollDuration andFadeLength:0.0];
}

- (id)initWithFrame:(CGRect)frame duration:(NSTimeInterval)aLengthOfScroll andFadeLength:(CGFloat)aFadeLength {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLabel];

        _scrollDuration = aLengthOfScroll;
        self.fadeLength = MIN(aFadeLength, frame.size.width/2);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame rate:(CGFloat)pixelsPerSec andFadeLength:(CGFloat)aFadeLength {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLabel];

        _rate = pixelsPerSec;
        self.fadeLength = MIN(aFadeLength, frame.size.width/2);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLabel];

        if (self.scrollDuration == 0) {
            self.scrollDuration = kMarqueeScrollDuration;
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self forwardPropertiesToSubLabel];
}

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

- (CAReplicatorLayer *)repliLayer {
    return (CAReplicatorLayer *)self.layer;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    // Do NOT call super, to prevent UILabel superclass from drawing into context
    // Label drawing is handled by sublabel and CAReplicatorLayer layer class
}

- (void)forwardPropertiesToSubLabel {
    /*
     Note that this method is currently ONLY called from awakeFromNib, i.e. when
     text properties are set via a Storyboard. As the Storyboard/IB doesn't currently
     support attributed strings, there's no need to "forward" the super attributedString value.
     */

    // Since we're a UILabel, we actually do implement all of UILabel's properties.
    // We don't care about these values, we just want to forward them on to our sublabel.
    NSArray *properties = @[@"enabled", @"textAlignment",
                            @"userInteractionEnabled", @"adjustsFontSizeToFitWidth"];

    // Iterate through properties
    self.subtextField.text = super.text;
    self.subtextField.font = super.font;
    self.subtextField.textColor = super.textColor;
    self.subtextField.delegate = super.delegate;
    self.subtextField.tag = super.tag;
    self.subtextField.leftViewMode = super.leftViewMode;
    self.subtextField.leftView = super.leftView;
    self.returnKeyType = super.returnKeyType;

    self.subtextField.backgroundColor = (super.backgroundColor == nil ? [UIColor clearColor] : super.backgroundColor);
    for (NSString *property in properties) {
        id val = [super valueForKey:property];
        [self.subtextField setValue:val forKey:property];
    }
}

- (void)setupLabel {

    // Basic UILabel options override
    self.clipsToBounds = YES;

    // Create first sublabel
    self.subtextField = [[UITextField alloc] initWithFrame:self.bounds];
    self.subtextField.tag = kSetupLabelSubtextFieldTag;
    self.subtextField.layer.anchorPoint = CGPointMake(0.0f, 0.0f);

    [self addSubview:self.subtextField];

    // Setup default values
    _awayOffset = 0.0f;
    _animationCurve = UIViewAnimationOptionCurveLinear;
    _labelize = NO;
    _holdScrolling = NO;
    _tapToScroll = NO;
    _isPaused = NO;
    _fadeLength = 0.0f;
    _animationDelay = 1.0;
    _animationDuration = 0.0f;
    _leadingBuffer = 0.0f;
    _trailingBuffer = 0.0f;

    // Add notification observers
    // Custom class notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerShouldRestart:) name:kMarqueeTextFieldControllerRestartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelsShouldLabelize:) name:kMarqueeTextFieldShouldLabelizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelsShouldAnimate:) name:kMarqueeTextFieldShouldAnimateNotification object:nil];

    // UINavigationController view controller change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observedViewControllerChange:) name:@"UINavigationControllerDidShowViewControllerNotification" object:nil];

    // UIApplication state notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartLabel) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shutdownLabel) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)observedViewControllerChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    id fromController = [userInfo objectForKey:@"UINavigationControllerLastVisibleViewController"];
    id toController = [userInfo objectForKey:@"UINavigationControllerNextVisibleViewController"];

    id ownController = [self firstAvailableViewController];
    if ([fromController isEqual:ownController]) {
        [self shutdownLabel];
    }
    else if ([toController isEqual:ownController]) {
        [self restartLabel];
    }
}

- (void)minimizeLabelFrameWithMaximumSize:(CGSize)maxSize adjustHeight:(BOOL)adjustHeight {
    if (self.subtextField.text != nil) {
        // Calculate text size
        if (CGSizeEqualToSize(maxSize, CGSizeZero)) {
            maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        }
        CGSize minimumLabelSize = [self subLabelSize];

        // Adjust for fade length
        CGSize minimumSize = CGSizeMake(minimumLabelSize.width + (self.fadeLength * 2), minimumLabelSize.height);

        // Find minimum size of options
        minimumSize = CGSizeMake(MIN(minimumSize.width, maxSize.width), MIN(minimumSize.height, maxSize.height));

        // Apply to frame
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, minimumSize.width, (adjustHeight ? minimumSize.height : self.frame.size.height));
    }
}

-(void)didMoveToSuperview {
    [self updateSublabel];
}

#pragma mark - MarqueeTextField Heavy Lifting

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self updateSublabel];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (!newWindow) {
        [self shutdownLabel];
    }
}

- (void)didMoveToWindow {
    if (self.window) {
        [self updateSublabel];
    }
}

- (void)updateSublabel {
    [self updateSublabelAndBeginScroll:YES];
}

- (void)updateSublabelAndBeginScroll:(BOOL)beginScroll {
    if (!self.subtextField.text || !self.superview) {
        return;
    }

    // Calculate expected size
    CGSize expectedLabelSize = [self subLabelSize];


    // Invalidate intrinsic size
    [self invalidateIntrinsicContentSize];

    // Move to home
    [self returnLabelToOriginImmediately];

    // Configure gradient for the current condition
    [self applyGradientMaskForFadeLength:self.fadeLength animated:YES];

    // Check if label should scroll
    // Can be because: 1) text fits, or 2) labelization
    // The holdScrolling property does NOT affect this
    if (!self.labelShouldScroll) {
        // Set text alignment and break mode to act like normal label
        self.subtextField.textAlignment = [super textAlignment];

        CGRect labelFrame, unusedFrame;
        switch (self.marqueeType) {
            case MLContinuousReverse:
            case MLRightLeft:
                CGRectDivide(self.bounds, &unusedFrame, &labelFrame, self.leadingBuffer, CGRectMaxXEdge);
                labelFrame = CGRectIntegral(labelFrame);
                break;

            default:
                labelFrame = CGRectIntegral(CGRectMake(self.leadingBuffer, 0.0f, self.bounds.size.width - self.leadingBuffer, self.bounds.size.height));
                break;
        }

        self.homeLabelFrame = labelFrame;
        self.awayOffset = 0.0f;

        // Remove an additional sublabels (for continuous types)
        self.repliLayer.instanceCount = 1;

        // Set sublabel frame calculated labelFrame
        self.subtextField.frame = labelFrame;

        return;
    }

    // Spacing between primary and second sublabel must be at least equal to leadingBuffer, and at least equal to the fadeLength
    CGFloat minTrailing = MAX(MAX(self.leadingBuffer, self.trailingBuffer), self.fadeLength);

    switch (self.marqueeType) {
        case MLContinuous:
        case MLContinuousReverse:
        {
            if (self.marqueeType == MLContinuous) {
                self.homeLabelFrame = CGRectIntegral(CGRectMake(self.leadingBuffer, 0.0f, expectedLabelSize.width, self.bounds.size.height));
                self.awayOffset = -(self.homeLabelFrame.size.width + minTrailing);
            } else {
                self.homeLabelFrame = CGRectIntegral(CGRectMake(self.bounds.size.width - (expectedLabelSize.width + self.leadingBuffer), 0.0f, expectedLabelSize.width, self.bounds.size.height));
                self.awayOffset = (self.homeLabelFrame.size.width + minTrailing);
            }

            self.subtextField.frame = self.homeLabelFrame;

            // Configure replication
            self.repliLayer.instanceCount = 2;
            self.repliLayer.instanceTransform = CATransform3DMakeTranslation(-self.awayOffset, 0.0, 0.0);

            // Recompute the animation duration
            self.animationDuration = (self.rate != 0) ? ((NSTimeInterval) fabs(self.awayOffset) / self.rate) : (self.scrollDuration);

            break;
        }

        case MLRightLeft:
        {
            self.homeLabelFrame = CGRectIntegral(CGRectMake(self.bounds.size.width - (expectedLabelSize.width + self.leadingBuffer), 0.0f, expectedLabelSize.width, self.bounds.size.height));
            self.awayOffset = (expectedLabelSize.width + self.trailingBuffer + self.leadingBuffer) - self.bounds.size.width;

            // Calculate animation duration
            self.animationDuration = (self.rate != 0) ? (NSTimeInterval)fabs(self.awayOffset / self.rate) : (self.scrollDuration);

            // Set frame and text
            self.subtextField.frame = self.homeLabelFrame;

            // Remove any replication
            self.repliLayer.instanceCount = 1;

            // Enforce text alignment for this type
            self.subtextField.textAlignment = NSTextAlignmentRight;

            break;
        }

        case MLLeftRight:
        {
            self.homeLabelFrame = CGRectIntegral(CGRectMake(self.leadingBuffer, 0.0f, expectedLabelSize.width, expectedLabelSize.height));
            self.awayOffset = self.bounds.size.width - (expectedLabelSize.width + self.leadingBuffer + self.trailingBuffer);

            // Calculate animation duration
            self.animationDuration = (self.rate != 0) ? (NSTimeInterval)fabs(self.awayOffset / self.rate) : (self.scrollDuration);

            // Set frame
            self.subtextField.frame = self.homeLabelFrame;

            // Remove any replication
            self.repliLayer.instanceCount = 1;

            // Enforce text alignment for this type
            self.subtextField.textAlignment = NSTextAlignmentLeft;

            break;
        }

        default:
        {
            // Something strange has happened
            self.homeLabelFrame = CGRectZero;
            self.awayOffset = 0.0f;

            // Do not attempt to begin scroll
            return;
            break;
        }

    } //end of marqueeType switch

    if (!self.tapToScroll && !self.holdScrolling && beginScroll) {
        [self beginScroll];
    }
}

- (CGSize)subLabelSize {
    // Calculate expected size
    CGSize expectedLabelSize = CGSizeZero;
    CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);

    // Get size of subLabel
    expectedLabelSize = [self.subtextField sizeThatFits:maximumLabelSize];
    // Sanitize width to 5461.0f (largest width a UILabel will draw on an iPhone 6S Plus)
    expectedLabelSize.width = MIN(expectedLabelSize.width, kMaxWidthiPhone6S);
    // Adjust to own height (make text baseline match normal label)
    expectedLabelSize.height = self.bounds.size.height;

    return expectedLabelSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [self.subtextField sizeThatFits:size];
    fitSize.width += self.leadingBuffer;
    return fitSize;
}

#pragma mark - Animation Handlers

- (BOOL)labelShouldScroll {
    BOOL stringLength = ([self.subtextField.text length] > 0);
    if (!stringLength) {
        return NO;
    }

    BOOL labelTooLarge = ([self subLabelSize].width + self.leadingBuffer > self.bounds.size.width);
    return (!self.labelize && labelTooLarge);
}

- (BOOL)labelReadyForScroll {
    // Check if we have a superview
    if (!self.superview) {
        return NO;
    }

    if (!self.window) {
        return NO;
    }

    // Check if our view controller is ready
    UIViewController *viewController = [self firstAvailableViewController];
    if (!viewController.isViewLoaded) {
        return NO;
    }

    return YES;
}

- (void)beginScroll {
    [self beginScrollWithDelay:YES];
}

- (void)beginScrollWithDelay:(BOOL)delay {
    switch (self.marqueeType) {
        case MLContinuous:
        case MLContinuousReverse:
            [self scrollContinuousWithInterval:self.animationDuration after:(delay ? self.animationDelay : 0.0)];
            break;
        default:
            [self scrollAwayWithInterval:self.animationDuration];
            break;
    }
}

- (void)returnLabelToOriginImmediately {
    // Remove gradient animations
    [self.layer.mask removeAllAnimations];

    // Remove sublabel position animations
    [self.subtextField.layer removeAllAnimations];
}

- (void)scrollAwayWithInterval:(NSTimeInterval)interval {
    [self scrollAwayWithInterval:interval delay:YES];
}

- (void)scrollAwayWithInterval:(NSTimeInterval)interval delay:(BOOL)delay {
    [self scrollAwayWithInterval:interval delayAmount:(delay ? self.animationDelay : 0.0)];
}

- (void)scrollAwayWithInterval:(NSTimeInterval)interval delayAmount:(NSTimeInterval)delayAmount {
    // Check for conditions which would prevent scrolling
    if (![self labelReadyForScroll]) {
        return;
    }

    // Return labels to home (cancel any animations)
    [self returnLabelToOriginImmediately];

    // Call pre-animation method
    [self labelWillBeginScroll];

    // Animate
    [CATransaction begin];

    // Set Duration
    [CATransaction setAnimationDuration:(2.0 * (delayAmount + interval))];

    // Create animation for gradient, if needed
    if (self.fadeLength != 0.0f) {
        CAKeyframeAnimation *gradAnim = [self keyFrameAnimationForGradientFadeLength:self.fadeLength
                                                                            interval:interval
                                                                               delay:delayAmount];
        [self.layer.mask addAnimation:gradAnim forKey:@"gradient"];
    }

    MLAnimationCompletionBlock completionBlock = ^(BOOL finished) {
        if (!finished) {
            // Do not continue into the next loop
            return;
        }
        // Call returned home method
        [self labelReturnedToHome:YES];
        // Check to ensure that:
        // 1) We don't double fire if an animation already exists
        // 2) The instance is still attached to a window - this completion block is called for
        //    many reasons, including if the animation is removed due to the view being removed
        //    from the UIWindow (typically when the view controller is no longer the "top" view)
        if (self.window && ![self.subtextField.layer animationForKey:@"position"]) {
            // Begin again, if conditions met
            if (self.labelShouldScroll && !self.tapToScroll && !self.holdScrolling) {
                [self scrollAwayWithInterval:interval delayAmount:delayAmount];
            }
        }
    };


    // Create animation for position
    CGPoint homeOrigin = self.homeLabelFrame.origin;
    CGPoint awayOrigin = MLOffsetCGPoint(self.homeLabelFrame.origin, self.awayOffset);
    NSArray *values = @[[NSValue valueWithCGPoint:homeOrigin],      // Initial location, home
                        [NSValue valueWithCGPoint:homeOrigin],      // Initial delay, at home
                        [NSValue valueWithCGPoint:awayOrigin],      // Animation to away
                        [NSValue valueWithCGPoint:awayOrigin],      // Delay at away
                        [NSValue valueWithCGPoint:homeOrigin]];     // Animation to home

    CAKeyframeAnimation *awayAnim = [self keyFrameAnimationForProperty:@"position"
                                                                values:values
                                                              interval:interval
                                                                 delay:delayAmount];
    // Add completion block
    [awayAnim setValue:completionBlock forKey:kMarqueeTextFieldAnimationCompletionBlock];

    // Add animation
    [self.subtextField.layer addAnimation:awayAnim forKey:@"position"];

    [CATransaction commit];
}

- (void)scrollContinuousWithInterval:(NSTimeInterval)interval after:(NSTimeInterval)delayAmount {
    // Check for conditions which would prevent scrolling
    if (![self labelReadyForScroll]) {
        return;
    }

    // Return labels to home (cancel any animations)
    [self returnLabelToOriginImmediately];

    // Call pre-animation method
    [self labelWillBeginScroll];

    // Animate
    [CATransaction begin];

    // Set Duration
    [CATransaction setAnimationDuration:(delayAmount + interval)];

    // Create animation for gradient, if needed
    if (self.fadeLength != 0.0f) {
        CAKeyframeAnimation *gradAnim = [self keyFrameAnimationForGradientFadeLength:self.fadeLength
                                                                            interval:interval
                                                                               delay:delayAmount];
        [self.layer.mask addAnimation:gradAnim forKey:@"gradient"];
    }

    MLAnimationCompletionBlock completionBlock = ^(BOOL finished) {
        if (!finished) {
            // Do not continue into the next loop
            return;
        }
        // Call returned home method
        [self labelReturnedToHome:YES];
        // Check to ensure that:
        // 1) We don't double fire if an animation already exists
        // 2) The instance is still attached to a window - this completion block is called for
        //    many reasons, including if the animation is removed due to the view being removed
        //    from the UIWindow (typically when the view controller is no longer the "top" view)
        if (self.window && ![self.subtextField.layer animationForKey:@"position"]) {
            // Begin again, if conditions met
            if (self.labelShouldScroll && !self.tapToScroll && !self.holdScrolling) {
                [self scrollContinuousWithInterval:interval after:delayAmount];
            }
        }
    };

    // Create animation for sublabel positions
    CGPoint homeOrigin = self.homeLabelFrame.origin;
    CGPoint awayOrigin = MLOffsetCGPoint(self.homeLabelFrame.origin, self.awayOffset);
    NSArray *values = @[[NSValue valueWithCGPoint:homeOrigin],      // Initial location, home
                        [NSValue valueWithCGPoint:homeOrigin],      // Initial delay, at home
                        [NSValue valueWithCGPoint:awayOrigin]];     // Animation to home

    CAKeyframeAnimation *awayAnim = [self keyFrameAnimationForProperty:@"position"
                                                                values:values
                                                              interval:interval
                                                                 delay:delayAmount];
    // Attach completion block
    [awayAnim setValue:completionBlock forKey:kMarqueeTextFieldAnimationCompletionBlock];

    // Add animation
    [self.subtextField.layer addAnimation:awayAnim forKey:@"position"];

    [CATransaction commit];
}

- (void)applyGradientMaskForFadeLength:(CGFloat)fadeLength animated:(BOOL)animated {
    // Check for zero-length fade
    if (fadeLength <= 0.0f) {
        [self removeGradientMask];
        return;
    }

    CAGradientLayer *gradientMask = (CAGradientLayer *)self.layer.mask;

    [gradientMask removeAllAnimations];

    if (!gradientMask) {
        // Create CAGradientLayer if needed
        gradientMask = [CAGradientLayer layer];
    }

    // Set up colors
    NSObject *transparent = (NSObject *)[[UIColor clearColor] CGColor];
    NSObject *opaque = (NSObject *)[[UIColor blackColor] CGColor];

    gradientMask.bounds = self.layer.bounds;
    gradientMask.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    gradientMask.shouldRasterize = YES;
    gradientMask.rasterizationScale = [UIScreen mainScreen].scale;
    gradientMask.startPoint = CGPointMake(0.0f, kGradMaskStartPointY);
    gradientMask.endPoint = CGPointMake(kGradMaskEndPointx, kGradMaskEndPointY);
    // Start with "no fade" colors and locations
    gradientMask.colors = @[opaque, opaque, opaque, opaque];
    gradientMask.locations = @[@(0.0f), @(0.0f), @(1.0f), @(1.0f)];

    // Set mask
    self.layer.mask = gradientMask;

    CGFloat leftFadeStop = fadeLength/self.bounds.size.width;
    CGFloat rightFadeStop = fadeLength/self.bounds.size.width;

    // Adjust stops based on fade length
    NSArray *adjustedLocations = @[@(0.0), @(leftFadeStop), @(1.0 - rightFadeStop), @(1.0)];

    // Determine colors for non-scrolling label (i.e. at home)
    NSArray *adjustedColors;
    BOOL trailingFadeNeeded = self.labelShouldScroll;
    switch (self.marqueeType) {
        case MLContinuousReverse:
        case MLRightLeft:
            adjustedColors = @[(trailingFadeNeeded ? transparent : opaque),
                               opaque,
                               opaque,
                               opaque];
            break;

        default:
            // MLContinuous
            // MLLeftRight
            adjustedColors = @[opaque,
                               opaque,
                               opaque,
                               (trailingFadeNeeded ? transparent : opaque)];
            break;
    }

    if (animated) {
        // Create animation for location change
        CABasicAnimation *locationAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
        locationAnimation.fromValue = gradientMask.locations;
        locationAnimation.toValue = adjustedLocations;
        locationAnimation.duration = kDefaultAnimationDurationInterval;

        // Create animation for color change
        CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
        colorAnimation.fromValue = gradientMask.colors;
        colorAnimation.toValue = adjustedColors;
        colorAnimation.duration = kDefaultAnimationDurationInterval;

        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = kDefaultAnimationDurationInterval;
        group.animations = @[locationAnimation, colorAnimation];

        [gradientMask addAnimation:group forKey:colorAnimation.keyPath];
        gradientMask.locations = adjustedLocations;
        gradientMask.colors = adjustedColors;
    } else {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        gradientMask.locations = adjustedLocations;
        gradientMask.colors = adjustedColors;
        [CATransaction commit];
    }
}

- (void)removeGradientMask {
    self.layer.mask = nil;
}

- (CAKeyframeAnimation *)keyFrameAnimationForGradientFadeLength:(CGFloat)fadeLength
                                                       interval:(NSTimeInterval)interval
                                                          delay:(NSTimeInterval)delayAmount
{
    // Setup
    NSArray *values = nil;
    NSArray *keyTimes = nil;
    NSTimeInterval totalDuration;
    NSObject *transp = (NSObject *)[[UIColor clearColor] CGColor];
    NSObject *opaque = (NSObject *)[[UIColor blackColor] CGColor];

    // Create new animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"colors"];

    // Get timing function
    CAMediaTimingFunction *timingFunction = [self timingFunctionForAnimationOptions:self.animationCurve];

    // Define keyTimes
    switch (self.marqueeType) {
        case MLLeftRight:
        case MLRightLeft:
            // Calculate total animation duration
            totalDuration = 2.0 * (delayAmount + interval);
            keyTimes = @[
                         @(0.0),                                                        // 1) Initial gradient
                         @(delayAmount/totalDuration),                                  // 2) Begin of LE fade-in, just as scroll away starts
                         @((delayAmount + 0.4)/totalDuration),                          // 3) End of LE fade in [LE fully faded]
                         @((delayAmount + interval - 0.4)/totalDuration),               // 4) Begin of TE fade out, just before scroll away finishes
                         @((delayAmount + interval)/totalDuration),                     // 5) End of TE fade out [TE fade removed]
                         @((delayAmount + interval + delayAmount)/totalDuration),       // 6) Begin of TE fade back in, just as scroll home starts
                         @((delayAmount + interval + delayAmount + 0.4)/totalDuration), // 7) End of TE fade back in [TE fully faded]
                         @((totalDuration - 0.4)/totalDuration),                        // 8) Begin of LE fade out, just before scroll home finishes
                         @(1.0)];                                                       // 9) End of LE fade out, just as scroll home finishes
            break;

        case MLContinuousReverse:
        default:
            // Calculate total animation duration
            totalDuration = delayAmount + interval;

            // Find when the lead label will be totally offscreen
            CGFloat startFadeFraction = fabs((self.subtextField.bounds.size.width + self.leadingBuffer) / self.awayOffset);
            // Find when the animation will hit that point
            CGFloat startFadeTimeFraction = [timingFunction durationPercentageForPositionPercentage:startFadeFraction withDuration:totalDuration];
            NSTimeInterval startFadeTime = delayAmount + startFadeTimeFraction * interval;

            keyTimes = @[
                         @(0.0),                                            // Initial gradient
                         @(delayAmount/totalDuration),                      // Begin of fade in
                         @((delayAmount + 0.2)/totalDuration),              // End of fade in, just as scroll away starts
                         @((startFadeTime)/totalDuration),                  // Begin of fade out, just before scroll home completes
                         @((startFadeTime + 0.1)/totalDuration),            // End of fade out, as scroll home completes
                         @(1.0)                                             // Buffer final value (used on continuous types)
                         ];
            break;
    }

    // Define gradient values
    switch (self.marqueeType) {
        case MLContinuousReverse:
            values = @[
                       @[transp, opaque, opaque, opaque],           // Initial gradient
                       @[transp, opaque, opaque, opaque],           // Begin of fade in
                       @[transp, opaque, opaque, transp],           // End of fade in, just as scroll away starts
                       @[transp, opaque, opaque, transp],           // Begin of fade out, just before scroll home completes
                       @[transp, opaque, opaque, opaque],           // End of fade out, as scroll home completes
                       @[transp, opaque, opaque, opaque]            // Final "home" value
                       ];
            break;

        case MLRightLeft:
            values = @[
                       @[transp, opaque, opaque, opaque],           // 1)
                       @[transp, opaque, opaque, opaque],           // 2)
                       @[transp, opaque, opaque, transp],           // 3)
                       @[transp, opaque, opaque, transp],           // 4)
                       @[opaque, opaque, opaque, transp],           // 5)
                       @[opaque, opaque, opaque, transp],           // 6)
                       @[transp, opaque, opaque, transp],           // 7)
                       @[transp, opaque, opaque, transp],           // 8)
                       @[transp, opaque, opaque, opaque]            // 9)
                       ];
            break;

        case MLContinuous:
            values = @[
                       @[opaque, opaque, opaque, transp],           // Initial gradient
                       @[opaque, opaque, opaque, transp],           // Begin of fade in
                       @[transp, opaque, opaque, transp],           // End of fade in, just as scroll away starts
                       @[transp, opaque, opaque, transp],           // Begin of fade out, just before scroll home completes
                       @[opaque, opaque, opaque, transp],           // End of fade out, as scroll home completes
                       @[opaque, opaque, opaque, transp]            // Final "home" value
                       ];
            break;

        case MLLeftRight:
        default:
            values = @[
                       @[opaque, opaque, opaque, transp],           // 1)
                       @[opaque, opaque, opaque, transp],           // 2)
                       @[transp, opaque, opaque, transp],           // 3)
                       @[transp, opaque, opaque, transp],           // 4)
                       @[transp, opaque, opaque, opaque],           // 5)
                       @[transp, opaque, opaque, opaque],           // 6)
                       @[transp, opaque, opaque, transp],           // 7)
                       @[transp, opaque, opaque, transp],           // 8)
                       @[opaque, opaque, opaque, transp]            // 9)
                       ];
            break;
    }

    animation.values = values;
    animation.keyTimes = keyTimes;
    animation.timingFunctions = @[timingFunction, timingFunction, timingFunction, timingFunction];

    return animation;
}

- (CAKeyframeAnimation *)keyFrameAnimationForProperty:(NSString *)property
                                               values:(NSArray *)values
                                             interval:(NSTimeInterval)interval
                                                delay:(NSTimeInterval)delayAmount
{
    // Create new animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:property];

    // Get timing function
    CAMediaTimingFunction *timingFunction = [self timingFunctionForAnimationOptions:self.animationCurve];

    // Calculate times based on marqueeType
    NSTimeInterval totalDuration;
    switch (self.marqueeType) {
        case MLLeftRight:
        case MLRightLeft:
            NSAssert(values.count == 5, @"Incorrect number of values passed for MLLeftRight-type animation");
            totalDuration = 2.0 * (delayAmount + interval);
            // Set up keyTimes
            animation.keyTimes = @[@(0.0),                                                   // Initial location, home
                                   @(delayAmount/totalDuration),                             // Initial delay, at home
                                   @((delayAmount + interval)/totalDuration),                // Animation to away
                                   @((delayAmount + interval + delayAmount)/totalDuration),  // Delay at away
                                   @(1.0)];                                                  // Animation to home

            animation.timingFunctions = @[timingFunction,
                                          timingFunction,
                                          timingFunction,
                                          timingFunction];

            break;

            // MLContinuous
            // MLContinuousReverse
        default:
            NSAssert(values.count == 3, @"Incorrect number of values passed for MLContinous-type animation");
            totalDuration = delayAmount + interval;
            // Set up keyTimes
            animation.keyTimes = @[@(0.0),                              // Initial location, home
                                   @(delayAmount/totalDuration),        // Initial delay, at home
                                   @(1.0)];                             // Animation to away

            animation.timingFunctions = @[timingFunction,
                                          timingFunction];

            break;
    }

    // Set values
    animation.values = values;
    animation.delegate = self;

    return animation;
}

- (CAMediaTimingFunction *)timingFunctionForAnimationOptions:(UIViewAnimationOptions)animationOptions {
    NSString *timingFunction;
    switch (animationOptions) {
        case UIViewAnimationOptionCurveEaseIn:
            timingFunction = kCAMediaTimingFunctionEaseIn;
            break;

        case UIViewAnimationOptionCurveEaseInOut:
            timingFunction = kCAMediaTimingFunctionEaseInEaseOut;
            break;

        case UIViewAnimationOptionCurveEaseOut:
            timingFunction = kCAMediaTimingFunctionEaseOut;
            break;

        default:
            timingFunction = kCAMediaTimingFunctionLinear;
            break;
    }

    return [CAMediaTimingFunction functionWithName:timingFunction];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    MLAnimationCompletionBlock completionBlock = [anim valueForKey:kMarqueeTextFieldAnimationCompletionBlock];
    if (completionBlock) {
        completionBlock(flag);
    }
}

#pragma mark - Label Control

- (void)restartLabel {
    // Shutdown the label
    [self shutdownLabel];
    // Restart scrolling if appropriate
    if (self.labelShouldScroll && !self.tapToScroll && !self.holdScrolling) {
        [self beginScroll];
    }
}

- (void)resetLabel {
    [self returnLabelToOriginImmediately];
    self.homeLabelFrame = CGRectNull;
    self.awayOffset = 0.0f;
}

- (void)shutdownLabel {
    // Bring label to home location
    [self returnLabelToOriginImmediately];
    // Apply gradient mask for home location
    [self applyGradientMaskForFadeLength:self.fadeLength animated:false];
}

-(void)pauseLabel
{
    // Only pause if label is not already paused, and already in a scrolling animation
    if (!self.isPaused && self.awayFromHome) {
        // Pause sublabel position animation
        CFTimeInterval labelPauseTime = [self.subtextField.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.subtextField.layer.speed = 0.0;
        self.subtextField.layer.timeOffset = labelPauseTime;
        // Pause gradient fade animation
        CFTimeInterval gradientPauseTime = [self.layer.mask convertTime:CACurrentMediaTime() fromLayer:nil];
        self.layer.mask.speed = 0.0;
        self.layer.mask.timeOffset = gradientPauseTime;

        self.isPaused = YES;
    }
}

-(void)unpauseLabel
{
    if (self.isPaused) {
        // Unpause sublabel position animation
        CFTimeInterval labelPausedTime = self.subtextField.layer.timeOffset;
        self.subtextField.layer.speed = kLabelMarqueeSpeed;
        self.subtextField.layer.timeOffset = 0.0;
        self.subtextField.layer.beginTime = 0.0;
        self.subtextField.layer.beginTime = [self.subtextField.layer convertTime:CACurrentMediaTime() fromLayer:nil] - labelPausedTime;
        // Unpause gradient fade animation
        CFTimeInterval gradientPauseTime = self.layer.mask.timeOffset;
        self.layer.mask.speed = kLabelMarqueeSpeed;
        self.layer.mask.timeOffset = 0.0;
        self.layer.mask.beginTime = 0.0;
        self.layer.mask.beginTime = [self.layer.mask convertTime:CACurrentMediaTime() fromLayer:nil] - gradientPauseTime;

        self.isPaused = NO;
    }
}

- (void)labelWasTapped:(UITapGestureRecognizer *)recognizer {
    if (self.labelShouldScroll && !self.awayFromHome) {
        [self beginScrollWithDelay:NO];
    }
}

- (void)triggerScrollStart {
    if (self.labelShouldScroll && !self.awayFromHome) {
        [self beginScroll];
    }
}

- (void)labelWillBeginScroll {
    // Default implementation does nothing
    return;
}

- (void)labelReturnedToHome:(BOOL)finished {
    // Default implementation does nothing
    return;
}

#pragma mark - Modified UIView Methods/Getters/Setters

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    // Check if device is running iOS 8.0.X
    if(SYSTEM_VERSION_IS_8_0_X) {
        // If so, force update because layoutSubviews is not called
        [self updateSublabel];
    }
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];

    // Check if device is running iOS 8.0.X
    if(SYSTEM_VERSION_IS_8_0_X) {
        // If so, force update because layoutSubviews is not called
        [self updateSublabel];
    }

}

#pragma mark - Modified UILabel Methods/Getters/Setters

- (UIView *)viewForBaselineLayout {
    // Use subLabel view for handling baseline layouts
    return self.subtextField;
}

- (NSString *)text {
    return self.subtextField.text;
}

- (void)setText:(NSString *)text {
    self.subtextField.text = text;
    super.text = @"";
    if(![text isEqualToString:@""]){
        [super setPlaceholder:@""];
    }

    [self updateSublabel];
}



- (UIFont *)font {
    return self.subtextField.font;
}

- (void)setFont:(UIFont *)font {
    if ([font isEqual:self.subtextField.font]) {
        return;
    }
    self.subtextField.font = font;
    super.font = font;
    [self updateSublabel];
}

- (UIColor *)textColor {
    return self.subtextField.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    self.subtextField.textColor = textColor;
    super.textColor = textColor;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.subtextField.delegate = delegate;
    super.delegate = nil;
    super.enabled = NO;
}

-(void) setReturnKeyType:(UIReturnKeyType)returnKeyType{
    self.subtextField.returnKeyType = returnKeyType;
    super.returnKeyType = returnKeyType;
}

-(void) setLeftViewMode:(UITextFieldViewMode)leftViewMode{
    self.subtextField.leftViewMode = leftViewMode;
    super.leftViewMode = leftViewMode;
}

-(void) setLeftView:(UIView *)leftView{
    self.subtextField.leftView = leftView;
    super.leftView = leftView;
}

-(void) setTag:(NSInteger)tag{
    self.subtextField.tag = tag;
    super.tag = tag;
}

- (UIColor *)backgroundColor {
    return self.subtextField.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.subtextField.backgroundColor = backgroundColor;
    super.backgroundColor = backgroundColor;
}


- (BOOL)isEnabled {
    return self.subtextField.isEnabled;
}

- (void)setEnabled:(BOOL)enabled {
    self.subtextField.enabled = enabled;
    super.enabled = enabled;
}


- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    // By the nature of MarqueeTextField, this is NO
    [super setAdjustsFontSizeToFitWidth:NO];
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize {
    [super setMinimumFontSize:0.0];
}


- (CGSize)intrinsicContentSize {
    CGSize contentSize = self.subtextField.intrinsicContentSize;
    contentSize.width += self.leadingBuffer;
    return contentSize;
}

#pragma mark - Custom Getters and Setters

- (void)setRate:(CGFloat)rate {
    if (_rate == rate) {
        return;
    }

    _scrollDuration = 0.0f;
    _rate = rate;
    [self updateSublabel];
}

- (void)setScrollDuration:(CGFloat)lengthOfScroll {
    if (_scrollDuration == lengthOfScroll) {
        return;
    }

    _rate = 0.0f;
    _scrollDuration = lengthOfScroll;
    [self updateSublabel];
}

- (void)setAnimationCurve:(UIViewAnimationOptions)animationCurve {
    if (_animationCurve == animationCurve) {
        return;
    }

    NSUInteger allowableOptions = UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionCurveLinear;
    if ((allowableOptions & animationCurve) == animationCurve) {
        _animationCurve = animationCurve;
    }
}

- (void)setLeadingBuffer:(CGFloat)leadingBuffer {
    if (_leadingBuffer == leadingBuffer) {
        return;
    }

    // Do not allow negative values
    _leadingBuffer = fabs(leadingBuffer);
    [self updateSublabel];
}

- (void)setTrailingBuffer:(CGFloat)trailingBuffer {
    if (_trailingBuffer == trailingBuffer) {
        return;
    }

    // Do not allow negative values
    _trailingBuffer = fabs(trailingBuffer);
    [self updateSublabel];
}

- (void)setContinuousMarqueeExtraBuffer:(CGFloat)continuousMarqueeExtraBuffer {
    [self setTrailingBuffer:continuousMarqueeExtraBuffer];
}

- (CGFloat)continuousMarqueeExtraBuffer {
    return self.trailingBuffer;
}

- (void)setFadeLength:(CGFloat)fadeLength {
    if (_fadeLength == fadeLength) {
        return;
    }

    _fadeLength = fadeLength;

    [self updateSublabel];
}

- (void)setTapToScroll:(BOOL)tapToScroll {
    if (_tapToScroll == tapToScroll) {
        return;
    }

    _tapToScroll = tapToScroll;

    if (_tapToScroll) {
        UITapGestureRecognizer *newTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelWasTapped:)];
        [self addGestureRecognizer:newTapRecognizer];
        self.tapRecognizer = newTapRecognizer;
        self.userInteractionEnabled = YES;
    } else {
        [self removeGestureRecognizer:self.tapRecognizer];
        self.tapRecognizer = nil;
        self.userInteractionEnabled = NO;
    }
}

- (void)setMarqueeType:(MarqueeType)marqueeType {
    if (marqueeType == _marqueeType) {
        return;
    }

    _marqueeType = marqueeType;

    [self updateSublabel];
}

- (void)setLabelize:(BOOL)labelize {
    if (_labelize == labelize) {
        return;
    }

    _labelize = labelize;

    [self updateSublabelAndBeginScroll:YES];
}

- (void)setHoldScrolling:(BOOL)holdScrolling {
    if (_holdScrolling == holdScrolling) {
        return;
    }

    _holdScrolling = holdScrolling;

    if (!holdScrolling && !(self.awayFromHome || self.labelize || self.tapToScroll) && self.labelShouldScroll) {
        [self beginScroll];
    }
}

- (BOOL)awayFromHome {
    CALayer *presentationLayer = self.subtextField.layer.presentationLayer;
    if (!presentationLayer) {
        return NO;
    }
    return !(presentationLayer.position.x == self.homeLabelFrame.origin.x);
}

#pragma mark - Support

- (NSArray *)gradientColors {
    if (!_gradientColors) {
        NSObject *transparent = (NSObject *)[[UIColor clearColor] CGColor];
        NSObject *opaque = (NSObject *)[[UIColor blackColor] CGColor];
        _gradientColors = [NSArray arrayWithObjects: transparent, opaque, opaque, transparent, nil];
    }
    return _gradientColors;
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



#pragma mark - Helpers

@implementation UIView (MarqueeTextFieldHelpers)
// Thanks to Phil M
// http://stackoverflow.com/questions/1340434/get-to-uiviewcontroller-from-uiview-on-iphone

- (id)firstAvailableViewController
{
    // convenience function for casting and to "mask" the recursive function
    return [self traverseResponderChainForFirstViewController];
}

- (id)traverseResponderChainForFirstViewController
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForFirstViewController];
    } else {
        return nil;
    }
}

@end

@implementation CAMediaTimingFunction (MarqueeTextFieldHelpers)

- (CGFloat)durationPercentageForPositionPercentage:(CGFloat)positionPercentage withDuration:(NSTimeInterval)duration
{
    // Finds the animation duration percentage that corresponds with the given animation "position" percentage.
    // Utilizes Newton's Method to solve for the parametric Bezier curve that is used by CAMediaAnimation.

    NSArray *controlPoints = [self controlPoints];
    CGFloat epsilon = 1.0f / (100.0f * duration);

    // Find the t value that gives the position percentage we want
    CGFloat t_found = [self solveTForY:positionPercentage
                           withEpsilon:epsilon
                         controlPoints:controlPoints];

    // With that t, find the corresponding animation percentage
    CGFloat durationPercentage = [self XforCurveAt:t_found withControlPoints:controlPoints];

    return durationPercentage;
}

- (CGFloat)solveTForY:(CGFloat)y_0 withEpsilon:(CGFloat)epsilon controlPoints:(NSArray *)controlPoints
{
    // Use Newton's Method: http://en.wikipedia.org/wiki/Newton's_method
    // For first guess, use t = y (i.e. if curve were linear)
    CGFloat t0 = y_0;
    CGFloat t1 = y_0;
    CGFloat f0, df0;

    for (int i = 0; i < 15; i++) {
        // Base this iteration of t1 calculated from last iteration
        t0 = t1;
        // Calculate f(t0)
        f0 = [self YforCurveAt:t0 withControlPoints:controlPoints] - y_0;
        // Check if this is close (enough)
        if (fabs(f0) < epsilon) {
            // Done!
            return t0;
        }
        // Else continue Newton's Method
        df0 = [self derivativeYValueForCurveAt:t0 withControlPoints:controlPoints];
        // Check if derivative is small or zero ( http://en.wikipedia.org/wiki/Newton's_method#Failure_analysis )
        if (fabs(df0) < 1e-6) {
            LogI(@"MarqueeTextField: Newton's Method failure, small/zero derivative!");
            break;
        }
        // Else recalculate t1
        t1 = t0 - f0/df0;
    }

    LogI(@"MarqueeTextField: Failed to find t for Y input!");
    return t0;
}

- (CGFloat)YforCurveAt:(CGFloat)t withControlPoints:(NSArray *)controlPoints
{
    CGPoint P0 = [controlPoints[0] CGPointValue];
    CGPoint P1 = [controlPoints[1] CGPointValue];
    CGPoint P2 = [controlPoints[2] CGPointValue];
    CGPoint P3 = [controlPoints[3] CGPointValue];

    // Per http://en.wikipedia.org/wiki/Bezier_curve#Cubic_B.C3.A9zier_curves
    return  powf((1 - t),3) * P0.y +
    3.0f * powf(1 - t, 2) * t * P1.y +
    3.0f * (1 - t) * powf(t, 2) * P2.y +
    powf(t, 3) * P3.y;

}

- (CGFloat)XforCurveAt:(CGFloat)t withControlPoints:(NSArray *)controlPoints
{
    CGPoint P0 = [controlPoints[0] CGPointValue];
    CGPoint P1 = [controlPoints[1] CGPointValue];
    CGPoint P2 = [controlPoints[2] CGPointValue];
    CGPoint P3 = [controlPoints[3] CGPointValue];

    // Per http://en.wikipedia.org/wiki/Bezier_curve#Cubic_B.C3.A9zier_curves
    return  powf((1 - t),3) * P0.x +
    3.0f * powf(1 - t, 2) * t * P1.x +
    3.0f * (1 - t) * powf(t, 2) * P2.x +
    powf(t, 3) * P3.x;

}

- (CGFloat)derivativeYValueForCurveAt:(CGFloat)t withControlPoints:(NSArray *)controlPoints
{
    CGPoint P0 = [controlPoints[0] CGPointValue];
    CGPoint P1 = [controlPoints[1] CGPointValue];
    CGPoint P2 = [controlPoints[2] CGPointValue];
    CGPoint P3 = [controlPoints[3] CGPointValue];

    return  powf(t, 2) * (-3.0f * P0.y - 9.0f * P1.y - 9.0f * P2.y + 3.0f * P3.y) +
    t * (6.0f * P0.y + 6.0f * P2.y) +
    (-3.0f * P0.y + 3.0f * P1.y);
}

- (NSArray *)controlPoints
{
    float point[2];
    NSMutableArray *pointArray = [NSMutableArray array];
    for (int i = 0; i <= 3; i++) {
        [self getControlPointAtIndex:i values:point];
        [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(point[0], point[1])]];
    }

    return [NSArray arrayWithArray:pointArray];
}

@end
