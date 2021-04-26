//
//  TestCameraAndUserViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 6/1/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "TestCameraAndUserViewController.h"
#import "MBProgressHUD.h"
#import "ListCamsViewController.h"
#import "Settings.h"


static NSString* const kSSID_String = @"SSID";

@interface TestCameraAndUserViewController (){
    NSString  *uidText, *ipText, *portText, *unText, *passText, *mySSID, *errorMSG;
    AppDelegate *appDelegate;
    Settings *sharedInstance;
}

@end

@implementation TestCameraAndUserViewController{
    UISegmentedControl *segmentedControl;
    NSString  *email, *pass, *first, *middle, *last, *date, *town, *code, *adress, *country, *phone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mySSID = [[NSString alloc]init];
    mySSID = [MTSupport getCurrentWifiSSID];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.coreDataManager = [[CoreDataManager alloc]init];

    [self loadSegmentedControl];
    if(segmentedControl.selectedSegmentIndex==0 ){
        [self loadAddCamPageView];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"add", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(AddedData)];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    sharedInstance = APP_SETTINGS;
}


- (void)loadSegmentedControl{
    CGFloat sirinaSegmenta = self.view.frame.size.width * 0.33;
    int margina = 4;
    
    NSArray *itemArray = [NSArray arrayWithObjects: NSLocalizedString(@"cams", nil), NSLocalizedString(@"users", nil), nil];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(self.view.frame.size.width/2 - sirinaSegmenta/2, CGRectGetMaxY(self.navigationController.navigationBar.frame)+margina, sirinaSegmenta, 33);
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.tintColor = [UIColor orangeColor];
    segmentedControl.selectedSegmentIndex = 0;
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
    if(segmentedControl.selectedSegmentIndex==0 ){
        [self.scrollView setHidden:YES];
        [self loadAddCamPageView];
    }else{
        [self loadUserPageView];
    }
}

- (void)AddedData{
    if(segmentedControl.selectedSegmentIndex==0 ){
        [self addCam];
    }else{
        [self addUser];
    }
}


- (void)loadAddCamPageView{
    
    CGFloat sirinaPolja = self.view.frame.size.width * 0.8;
    int margina = 10;
    int visinaPolja = 40;
    
    self.uid =       [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self->segmentedControl.frame)+margina, sirinaPolja, visinaPolja)];
    self.ip =        [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.uid.frame)+margina , sirinaPolja, visinaPolja)];
    self.port =      [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.ip.frame)+margina , sirinaPolja, visinaPolja)];
    self.username =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.port.frame)+margina , sirinaPolja, visinaPolja)];
    self.password =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.username.frame)+margina , sirinaPolja, visinaPolja)];
    
    _uid.text        = @"8A4XHF6IKLAGWEJHZZZZAY2Z";
    _ip.text         = @"192.168.0.107";
    _port.text       = @"88";
    _username.text   = @"Admin";
    _password.text   = @"";
    
    [_uid customizeField:_uid withView:self.view andPlaceholder:NSLocalizedString(@"plsh_17",nil)];
    [_ip customizeField:_ip withView:self.view andPlaceholder:NSLocalizedString(@"plsh_18",nil)];
    [_port customizeField:_port withView:self.view andPlaceholder:NSLocalizedString(@"plsh_19",nil)];
    [_username customizeField:_username withView:self.view andPlaceholder:NSLocalizedString(@"plsh_15", nil)];
    [_password customizeField:_password withView:self.view andPlaceholder:NSLocalizedString(@"plsh_16", nil)]; 
}

-(void)loadUserPageView{
    
    //CGRect frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-1);
    //CGRect frame = CGRectMake( 30, 30, 300, 300);
    
    int margina = 7;
    CGFloat sirina = self.view.frame.size.width-1;
    CGFloat duzina = self.view.frame.size.height-CGRectGetMaxY(self->segmentedControl.frame)+margina;
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self->segmentedControl.frame)+margina, sirina, duzina);
    
    self.scrollView= [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView setBackgroundColor: [UIColor blackColor]];
    [_scrollView setUserInteractionEnabled:YES];
    [_scrollView setScrollEnabled:YES];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
     _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_scrollView];

    
    
    CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
    int visinaPolja = 40;
    
    self.emailField =       [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, margina, sirinaPolja, visinaPolja)];
    self.passwordField =    [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.emailField.frame)+margina , sirinaPolja, visinaPolja)];
    self.firstNameField =   [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.passwordField.frame)+margina, sirinaPolja, visinaPolja)];
    self.middleNameField =  [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.firstNameField.frame)+margina, sirinaPolja, visinaPolja)];
    self.lastNameField =    [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.middleNameField.frame)+margina , sirinaPolja, visinaPolja)];
    self.dateOfBirthField = [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.lastNameField.frame)+margina , sirinaPolja, visinaPolja)];
    self.townField =        [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.dateOfBirthField.frame)+margina , sirinaPolja, visinaPolja)];
    self.postalCodeField =  [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.townField.frame)+margina, sirinaPolja, visinaPolja)];
    self.adressField =      [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.postalCodeField.frame)+margina , sirinaPolja, visinaPolja)];
    self.countryField =     [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.adressField.frame)+margina , sirinaPolja, visinaPolja)];
    self.phoneField =       [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.countryField.frame)+margina , sirinaPolja, visinaPolja)];
    self.role =             [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(self.phoneField.frame)+margina , sirinaPolja, visinaPolja)];
    
    [_emailField customizeField:_emailField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_1",nil)];
    [_passwordField customizeField:_passwordField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_2",nil)];
    [_firstNameField customizeField:_firstNameField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_3",nil)];
    [_middleNameField customizeField:_middleNameField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_4",nil)];
    [_lastNameField customizeField:_lastNameField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_5",nil)];
    [_dateOfBirthField customizeField:_dateOfBirthField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_6",nil)];
    [_adressField customizeField:_adressField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_7",nil)];
    [_townField customizeField:_townField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_8",nil)];
    [_postalCodeField customizeField:_postalCodeField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_9",nil)];
    [_countryField customizeField:_countryField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_10",nil)];
    [_phoneField customizeField:_phoneField withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_11",nil)];
    [_role customizeField:_role withView:self.scrollView andPlaceholder:NSLocalizedString(@"plsh_12",nil)];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)addCam{
    
    LogI(@"Add Cam clicked");
    
    uidText  = _uid.text;
    ipText   = _ip.text;
    portText = _port.text;
    unText   = _username.text;
    passText = _password.text;
    
    uidText  = [uidText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    ipText   = [ipText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    portText = [portText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    unText   = [unText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    passText = [passText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if ([uidText isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"msg_16",nil)];
        return;
    }
    if ([ipText isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"msg_17",nil)];
        return;
    }
    if([portText isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"msg_18",nil)];
        return;
    }
    if ([unText isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"msg_12", nil)];
        return;
    }

    if (![uidText isEqualToString:@""] && ![ipText isEqualToString:@""] && ![portText isEqualToString:@""] && ![portText isEqualToString:@""]){
       
        [self.coreDataManager addOrUpdateCamera:uidText ssid:mySSID ssidPassword:@"" ipPhone:@"" ipCamera:ipText username:unText password:passText port:portText];
        [appDelegate saveContext];
        
        sharedInstance.sConfigured = YES;
        [self progressAdded];
        [self goToHomeView];
    }

    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //ListCamsViewController *listCams =[storyboard instantiateViewControllerWithIdentifier:@"list"];
    //[self.navigationController pushViewController:listCams animated:YES];
}

-(void)addUser{
    
    email   = [self.emailField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    pass    = [self.passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    first   = [self.firstNameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    middle  = [self.middleNameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    last    = [self.lastNameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    date    = [self.dateOfBirthField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    town    = [self.townField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    code    = [self.postalCodeField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    adress  = [self.adressField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    country = [self.countryField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    phone   = [self.phoneField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (![MTSupport validateEmail:email]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_1",nil)];
        return;
    }
    if ([pass isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_2",nil)];
        return;
    }
    if ([first isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_3",nil)];
        return;
    }
    if([last isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_4",nil)];
        return;
    }
    if ([middle isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_5",nil)];
        return;
    }
    if ([date isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_6",nil)];
        return;
    }
    if ([town isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_7",nil)];
        return;
    }
    if([code isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_8",nil)];
        return;
    }
    if ([adress isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_9",nil)];
        return;
    }
    if ([country isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_10",nil)];
        return;
    }
    if ([phone isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_11",nil)];
        return;
    }
    
    
    [_coreDataManager addOrUpdateUserEmail:self.emailField.text password:self.passwordField.text firstName:self.firstNameField.text middleName:self.middleNameField.text lastName:self.lastNameField.text dateOfBirth:self.dateOfBirthField.text phone:self.phoneField.text address:self.adressField.text town:self.townField.text postal:self.postalCodeField.text country:self.countryField.text role:self.role.text];
    
    [appDelegate saveContext];

    [self progressAdded];
    
    self.emailField.text = nil;
    self.passwordField.text = nil;
    self.firstNameField.text = nil;
    self.middleNameField.text = nil;
    self.lastNameField.text = nil;
    self.dateOfBirthField.text = nil;
    self.townField.text = nil;
    self.postalCodeField.text = nil;
    self.adressField.text = nil;
    self.countryField.text = nil;
    self.phoneField.text = nil;
    self.role.text = nil;
    
    
}

- (void)goToHomeView{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)progressAdded{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = NSLocalizedString(@"added",nil);
    [hud hideAnimated:YES afterDelay:1.f];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7]; // if you want to slide up the view
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y-kbSize.height/1.2), self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    [self.view setFrame:CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-1)];
}



@end
