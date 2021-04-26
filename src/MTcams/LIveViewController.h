//
//  LIveViewController.h
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "FlipsideViewController.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIColor.h>
#import <UIKit/UIGeometry.h>
#import "OCCameraGuestureRecognizer.h"

#import "FosCom.h"
#import "FosDef.h"
#import "FosNvrDef.h"
#import "fosnvrsdk.h"
#import "fossdk.h"


#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "Sesija.h"
#import "OCIvideonCamHeaderView.h"
#import "OCIvideonCamFooterView.h"
#import "MBProgressHUD.h"
#import "NewCamDataViewController.h"

#define MAXAUDIOBUF		245670

@interface LIveViewController : UIViewController <FlipsideViewControllerDelegate, UITextFieldDelegate, OCCameraGuestureDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, NSURLSessionTaskDelegate, NewCamDataViewController >{
    UIImage         *viewImage;
    FOSHANDLE       mHandle;
}


@property (weak, nonatomic) IBOutlet UIImageView *firstimageShowView;

@property (weak, nonatomic) IBOutlet UIButton *top;
@property (weak, nonatomic) IBOutlet UIButton *left;
@property (weak, nonatomic) IBOutlet UIButton *right;
@property (weak, nonatomic) IBOutlet UIButton *down;
@property (weak, nonatomic) IBOutlet UIButton *stop;

@property (weak, nonatomic) IBOutlet UIButton *center;

@property (weak, nonatomic) IBOutlet UIButton *leftUp;
@property (weak, nonatomic) IBOutlet UIButton *leftDown;
@property (weak, nonatomic) IBOutlet UIButton *rightUp;
@property (weak, nonatomic) IBOutlet UIButton *rightDown;

@property (weak, nonatomic) IBOutlet UIButton *zoomIn;
@property (weak, nonatomic) IBOutlet UIButton *zoomOut;
@property (weak, nonatomic) IBOutlet UIButton *noZoom;

@property (nonatomic, strong) Sesija *sesija;
@property (nonatomic, strong) NSString *url;

- (IBAction)ptzTop:(id)sender;
- (IBAction)ptzLeft:(id)sender;
- (IBAction)ptzRight:(id)sender;
- (IBAction)ptzDown:(id)sender;
- (IBAction)ptzStop:(id)sender;

- (IBAction)ptzCenter:(id)sender;

- (IBAction)ptzLeftUp:(id)sender;
- (IBAction)ptzLeftDown:(id)sender;
- (IBAction)ptzRightUp:(id)sender;
- (IBAction)ptzRightDown:(id)sender;

- (IBAction)ptzZoomIn:(id)sender;
- (IBAction)ptzZoomOut:(id)sender;
- (IBAction)ptzNoZoom:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
-(UIImage *)imageFromAVPicture:(char*)data width:(int)width height:(int)height;


@property (nonatomic, retain) AVAudioRecorder *audioRecorder;
@property (strong, retain) NSString *audioFilePath;


@end
