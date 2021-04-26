//
//  MTSupport.m
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTSupport.h"
@import SystemConfiguration.CaptiveNetwork;

static const int kNavigationBorderWidth  = 1;

#define GRADIANT_POSITION ([NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.75f], [NSNumber numberWithFloat:0.9f], [NSNumber numberWithFloat:1.0f], nil])

static const float movementDuration = 0.3f; // tweak as needed

@implementation MTSupport

+(NSString *)replaceMultipliedSpacesWithOneFromString: (NSString *) string {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@" "];
    return string;
}

+(BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+(void)setNumericKeyboardWithDone:(UITextField*) textField withDoneSelector:(SEL)doneSelector withObject:(id)object
{
    textField.keyboardType = UIKeyboardTypeNumberPad;
    if(IS_IPHONE){ //IPAD by default have done button
        UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil)
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:object
                                                                      action:doneSelector ];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
}

+(BOOL)isPasswordFormatValid:(NSString *)password
{
    
    NSString *pattern = @"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if([passwordTest evaluateWithObject:password]){
        return YES;
    }else{
        return NO;
    }
}

+(MTBaseTheme *)getTheme
{
    return THEME_MANAGER;
}


+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+(NSString *)getCurrentWifiSSID
{
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[kSSIDString]) {
            ssid = info[kSSIDString];
        }
    }
    return ssid;
}

+(BOOL)isValidPinNumber:(NSString*)pinNumber{
    BOOL rez = YES;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]{4}$" options:NSRegularExpressionCaseInsensitive error:nil];
    if([regex rangeOfFirstMatchInString:pinNumber options:NSMatchingReportProgress range:NSMakeRange(0, [pinNumber length])].location == NSNotFound){
        rez = NO;
    }
    return rez;
}

+(void)setViewMovedUp:(BOOL)movedUp forView:(UIView *)view forDistance:(NSInteger) distance
{
    NSInteger movement = (movedUp ? -distance : distance);
    
    [UIView beginAnimations: @"anim"context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, 0, movement);
    [UIView commitAnimations];
}


// gredient for img in tab
+ (UIImage *)imageWithGradient:(UIImage *)img changeAlpha:(BOOL)cngAlpha {
    
    // change alpha
    if (cngAlpha) {
        img = [self imageByApplyingAlpha:1.0 image:img];
    }
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    
    // Create gradient
    CGFloat gradientLocations[4];
    for(int i = 0; i< GRADIANT_POSITION.count; i++){
        gradientLocations[i] = [[GRADIANT_POSITION objectAtIndex:i] doubleValue];
    }
    
    MTBaseTheme *theme = THEME_MANAGER;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)[theme getPrimaryColors], gradientLocations);
    
    // Apply gradient
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.origin.x, rect.origin.y + rect.size.height), CGPointMake(rect.origin.x + rect.size.width, rect.origin.y), 0);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    
    return gradientImage;
}

// change alpha
+ (UIImage *)imageByApplyingAlpha:(CGFloat) alpha image:(UIImage *)img {
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, img.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// change img color
+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color{
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    // set the fill color
    [color setFill];
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return the color-burned image
    return coloredImg;
}

// custom UISwitch
+(UISwitch *)switchCustom:(UISwitch *)newSwich{
    newSwich.onTintColor =[[self getTheme] getAccentColor];
    newSwich.backgroundColor = [UIColor clearColor];
    return newSwich;
}

// custom UISlider
+ (UISlider *)sliderCustom:(UISlider *)newSlider{
    newSlider.maximumTrackTintColor = [[self getTheme] getStrokeColor];
    newSlider.minimumTrackTintColor = [[self getTheme] getAccentColor];
    return newSlider;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(void)addNavigationTopBorderWithColor:(UIColor *)color toView:(UIView *)view
{
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    border.frame = CGRectMake(0, 0, view.frame.size.width, kNavigationBorderWidth);
    [view addSubview:border];
}





@end
