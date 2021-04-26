//
//  ListCamsControlerViewController.m
//  MTcams
//
//  Created by administrator on 5/10/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ListCamsViewController.h"
#import "MarqueeLabel.h"
#import "MarqueeTextField.h"
#import "Sesija.h"
#import "LIveViewController.h"
#import "Page0ViewController.h"
#import "PreferenceDefines.h"

static NSString* const kSSID_String = @"SSID";

static const float kMargin = 5 ;

@interface ListCamsViewController ()

@end

@implementation ListCamsViewController{
    NSMutableArray *cams;
    CoreDataManager *coreDataManager;
    AppDelegate *appDelegate;
    UIAlertController * alert;
    UIView *headerView;
    UILabel *label;
    NSString *mySSID, *userName;
}

@synthesize customTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mySSID = [[NSString alloc]init];
    mySSID = [MTSupport getCurrentWifiSSID];
    
    cams = [[NSMutableArray alloc]init];
    
    coreDataManager = [[CoreDataManager alloc]init];
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    userName = (NSString*)[preferences objectForKey:PREF_USER_EMAIL];
    
    customTableView.delegate = self;
    customTableView.dataSource = self;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, customTableView.frame.size.width, 7*kMargin)];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, customTableView.frame.size.width, 4*kMargin)];
    [headerView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont boldSystemFontOfSize:25]];
    [label setText:NSLocalizedString(@"list_cam",nil)];
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor clearColor]]; //your background color...
    self.customTableView.tableHeaderView = headerView;

    self.customTableView.allowsMultipleSelectionDuringEditing = NO;
    [self.customTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(StartConf)];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;    

}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    //self.navigationController.navigationBar.translucent = NO;
    
    if([userName isEqualToString:@"Admin"]){
        cams = [NSMutableArray arrayWithArray: coreDataManager.getAllCams];
    }else{
        NSArray *listUserCams = [NSMutableArray arrayWithArray: [coreDataManager getCamsForUser:userName]];
        
        for (NSString *uid in listUserCams) {
            Camera *getCam = [coreDataManager getCameraWithUid:uid];
            [cams addObject:getCam];
        }
    }

}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            [customTableView reloadData];
            
            [label setFrame:CGRectMake(0, 0, customTableView.frame.size.width,4*kMargin)];
            break;
        }
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            [customTableView reloadData];

            [headerView setFrame:CGRectMake(0, 0, customTableView.frame.size.width, 7*kMargin)];
            [label setFrame:CGRectMake(0, 0, customTableView.frame.size.width, 4*kMargin)];
            [headerView addSubview:label];
            //label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            self.customTableView.tableHeaderView = headerView;
            break;
        }
        default: {
            break;
        }
    }
}

- (void)StartConf{
    
    Page0ViewController *p0vc = [[Page0ViewController alloc]init];
    [p0vc setTitle:[NSString stringWithFormat:NSLocalizedString(@"choice_conf",nil)]];
    [self.navigationController pushViewController:p0vc animated:YES];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    Page1ViewController *p1 =[storyboard instantiateViewControllerWithIdentifier:@"page1"];
//    [self.navigationController pushViewController:p1 animated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return cams.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITextField *textField;
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIView *containerView;
    containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [containerView setBackgroundColor:[UIColor lightGrayColor]];

    int tag = (int)(indexPath.section);
    
    Camera *cam  = [cams objectAtIndex:tag];
    
    UILabel *labelName = [[MarqueeLabel alloc]initWithFrame:CGRectMake(kMargin, kMargin, (cell.frame.size.width)/4 - (2*kMargin), (cell.frame.size.height)/2- (2*kMargin))];
    labelName.textAlignment = NSTextAlignmentCenter;
    labelName.text = NSLocalizedString(@"camera",nil);
    labelName.textColor = [UIColor whiteColor];
    labelName.numberOfLines = 1;
    [labelName setBackgroundColor:[ UIColor grayColor]];
    [containerView addSubview:labelName];
    
    textField = [[MarqueeTextField alloc]initWithFrame:CGRectMake(kMargin + (cell.frame.size.width)/4, kMargin, (3*(cell.frame.size.width)/4) - (2*kMargin), (cell.frame.size.height)/2- (2*kMargin) )];
    textField.userInteractionEnabled = NO;
    
    
    textField.text = cam.uid;
    textField.layer.cornerRadius = kButtonDefCornerRadius;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor whiteColor];
    [textField setBackgroundColor:[UIColor grayColor]];
    [containerView addSubview:textField];

    UIButton *localBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [localBtn setFrame:CGRectMake(kMargin, kMargin+(cell.frame.size.height)/2, (cell.frame.size.width)/3 - (2*kMargin), (cell.frame.size.height)/2- (2*kMargin))];
    [localBtn setTitle: NSLocalizedString(@"local",nil) forState:UIControlStateNormal];
    localBtn.layer.cornerRadius = kButtonDefCornerRadius;
    [localBtn setTag:tag];
    [localBtn addTarget:self action:@selector(localButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [localBtn setBackgroundColor: [ UIColor orangeColor]];
    [containerView addSubview: localBtn];
    
    if([cam.ssid isEqualToString:mySSID]){
        [localBtn setEnabled:YES];
    }
    else{
        [localBtn setEnabled:NO];
        localBtn.userInteractionEnabled = NO;
    }
    
    UIButton *cloudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cloudBtn setFrame:CGRectMake(kMargin+(cell.frame.size.width)/3, kMargin+(cell.frame.size.height)/2, (cell.frame.size.width)/3- (2*kMargin), (cell.frame.size.height)/2 - (2*kMargin))];
    [cloudBtn setTitle:NSLocalizedString(@"cloud",nil) forState:UIControlStateNormal];
    cloudBtn.layer.cornerRadius = kButtonDefCornerRadius;
    [cloudBtn setTag:tag];
    [cloudBtn addTarget:self action:@selector(cloudButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cloudBtn setBackgroundColor: [ UIColor orangeColor]];
    [containerView addSubview: cloudBtn];

    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setFrame:CGRectMake( kMargin+ 2*(cell.frame.size.width)/3, kMargin+(cell.frame.size.height)/2, (cell.frame.size.width)/3- (2*kMargin), (cell.frame.size.height)/2 - (2*kMargin) )];
    [infoBtn setTitle:NSLocalizedString(@"info",nil) forState:UIControlStateNormal];
    infoBtn.layer.cornerRadius = kButtonDefCornerRadius;
    [infoBtn setTag:tag];
    [infoBtn addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setBackgroundColor: [ UIColor orangeColor]];
    [containerView addSubview: infoBtn];
    [cell.contentView addSubview: containerView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath* )indexPath{

    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        int tag = (int)(indexPath.section);
        
        Camera *cam  = [cams objectAtIndex:tag];
        [cams removeObjectAtIndex:tag];
        [customTableView reloadData];
        [coreDataManager removeCameraWithUid:cam.uid];
        
        [self progressDeleted];
    }
}

- (void)progressDeleted{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = NSLocalizedString(@"deleted", nil);
    [hud hideAnimated:YES afterDelay:1.f];
}

-(void)localButtonClicked:(UIButton*)sender
{
    LogI(@"Local button clicked");
    
    Camera *cam  = [cams objectAtIndex:sender.tag];
    Sesija *s = [[Sesija alloc] init];
    
    s.sUID           = cam.uid;
    s.sIp            = cam.ipCamera;
    s.sPort          = cam.port;
    s.sUn            = cam.username;
    s.sPass          = cam.password;
    s.connectionType = local;
    
    NSString *testString = [MTSupport getCurrentWifiSSID];
    LogI(@"Cam ssid = %@ ssid telefona = %@", cam.ssid, testString);
    
   

        dispatch_async(dispatch_get_main_queue(), ^{
            LIveViewController *live = (LIveViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"myBord"];
            live.sesija = s;
            [self.navigationController pushViewController:live animated:YES];
        });
}

-(void)cloudButtonClicked:(UIButton*)sender
{
    LogI(@"Cloud button clicked");
    
    Camera *cam  = [cams objectAtIndex:sender.tag];
    Sesija *s = [[Sesija alloc] init];
    
    s.sUID           = cam.uid;
    s.sIp            = cam.ipCamera;
    s.sPort          = cam.port;
    s.sUn            = cam.username;
    s.sPass          = cam.password;
    s.connectionType = cloud;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        LIveViewController *live = (LIveViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"myBord"];
        live.sesija = s;
        [self.navigationController pushViewController:live animated:YES];
    });
}


-(void)infoButtonClicked:(UIButton*)sender
{
    LogI(@"Info button clicked");
    Camera *cam  = [cams objectAtIndex:sender.tag];
    
    [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"about_cam",nil) message:[NSString stringWithFormat:NSLocalizedString(@"detalis_cam",nil), cam.uid, cam.ipCamera, cam.port, cam.username, cam.password, cam.ssid, cam.ssidPassword]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

@end
