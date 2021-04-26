//
//  Page1ViewController.m
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Page1ViewController.h"
#import "PreferenceDefines.h"
#import "Settings.h"
#import "Page2ViewController.h"
#import "Page3ViewController.h"
#import "AppDelegate.h"


@interface Page1ViewController ()

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, weak) IBOutlet UIView *scanRectView;
@property (nonatomic, weak) IBOutlet UILabel *decodedLabel;

@end

@implementation Page1ViewController{
    CGAffineTransform _captureSizeTransform;
    AppDelegate *appDelegate;
}

bool loopScan = NO;

#pragma mark - Page 1 View Controller Methods

- (void)dealloc {
    [self.capture.layer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //_nextpressed.hidden = YES;
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.torch = YES;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    //change collor
    [self.view setBackgroundColor: [UIColor blackColor]]; 
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.pControl setCurrentPage:0];
    //[self.pControl setCurrentPage:0 animated:YES];
    //[self.pControl setFrame:CGRectMake(0, self.view.frame.size.height - 55, self.view.frame.size.width, 55)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    loopScan = NO;
    //_nextpressed.hidden = NO;
    
    [super viewWillAppear:animated];

    self.capture.delegate = self;
    [self applyOrientation];
}


#pragma mark - Private
- (void)applyOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    [self applyRectOfInterest:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    [self.capture setTransform:transform];
    [self.capture setRotation:scanRectRotation];
    //change view camera
    self.capture.layer.frame = self.scanRectView.frame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = self.scanRectView.frame;
    if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        videoSizeX = 1080;
        videoSizeY = 1920;
    } else {
        videoSizeX = 720;
        videoSizeY = 1280;
    }
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
        }
    } else {
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
        }
    }
    _captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}


#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
 
    if(!loopScan){
        
        CGAffineTransform inverse = CGAffineTransformInvert(_captureSizeTransform);
        NSMutableArray *points = [[NSMutableArray alloc] init];
        NSString *location = @"";
        for (ZXResultPoint *resultPoint in result.resultPoints) {
            CGPoint cgPoint = CGPointMake(resultPoint.x, resultPoint.y);
            CGPoint transformedPoint = CGPointApplyAffineTransform(cgPoint, inverse);
            transformedPoint = [self.scanRectView convertPoint:transformedPoint toView:self.scanRectView.window];
            NSValue* windowPointValue = [NSValue valueWithCGPoint:transformedPoint];
            location = [NSString stringWithFormat:@"%@ (%f, %f)", location, transformedPoint.x, transformedPoint.y];
            [points addObject:windowPointValue];
        }
        
        // We got a result. Display information about the result onscreen.
        NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
        
        NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@\n", formatString, result.text];
        //NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@\nLocation: %@", formatString, result.text, location];
        LogI(@"Prikaz display sa vrednostima %@", display);

        [self progressDone];

        NSString *parsedText = [result.text stringByReplacingOccurrencesOfString:@"u=" withString:@""];
        parsedText = [parsedText stringByReplacingOccurrencesOfString:@";e=" withString:@""];
        
        [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:parsedText waitUntilDone:YES];
        
        LogI(@"formatString kreiran sa vrednostima %@", parsedText);
        
        
        Settings *sharedInstance = APP_SETTINGS;
        sharedInstance.sUID = parsedText;
        
        LogI(@"PAGE 1 Singleton kreiran sa vrednostima UID %@",  sharedInstance.sUID);
        
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [self.capture stop];

        loopScan = YES;
        
        [self performSelector:@selector(nextController) withObject:NULL afterDelay:1.f];
 }

}

- (void)progressDone{
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = NSLocalizedString(@"done", nil);
    [hud hideAnimated:YES afterDelay:1.f];


}

- (void)nextController{
    
    
    if (appDelegate.configurationType == wifi){
        Page2ViewController *p2vc =[self.storyboard instantiateViewControllerWithIdentifier:@"Page2VC"];
        [self.navigationController pushViewController:p2vc animated:YES];
    }else{
        Page3ViewController *p3vc =[self.storyboard instantiateViewControllerWithIdentifier:@"Page3"];
        [self.navigationController pushViewController:p3vc animated:YES];
    }
}

@end
