//
//  MTAlertPresenter.m
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTAlertPresenter.h"
#import "MTAlertDescriptor.h"


@interface MTAlertPresenter()

@property (nonatomic, weak) MTAlertDescriptor *currentDescriptor;
@property (nonatomic, weak) UIAlertController *currentAlertVC;
@property (nonatomic, strong) NSMutableArray<MTAlertDescriptor *> *alerts;

@end

@implementation MTAlertPresenter

+ (instancetype)sharedPresenter
{
    static MTAlertPresenter *presenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        presenter = [MTAlertPresenter new];
    });

    return presenter;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.currentDescriptor = nil;
        self.alerts = [NSMutableArray new];
    }

    return self;
}

- (void)presentAlertControllerWithConfigurationHandler:(MTAlertDescriptorConfigurator)configurator {
    MTAlertDescriptor *descriptor = [MTAlertDescriptor new];
    configurator(descriptor);
    [self presentWithDescriptor:descriptor];
}

- (void)presentAlertWithTitle:(nullable NSString *)title message:(nullable  NSString *)message andPriority:(MTAlertPriority)priority{
    [self presentAlertControllerWithConfigurationHandler:^(MTAlertDescriptor *descriptor) {
        descriptor.priority = priority;
        descriptor.title = title;
        descriptor.message = message;
        descriptor.cancelTitle = NSLocalizedString(@"ok", nil);
    }];
}

- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self presentAlertWithTitle:title message:message andPriority:MTAlertPriorityLow];
}

- (void)dismissAlert{
    if(self.currentAlertVC){
        self.currentDescriptor = nil;
        __weak typeof(self) weakPresenter = self;
        [self.currentAlertVC dismissViewControllerAnimated:NO completion:^{
            weakPresenter.currentAlertVC = nil;
        }];
    }
}

#pragma mark - local

- (void)presentWithDescriptor:(MTAlertDescriptor *)descriptor
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.alerts.count>=MTAlertsMaxQueueCount) {
            [self.alerts removeObjectAtIndex:0];
        }
        [self.alerts addObject:descriptor];
        if ([self isIncomingAlertWithHigherPriority:descriptor]) {
            [self buildThenShowAlertWithDescriptor:descriptor];
        }else{
            LogI(@"Ignoring lower priority alert: %@", [descriptor description]);
        }
    });
}

- (void)buildThenShowAlertWithDescriptor:(MTAlertDescriptor *)descriptor
{
    if (descriptor != nil)
    {
        if(self.currentAlertVC){
            [self.currentAlertVC dismissViewControllerAnimated:NO completion:nil];
        }
        self.currentDescriptor = descriptor;
        __weak typeof(self) weakPresenter = self;
        UIAlertController *alertController = [descriptor alertControllerWithCompletion:^{
            weakPresenter.currentAlertVC = nil;
            weakPresenter.currentDescriptor = nil;
        }];
        [self displayAlertController:alertController];
        self.currentAlertVC = alertController;
    }
}

- (BOOL)isIncomingAlertWithHigherPriority:(MTAlertDescriptor *)descriptor
{
    return (self.currentDescriptor == nil ? YES : (descriptor.priority >= self.currentDescriptor.priority));
}

- (void)displayAlertController:(UIAlertController *)controller
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.windowLevel = UIWindowLevelAlert + (self.currentDescriptor.priority - 1);
    [window makeKeyAndVisible];
    [window.rootViewController presentViewController:controller animated:YES completion:nil];
}

@end
