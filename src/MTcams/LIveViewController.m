//
//  LIveViewController.m
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "LIveViewController.h"
#import <Photos/Photos.h>
#import "NewCamDataViewController.h"
#import "Settings.h"
#import "FCInputAudio.h"
#import "FCOutputAudio.h"
#import "CoreDataManager.h"
#import "ListCamsViewController.h"

static NSString* const kSSID_String = @"SSID";

@interface LIveViewController (){

    AudioStreamBasicDescription _audio_fmt;
    AudioStreamBasicDescription _outputaudio_fmt;
    bool m_videoPlaying;
    bool m_audioPlaying;
    bool m_talkPlaying;
    bool m_eventLoop;
    
}

@property (nonatomic, strong) dispatch_queue_t audioQueue;
@property (nonatomic, strong) FCInputAudio *audioOperation;
@property (nonatomic, strong) FCOutputAudio *audioOutputOperation;


@end

@implementation LIveViewController{
    UIImageView *imageV;
    FOSSTREAM_TYPE _streamQalty;
    UIAlertController *_menuQuality;
    OCCameraGuestureRecognizer* _cameraRecognizer;
    OCIvideonCamHeaderView* _header;
    OCIvideonCamFooterView* _footer;
    MBProgressHUD *hud;
    BOOL nowSave;
    AVAudioSession *session;
    Settings *sharedInstance;
    BOOL reOpenVideo;
    AppDelegate *appDelegate;
    CoreDataManager *coreDataManager;
    NSString *mySSID;
    UISegmentedControl *segmentedControl;
}

@synthesize audioRecorder, audioFilePath;

@synthesize top =_top;
@synthesize left =_left;
@synthesize right =_right;
@synthesize down =_down;
@synthesize stop =_stop;
@synthesize leftUp =_leftUp;
@synthesize leftDown =_leftDown;
@synthesize rightUp =_rightUp;
@synthesize rightDown =_rightDown;
@synthesize center =_center;
@synthesize zoomIn =_zoomIn;
@synthesize zoomOut =_zoomOut;
@synthesize noZoom =_noZoom;

@synthesize url =_url;
@synthesize sesija =_sesija;
@synthesize imageView =_imageView;

typedef void(^RunFun)(void* param);

static const float kHeaderHight = 50;
static const float kHeaderAlpha = 0.3;
static const float kHideHeaderInterval = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    coreDataManager = [[CoreDataManager alloc]init];
    sharedInstance = APP_SETTINGS;

    mySSID = [[NSString alloc]init];
    mySSID = [MTSupport getCurrentWifiSSID];
    
    nowSave = NO;
    [self setEdgesForExtendedLayout:UIRectEdgeTop];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, (3*self.view.frame.size.width)/4)];
    imageV.userInteractionEnabled = YES;
    [self.view addSubview:imageV];
    
    [self hudConnectionStart];

    char *ip = (char *)[_sesija.sIp UTF8String];
    char *uid = (char *)[_sesija.sUID  UTF8String];
    char *us = (char *)[_sesija.sUn UTF8String];
    char *pw = (char *)[_sesija.sPass UTF8String];
    NSInteger pt =[_sesija.sPort intValue];

    if (_sesija.connectionType == local){
        mHandle = FosSdk_Create(ip, "",  us, pw, pt, pt, FOSIPC_H264, FOSCNTYPE_IP);
    }else{
        mHandle = FosSdk_Create(ip, uid, us, pw, pt, pt, FOSIPC_H264, FOSCNTYPE_P2P);
    }
   
    _cameraRecognizer = [[OCCameraGuestureRecognizer alloc]init];
    _cameraRecognizer.delegate = self;
    
    [self.view setAutoresizesSubviews:YES];
    
    char *devName = "My Foscam";
    
    //FosSdk_SetDevName( mHandle, 500, devName);
    //FOSCMD_RESULT rst = FosSdk_GetDevName( mHandle, 500, devName);
    
    _header = [[OCIvideonCamHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderHight) andDeviceName:[NSString stringWithCString:devName encoding:NSUTF8StringEncoding] andAlpha:kHeaderAlpha];
    [self.view addSubview:_header];
    // [_header.buttonBack addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _footer = [[OCIvideonCamFooterView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-kHeaderHight, self.view.frame.size.width, kHeaderHight) andAlpha:kHeaderAlpha];
    
    [self.view addSubview:_footer];
    [_footer.buttonQuality addTarget:self action:@selector(qualityMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_footer.buttonSnap addTarget:self action:@selector(camSnapshot:) forControlEvents:UIControlEventTouchUpInside];
    [_footer.buttonAudio addTarget:self action:@selector(openAudio:) forControlEvents:UIControlEventTouchUpInside];
    
    //[_footer.buttonRecord addTarget:self action:@selector(startCamRec) forControlEvents:UIControlEventTouchUpInside];
    
    [_footer.buttonRecord addTarget:self action:@selector(startCamRec) forControlEvents:UIControlEventTouchDown];
    [_footer.buttonRecord addTarget:self action:@selector(stopCamRec) forControlEvents:UIControlEventTouchUpInside];
    
    [_footer.buttonTalk addTarget:self action:@selector(holdDownOpenTalk) forControlEvents:UIControlEventTouchDown];
    [_footer.buttonTalk addTarget:self action:@selector(holdReleaseCloseTalk) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"logout_video",nil)
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(puchBack)];
    //on tap
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleContainerTap:)]];
    [self loadSegmentedControl];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            [imageV setFrame :CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:imageV];
            break;
        }
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            [imageV setFrame:CGRectMake(0, 100, self.view.frame.size.width, (3*self.view.frame.size.width)/4)];
            imageV.userInteractionEnabled = YES;
            [self.view addSubview:imageV];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];

    [_menuQuality dismissViewControllerAnimated:NO completion:nil];
    [_cameraRecognizer addGestureRecognizer:imageV];
    [self displayHeaderAndFooter];
    
    reOpenVideo = NO;
    
    LogI(@"Usao u didAppear");

        [_menuQuality dismissViewControllerAnimated:NO completion:nil];
        [_cameraRecognizer addGestureRecognizer:imageV];
        [self displayHeaderAndFooter];
        
        reOpenVideo = NO;
        
        LogI(@"Usao u didAppear");
        
        int right = 0;
        FOSCMD_RESULT rst = FosSdk_Login(mHandle, &right, 300);
    
    if (rst == FOSCMDRET_TIMEOUT){
        //[ALERT_PRESENTER presentAlertWithTitle:@"FOSCMDRET_TIMEOUT" message:@"TRY_AGAIN"];

        rst = FosSdk_Login(mHandle, &right, 300);
        if (rst == FOSUSRRET_USRNAMEORPWD_ERR){
            
            [self reLogin];
            return;
        }
        [self CloseAllOperation];
        [self startAll];
    
    }
    
        if (rst == FOSUSRRET_USRNAMEORPWD_ERR){
            
            [self reLogin];
            return;
        }
        
        if([_sesija.sPass isEqualToString:@""]){ 
            Camera *changeFirstData = [coreDataManager getCameraWithUid:self.sesija.sUID];
            if([changeFirstData.password isEqualToString:@""]){
                NewCamDataViewController *ncdvc = [[NewCamDataViewController alloc]init];
                ncdvc.delegate = self;
                [ncdvc setTitle:[NSString stringWithFormat:NSLocalizedString(@"new_data",nil)]];
                ncdvc.newHandle = mHandle;
                [self.navigationController presentViewController:ncdvc animated:YES completion:nil];
            }
            _sesija.sPass = changeFirstData.password;
        }

        if (rst == FOSCMDRET_OK){
            
            [self startAll];
        }else if (rst == FOSCMDRET_TIMEOUT){
            [ALERT_PRESENTER presentAlertWithTitle:@"FOSCMDRET_TIMEOUT" message:@"TRY_AGAIN"];
            [self CloseAllOperation];
            [self startAll];
        }else{
            [self messagePresent];
        }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self CloseAllOperation];
    //[self performSegueWithIdentifier:@"myBord" sender:NULL];
    //[self.storyboard instantiateViewControllerWithIdentifier:@"myBord"] = nil;
    
    mHandle = 0;
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)messagePresent{
    
    [ALERT_PRESENTER presentAlertControllerWithConfigurationHandler:^(MTAlertDescriptor * descriptor) {
        descriptor.priority = MTAlertPriorityNormal;
        descriptor.title = NSLocalizedString(@"login_problem", nil);
        descriptor.message = NSLocalizedString(@"please_try_again", nil);
        descriptor.cancelTitle = NSLocalizedString(@"cancel", nil);
        descriptor.otherTitles = @[NSLocalizedString(@"retry", nil)];
        [descriptor setTapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
            if (buttonIndex != MTAlertBlocksCancelButtonIndex) {
                [self hudConnectionStart];
                [self CloseAllOperation];
                [self startAll];
            }else{
                [self goToBack];
            }
        }];
    }];
}

//#####################################################################################
//                                  Start & close
//#####################################################################################

- (void)startAll{
    
    _audioQueue = dispatch_queue_create("audioQueue", DISPATCH_QUEUE_SERIAL);
    [self audioInputInit];
    [self audioOutputInit];
    [self startVideo];
    [self startEvent];
}

-(void)CloseAllOperation{
    FosSdk_CloseVideo(mHandle, 500);
    FosSdk_CloseAudio(mHandle, 500);
    FosSdk_CloseTalk(mHandle, 500);
    
    m_videoPlaying = false;
    m_audioPlaying = false;
    m_talkPlaying = false;
    m_eventLoop = false;
}

//*************************************************************************************

//#####################################################################################
//                                  Protocol new data for cam login
//#####################################################################################

- (void)setNewUserNamePass:(NSString *)username withPass:(NSString *)password{


    char *ip = (char *)[_sesija.sIp UTF8String];
    char *uid = (char *)[_sesija.sUID  UTF8String];
    char *us = (char *)[username UTF8String];
    char *pw = (char *)[password UTF8String];
    
    NSInteger pt =[_sesija.sPort intValue];
    
    if (_sesija.connectionType == local){
        mHandle = FosSdk_Create(ip, "",  us, pw, pt, pt, FOSIPC_H264, FOSCNTYPE_IP);
    }else{
        mHandle = FosSdk_Create(ip, uid, us, pw, pt, pt, FOSIPC_H264, FOSCNTYPE_P2P);
    }
    
    int right = 0;
    FOSCMD_RESULT rst = FosSdk_Login(mHandle, &right, 300);
    
    if (rst == FOSCMDRET_OK){
    
    [self CloseAllOperation];
    [self startAll];
    }

}

//*************************************************************************************


//#####################################################################################
//                                  Draw video
//#####################################################################################


- (void) drawVideo {
    
    m_videoPlaying = false;
    BOOL steamNotFinished = YES;
    FOSSTREAM_TYPE streamQualty = FOSSTREAM_MAIN;
    
     while (steamNotFinished) {
    
        FOSCMD_RESULT ret  = FosSdk_OpenVideo(mHandle, streamQualty, 500);
        if (FOSCMDRET_OK != ret) {
            
            LogI(@"OPEN VIDEO nije ok 1x ");
            
            if(!reOpenVideo){
                [self CloseAllOperation];
                [self startAll];
                reOpenVideo = YES;
                
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES];
//            });
//
//            ret  = FosSdk_OpenVideo(mHandle, streamQualty, 500);
//            if (FOSCMDRET_OK != ret) {
//            
//                [self startAll];
//            }
//            [self reLogin];
//            
//            return;
        }
         dispatch_async(dispatch_get_main_queue(), ^{
             [hud hideAnimated:YES];
        });

        
        m_videoPlaying = true;
        FOSDEC_DATA* data = NULL;
        int outlen = 0;
        while (mHandle && m_videoPlaying) {
            
            if (streamQualty != _streamQalty){
                streamQualty = _streamQalty;
                break;
            }
            
            if ( FOSCMDRET_OK == FosSdk_GetVideoData(mHandle, (char**)&data, &outlen, FOSDECTYPE_RGB24) && outlen>0)
            {
                if (data->type == FOSMEDIATYPE_VIDEO) {
                    [self imageFromAVPicture:data->data width:data->media.video.picWidth height:data->media.video.picHeight];
                }
            }
            
            usleep(20*1000);
        }
         if (mHandle){
             FosSdk_CloseVideo(mHandle, 500);
         }else{
             steamNotFinished = NO;
         }
     }
}

-(UIImage*) imageFromAVPicture:(char*)data width:(int)width height:(int)height
{
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef dataRef = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, (const UInt8 *)data, width*height*3,kCFAllocatorNull);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(dataRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       width*3,
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    
    CGColorSpaceRelease(colorSpace);
    UIImage* image = [[UIImage alloc] initWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(dataRef);
    
    [self performSelectorOnMainThread:@selector(updateView:) withObject:image waitUntilDone:YES];
    //[image release];
    return nil;
}

-(void)updateView:(UIImage*)img
{
    if (nowSave){
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        
        if (status == PHAuthorizationStatusAuthorized) {
            
            [self performSelectorOnMainThread:@selector(saveToGaleryProgress) withObject:nil waitUntilDone:NO];
        }
        
        else if (status == PHAuthorizationStatusDenied) {
            //[self allowMessageProgress];
            [self performSelectorOnMainThread:@selector(allowMessageProgress) withObject:nil waitUntilDone:NO];
        }
        
        else if (status == PHAuthorizationStatusNotDetermined) {
            
            // Access has not been determined.
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performSelectorOnMainThread:@selector(saveToGaleryProgress) withObject:nil waitUntilDone:NO];
                }
                else {
                    //[self allowMessageProgress];
                    [self performSelectorOnMainThread:@selector(allowMessageProgress) withObject:nil waitUntilDone:NO];
                }
            }];
        }
        else if (status == PHAuthorizationStatusRestricted) {
            // Restricted access - normally won't happen.
        }
        nowSave = NO;
    }
    imageV.image = img;
}

//*************************************************************************************


//#####################################################################################
//              Login for change username&password on other iDevice
//#####################################################################################


- (void)reLogin{

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"cam_sign_requested",nil)
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"plsh_13",nil);
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"plsh_14",nil);
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self goToBack];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"sing_in",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * usernamefield = textfields[0];
        UITextField * passwordfiled = textfields[1];
        LogI(@"%@:%@",usernamefield.text,passwordfiled.text);
        
        usernamefield.text = [usernamefield.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        passwordfiled.text = [passwordfiled.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

        char *ip = (char *)[_sesija.sIp UTF8String];
        char *uid = (char *)[_sesija.sUID  UTF8String];
        char *us = (char *)[usernamefield.text UTF8String];
        char *pw = (char *)[passwordfiled.text UTF8String];
        
        NSInteger pt =[_sesija.sPort intValue];
        
        if (_sesija.connectionType == local){
            mHandle = FosSdk_Create(ip, "",  us, pw, pt, pt, FOSIPC_H264, FOSCNTYPE_IP);
        }else{
            mHandle = FosSdk_Create(ip, uid, us, pw, pt, pt, FOSIPC_H264, FOSCNTYPE_P2P);
        }
        
        int right = 0;
        FOSCMD_RESULT rst = FosSdk_Login(mHandle, &right, 300);
        if (rst != FOSCMDRET_OK){
            
            [self reLogin];
            
            return;
        }else{
            
            [coreDataManager addOrUpdateCamera:_sesija.sUID ssid:mySSID ssidPassword:sharedInstance.sSSIDpass ipPhone:sharedInstance.sIPIP ipCamera:_sesija.sIp username:usernamefield.text password:passwordfiled.text port:sharedInstance.sPort];
            
            [appDelegate saveContext];
            //[self hudConnectionStart];
            [self CloseAllOperation];
            [self startAll];
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//************************************************************************************


//#####################################################################################
//                                  Menu on tap
//#####################################################################################


- (IBAction)camSnapshot:(id)sender {
    
    nowSave = YES;
}


- (void)holdDownOpenTalk
{
    LogI(@"---------------------------------OPEN TALK DATA");

    m_talkPlaying = false;
    FOSCMD_RESULT res = FosSdk_OpenTalk(mHandle, 5000);
    if (FOSCMDRET_OK != res) {
        [ALERT_PRESENTER presentAlertWithTitle:@"start talk" message:@"fail"];
        return;
    }
    
    m_talkPlaying = true;
    [_audioOperation InitAudio:&_audio_fmt :120*8 :^(const void *frame, int size, int index, const AudioTimeStamp *time, void *userdata){
        FOSCMD_RESULT res = FosSdk_SendTalkData(mHandle, (char *)frame, size);
          LogI(@"OPEN TALK res %u", res);
        
    } :NULL];
}

- (void)holdReleaseCloseTalk
{
    LogI(@"---------------------------------CLOSE TALK DATA");
    
    FOSCMD_RESULT ret = FosSdk_CloseTalk(mHandle, 500);
    if (ret != FOSCMDRET_OK)
        [ALERT_PRESENTER presentAlertWithTitle:@"stop talk" message:@"fail"];
}


- (IBAction)openAudio:(id)sender {
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:(@"audioOFF")] forState:UIControlStateNormal];;
        [sender setSelected:NO];
        [self stopAudioData];
    } else {
        [sender setImage:[UIImage imageNamed:(@"audioON")] forState:UIControlStateSelected];
        [sender setSelected:YES];
        [self openAudioData];
    }
}

-(void) openAudioData {

     LogI(@"---------------------------------OPEN AUDIO DATA");
    
    m_audioPlaying = false;
    FOSCMD_RESULT ret = FosSdk_OpenAudio(mHandle, FOSSTREAM_MAIN, 500);
    if (ret != FOSCMDRET_OK) {
        [ALERT_PRESENTER presentAlertWithTitle:@"open audio" message:@"fail"];
        return;
    }
    
    m_audioPlaying = true;
    if (![_audioOutputOperation IsInit]) {
        [self audioOutputInit];
    }
    
    [_audioOutputOperation AudioStart];
    
    dispatch_async(_audioQueue, ^{
        FOSDEC_DATA* pAudioFrame=NULL;
        int audioSpeed = 0;
        int audioOutLen = 0;
        while (mHandle && m_audioPlaying) {
            FOSCMD_RESULT retGetAudio = FosSdk_GetAudioData2(mHandle, (char **)&pAudioFrame, &audioOutLen, &audioSpeed);
            
            if (FOSCMDRET_OK == retGetAudio && audioOutLen > 0 && pAudioFrame) {
                
                if ([_audioOutputOperation IsInit]) {
                    
                    [_audioOutputOperation WriteData:pAudioFrame->data : pAudioFrame->len];
                    
                    usleep(10*1000);
                }
            }
            usleep(20*1000);
        }
    });
}

-(void) stopAudioData {
    FOSCMD_RESULT ret = FosSdk_CloseAudio(mHandle, 500);
    if (ret != FOSCMDRET_OK)
        [ALERT_PRESENTER presentAlertWithTitle:@"close audio" message:@"fail"];
    
    [self.audioOutputOperation AudioStop];
}

- (void) recording:(NSString *)sec {
    
    NSInteger num = [sec integerValue];
    uint64_t iSeconds= (uint64_t)num;
    
    FosSdk_StopRecord(mHandle);
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"/YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    NSString *fileName = [DateTime stringByAppendingString:@".mp4"];
    NSString *filePath = [self getRecordingPathWithName: fileName];
    
    FOSCMD_RESULT ret = FosSdk_StartRecord(mHandle, FOSCNTYPE_MP4, [filePath UTF8String]);
    if (ret == FOSCMDRET_OK)
        LogI(@"start record ok %llu", iSeconds);
    
    uint64_t tick = getTickCount();
    
    while (getTickCount() - tick < iSeconds) {
        usleep(1000 * 1000);
    }
    
    FosSdk_StopRecord(mHandle);
    LogI(@"stop record");
}

- (IBAction)qualityMenu:(id)sender {
    
    _menuQuality=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"stream_quality",nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet ];
    UIAlertAction* mainStream = [UIAlertAction actionWithTitle:NSLocalizedString(@"good",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        _streamQalty = FOSSTREAM_MAIN;
        [_menuQuality dismissViewControllerAnimated:YES completion:nil];
        _menuQuality = nil;
    }];
    UIAlertAction* subStream = [UIAlertAction actionWithTitle:NSLocalizedString(@"low",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        _streamQalty = FOSSTREAM_SUB;
        [_menuQuality dismissViewControllerAnimated:YES completion:nil];
        _menuQuality = nil;
    }];
    [_menuQuality addAction:mainStream];
    [_menuQuality addAction:subStream];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _menuQuality.popoverPresentationController.sourceView = _footer;
        _menuQuality.popoverPresentationController.sourceRect = _footer.buttonQuality.frame;
    }else{// we need cancel for iphone
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
            [_menuQuality dismissViewControllerAnimated:YES completion:nil];
            _menuQuality = nil;
        }];
        [_menuQuality addAction:cancel];
    }
    [self presentViewController:_menuQuality animated:NO completion:nil];
}

- (void)startCamRec
{
    LogI(@"---------------------------------START REC VIDEO");
}


- (void)stopCamRec
{
    LogI(@"---------------------------------STOP REC VIDEO");
}

//************************************************************************************


//#####################################################################################
//                                  PTZ
//#####################################################################################
- (IBAction)ptzTop:(id)sender {
    
    [_top setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_UP, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_top setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzLeft:(id)sender {
    
    [_left setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_LEFT, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_left setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzRight:(id)sender {
    
    [_right setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_RIGHT, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_right setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzDown:(id)sender {
    
    [_down setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_DOWN, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_down setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzStop:(id)sender {
    
    [_stop setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_STOP, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_stop setEnabled:YES];
        } waitUntilDone:YES];
    }];
    
}

- (IBAction)ptzCenter:(id)sender {
    
    [_center setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_CENTER, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_center setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzLeftUp:(id)sender {
    
    [_leftUp setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_LEFT_UP, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_leftUp setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzLeftDown:(id)sender {
    
    [_leftDown setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_LEFT_DOWN, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_leftDown setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzRightUp:(id)sender {
    
    [_rightUp setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_RIGHT_UP, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_rightUp setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzRightDown:(id)sender {
    
    [_rightUp setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PtzCmd(mHandle, FOSPTZ_RIGHT_UP, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_rightUp setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzZoomIn:(id)sender {
    
    [_zoomIn setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PTZZoom(mHandle, FOSPTZ_ZOOMIN, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_zoomIn setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzZoomOut:(id)sender {
    
    [_zoomOut setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PTZZoom(mHandle, FOSPTZ_ZOOMOUT, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_zoomOut setEnabled:YES];
        } waitUntilDone:YES];
    }];
}

- (IBAction)ptzNoZoom:(id)sender {
    
    [_noZoom setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(RunInThread:) toTarget:self withObject:^(void* param){
        
        FosSdk_PTZZoom(mHandle, FOSPTZ_ZOOMSTOP, 500);
        
        [self performSelectorOnMainThread:@selector(RunInThread:) withObject:^(void* param){
            [_noZoom setEnabled:YES];
        } waitUntilDone:YES];
    }];
}



- (void)onPanEvent:(UICameraPanGestureEvent)event{
    
    switch (event) {
        case UICameraPanGestureEventUp: {
            FosSdk_PtzCmd(mHandle, FOSPTZ_UP, 500);
            LogI(@"Up");
            break;
        }
        case UICameraPanGestureEventDown: {
            FosSdk_PtzCmd(mHandle, FOSPTZ_DOWN, 500);
            LogI(@"Down");
            break;
        }
        case UICameraPanGestureEventLeft: {
            FosSdk_PtzCmd(mHandle, FOSPTZ_LEFT, 500);
            LogI(@"Left");
            break;
        }
        case UICameraPanGestureEventRight: {
            FosSdk_PtzCmd(mHandle, FOSPTZ_RIGHT, 500);
            LogI(@"Right");
            break;
        }
        case UICameraPanGestureEventUpRight: {
            FosSdk_PtzCmd(mHandle, FOSPTZ_RIGHT_UP, 500);
            LogI(@"UpRight");
            break;
        }
        case UICameraPanGestureEventUpLeft: {
            FosSdk_PtzCmd(mHandle, FOSPTZ_LEFT_UP, 500);
            LogI(@"UpLeft");
            break;
        }
        case UICameraPanGestureEventDownLeft: {
            FosSdk_PtzCmd(mHandle, FOSPTZ_LEFT_DOWN, 500);
            LogI(@"DownLeft");
            break;
        }
        case UICameraPanGestureEventDownRight: {
            FosSdk_PtzCmd(mHandle, FOSPTZ_RIGHT_DOWN, 500);
            LogI(@"DownRight");
            break;
        }
        case UICameraPanGestureEventStop:{
            FosSdk_PtzCmd(mHandle, FOSPTZ_STOP, 500);
            LogI(@"Pan STOP!");
            break;
        }
        default: {
            break;
        }
    }
}

- (void)onZoomEvent:(UICameraZoomGestureEvent)event{
    
}

//********************* Segmented Control *************************************

- (void)loadSegmentedControl{

    CGFloat sirinaSegmenta = self.view.frame.size.width * 0.65;
    int margina = 4;
    
    NSArray *itemArray = [NSArray arrayWithObjects: NSLocalizedString(@"up", nil), NSLocalizedString(@"down", nil), NSLocalizedString(@"left", nil), NSLocalizedString(@"right", nil), NSLocalizedString(@"stop", nil),nil];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(self.view.frame.size.width/2 - sirinaSegmenta/2, CGRectGetMaxY(imageV.frame)+margina, sirinaSegmenta, 33);
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.tintColor = [UIColor orangeColor];
    segmentedControl.selectedSegmentIndex = 4;
    segmentedControl.layer.cornerRadius = 15.0;
    segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentedControl.layer.borderWidth = 1.0f;
    segmentedControl.layer.masksToBounds = YES;
    [segmentedControl addTarget:self
                         action:@selector(segmentSwitch:)
               forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];

}

- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    
        switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                FosSdk_PtzCmd(mHandle, FOSPTZ_UP, 500);
                break;
            case 1:
                FosSdk_PtzCmd(mHandle, FOSPTZ_DOWN, 500);
                break;
            case 2:
                FosSdk_PtzCmd(mHandle, FOSPTZ_LEFT, 500);
                break;
            case 3:
                FosSdk_PtzCmd(mHandle, FOSPTZ_RIGHT, 500);
                break;
            case 4:
                FosSdk_PtzCmd(mHandle, FOSPTZ_STOP, 500);
                break;
            default:
                break;
        }
}

//**************************************************************************************


//#####################################################################################
//                                  HEADER & FOOTER
//#####################################################################################

-(void)displayHeaderAndFooter{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideHeaderAndFooter) object:self];
    if([_header isHidden]){
        [_header setHidden:NO];
        [_footer setHidden:NO];
        [self performSelector:@selector(hideHeaderAndFooter) withObject:self afterDelay:kHideHeaderInterval];
    }else{
        [self hideHeaderAndFooter];
    }
}

-(void)hideHeaderAndFooter{
    [_header setHidden:YES];
    [_footer setHidden:YES];
}

- (void)handleContainerTap:(UITapGestureRecognizer *)gestureRecognizer{
    [self displayHeaderAndFooter];
}

//************************************************************************************

//#####################################################################################
//                                  Audio
//#####################################################################################

- (void)audioInputInit{
    _audioOperation = [[FCInputAudio alloc] init];
    
    bzero(&_audio_fmt, sizeof(AudioStreamBasicDescription));
    _audio_fmt.mSampleRate = 8000;
    _audio_fmt.mFormatID = kAudioFormatLinearPCM;
    _audio_fmt.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    _audio_fmt.mBytesPerPacket = 2;
    _audio_fmt.mBytesPerFrame = 2;
    _audio_fmt.mFramesPerPacket = 1;
    _audio_fmt.mChannelsPerFrame = 1;
    _audio_fmt.mBitsPerChannel = 16;
}

-(void)audioOutputInit{
    if (!_audioOutputOperation) {
        _audioOutputOperation = [[FCOutputAudio alloc] init];
        bzero(&_outputaudio_fmt, sizeof(AudioStreamBasicDescription));
        _outputaudio_fmt.mSampleRate = 8000;
        _outputaudio_fmt.mFormatID = kAudioFormatLinearPCM;
        _outputaudio_fmt.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        _outputaudio_fmt.mBytesPerPacket = 2;
        _outputaudio_fmt.mBytesPerFrame = 2;
        _outputaudio_fmt.mFramesPerPacket = 1;
        _outputaudio_fmt.mChannelsPerFrame = 1;
        _outputaudio_fmt.mBitsPerChannel = 16;
        
    };
    
    if (![_audioOutputOperation IsInit]) {
        [_audioOutputOperation InitAudio:&_outputaudio_fmt : MAXAUDIOBUF];
    }
}

//************************************************************************************

//#####################################################################################
//                                  HUD
//#####################################################################################

- (void)saveToGaleryProgress{
    
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the custom view mode to show any view.
    hud2.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud2.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud2.label.text = NSLocalizedString(@"save_to_galery", nil);
    [hud2 hideAnimated:YES afterDelay:1.f];
    
    
}

- (void)allowMessageProgress{
    
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the custom view mode to show any view.
    hud2.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud2.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud2.label.text = NSLocalizedString(@"allow_access_privacy", nil);
    [hud2 hideAnimated:YES afterDelay:1.f];
    
    
}

- (void)hudConnectionStart{
    
    hud = [MBProgressHUD showHUDAddedTo:imageV animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"conn",nil);
    hud.detailsLabel.text = NSLocalizedString(@"loading_streaming",nil);
}

//**************************************************************************************

//#####################################################################################
//                                  Threads
//#####################################################################################

- (void) startVideo {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawVideo) object:NULL];
    [thread start];
}

- (void) startRecord:(int) sec {
    NSString *strSeconds = [NSString stringWithFormat:@"%d", sec];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(recording:) object:strSeconds];
    [thread start];
}

- (void)RunInThread :(RunFun) fun{
    LogI(@"runfunnnn Thread");
    fun(NULL);
}

- (void) startEvent {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(eventLoop) object:NULL];
    [thread start];
}

//*************************************************************************************

//#####################################################################################
//          Other func: rec, message, back,
//#####################################################################################

// for recording
- (NSString *)getRecordingPathWithName:(NSString *)fileName
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
       LogI(@"file manager %@", fileManager);
    return [cachesPath stringByAppendingString:fileName];
}

// for recording
uint64_t getTickCount(void)
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    uint64_t date = (uint64_t)time;
    return date;
}

-(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)puchBack{
    
    [self CloseAllOperation];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListCamsViewController *listCams =[storyboard instantiateViewControllerWithIdentifier:@"list"];
    [self.navigationController pushViewController:listCams animated:YES];
}

- (void)goToBack{
    
    [self CloseAllOperation];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) eventLoop {
    
    m_eventLoop = true;
    FOSEVET_DATA event;
    while (m_eventLoop) {
        
        FOSCMD_RESULT ret = FosSdk_GetEvent(mHandle, &event);
        
        if (ret != FOSCMDRET_OK)
        {
            usleep(1000 * 20);
            continue;
        }
        
        LogI(@"event id = %d", event.id);
        
        if (event.id == ALARM_EVENT_CHG)
        {
            FOSALARM *alarm = (FOSALARM *)event.data;
            LogI(@"event alarm change sec=%d", alarm->localAlarmRecordSecs);
            [self startRecord: alarm->localAlarmRecordSecs];
            
            
             NSDate *date = [NSDate date];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateStyle:NSDateFormatterMediumStyle];
             [formatter setTimeStyle:NSDateFormatterShortStyle];
             [formatter setDateFormat:@"/YYYY-MM-dd hh:mm:ss"];
             NSString *DateTime = [formatter stringFromDate:date];
             NSString *fileName = [DateTime stringByAppendingString:@".mp4"];
             NSString *filePath = [self getRecordingPathWithName: fileName];
             
             FosSdk_StopRecord(mHandle);
             FOSCMD_RESULT ret = FosSdk_StartRecord(mHandle, FOSCNTYPE_MP4, [filePath UTF8String]);
             if (ret == FOSCMDRET_OK)
             {
             LogI(@"start record ok!");
             }
            
        }
        
        usleep(1000 * 20);
    }
}

//*************************************************************************************


@end
