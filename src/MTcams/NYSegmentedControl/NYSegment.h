#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Availability.h>

@class NYSegment;
@class NYSegmentTextRenderView;

@interface NYSegment : UIView

@property (nonatomic) NYSegmentTextRenderView *titleLabel;
@property (nonatomic) BOOL selected;

- (instancetype)initWithTitle:(NSString *)title;

@end
