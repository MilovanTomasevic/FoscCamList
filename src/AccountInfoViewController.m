//
//  AccountInfoViewController.m
//  MTcams
//
//  Created by administrator on 5/22/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "PreferenceDefines.h"
#import "MBProgressHUD.h"

static NSString *cellId = @"CellId";

@interface AccountInfoViewController ()
@property(nonatomic, strong) MTSearchBar *searchBar;
@property(nonatomic, strong) UITableView *usersTableView;
@property(nonatomic, strong) NSMutableArray *userOptionsList;
@property(nonatomic) BOOL searchMode;
@end

@implementation AccountInfoViewController{
    CoreDataManager *coreDataManager;
    AppDelegate *appDelegate;
    User *userInfo;
    NSString  *email, *pass, *first, *middle, *last, *date, *town, *code, *adress, *country, *phone, *isAdmin;
    NSArray *searchResults;
    UITableViewCell *tableCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    coreDataManager = [[CoreDataManager alloc]init];
    
    
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    isAdmin = (NSString*)[preferences objectForKey:PREF_USER_EMAIL];
    
    if([isAdmin isEqualToString:@"Admin"]){
        
        _userOptionsList = [[NSMutableArray alloc] init];
        
        for (User *user in  coreDataManager.getAllUsers ) {
            [_userOptionsList addObject:user.email];
        }
        LogI(@"%@",_userOptionsList);
        
        [self loadAdminPage];
    }else{
        [self loadViewPage];
    }
    [self disableFields];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(![isAdmin isEqualToString:@"Admin"]){
        [self getUserData];
        [self rightEditButton];
    }
}


- (void)getUserData{
    
    coreDataManager = [[CoreDataManager alloc]init];
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString *mail = [preferences objectForKey:PREF_USER_EMAIL];
    
    userInfo =  [coreDataManager getUserWithMail:mail];
    
    self.emailField.text       =  userInfo.email;
    self.passwordField.text    =  userInfo.password;
    self.firstNameField.text   =  userInfo.firstName;
    self.middleNameField.text  =  userInfo.middleName;
    self.lastNameField.text    =  userInfo.lastName;
    self.dateOfBirthField.text =  userInfo.dateOfBirth;
    self.townField.text        =  userInfo.town;
    self.postalCodeField.text  =  userInfo.postalCode;
    self.adressField.text      =  userInfo.adress;
    self.countryField.text     =  userInfo.country;
    self.phoneField.text       =  userInfo.phone;
    self.role.text             =  userInfo.role;
    
}


- (void)rightEditButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"edit",nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dataManagement)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;
}


-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            LogI(@"frame %f size %f,%f", _scrollView.frame.size.height, _scrollView.contentSize.width, _scrollView.contentSize.height);
            break;
        }
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            LogI(@"frame %f size %f,%f", _scrollView.frame.size.height, _scrollView.contentSize.width, _scrollView.contentSize.height);
            break;
        }
        default: {
            break;
        }
    }
}

- (void)dataManagement{
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:NSLocalizedString(@"edit",nil)])
    {
        self.navigationItem.rightBarButtonItem.title= NSLocalizedString(@"done",nil);
        [self setupFields];
        [self enableFields];
        
    }else{
        
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
        
        self.navigationItem.rightBarButtonItem.title= NSLocalizedString(@"edit",nil);
        
        [self disableFields];
        
        [coreDataManager addOrUpdateUserEmail:self.emailField.text password:self.passwordField.text firstName:self.firstNameField.text middleName:self.middleNameField.text lastName:self.lastNameField.text dateOfBirth:self.dateOfBirthField.text phone:self.phoneField.text address:self.adressField.text town:self.townField.text postal:self.postalCodeField.text country:self.countryField.text role:self.role.text];
        
        [appDelegate saveContext];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.emailField.text forKey:PREF_USER_EMAIL];
        [[NSUserDefaults standardUserDefaults] setValue:self.passwordField.text forKey:PREF_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_USER_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self getUserData];
        [self progressDone];
    }
}


-(void)disableField:(UITextField*)field{
    
    field.userInteractionEnabled = NO;
    field.backgroundColor = [UIColor grayColor];
    field.textColor = [UIColor cyanColor];
}

-(void)enableField:(UITextField*)field{
    
    field.userInteractionEnabled = YES;
    field.backgroundColor = [UIColor whiteColor];
    field.textColor = [UIColor darkTextColor];
}

-(void)disableFields{
    [self disableField:_emailField];
    [self disableField:_passwordField];
    [self disableField:_firstNameField];
    [self disableField:_middleNameField];
    [self disableField:_lastNameField];
    [self disableField:_dateOfBirthField];
    [self disableField:_adressField];
    [self disableField:_townField];
    [self disableField:_postalCodeField];
    [self disableField:_countryField];
    [self disableField:_phoneField];
    [self disableField:_role];
}

-(void)enableFields{
    [self enableField:_emailField];
    [self enableField:_passwordField];
    [self enableField:_firstNameField];
    [self enableField:_middleNameField];
    [self enableField:_lastNameField];
    [self enableField:_dateOfBirthField];
    [self enableField:_adressField];
    [self enableField:_townField];
    [self enableField:_postalCodeField];
    [self enableField:_countryField];
    [self enableField:_phoneField];
    [self enableField:_role];
}

- (void)progressDone{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = NSLocalizedString(@"info_updated",nil);
    [hud hideAnimated:YES afterDelay:1.f];
}


- (void)loadAdminPage{
    
    // Search bar
    [self setupSearchBar];
    [self.view addSubview:_searchBar];
    _searchBar.delegate = self;
    
    // Table view
    if(IS_IPAD) {
        //usersTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, _searchBar.origin.y + _searchBar.size.height, kDefUIModalPresentationFormSheetWidth, kDefUIModalPresentationFormSheetHeight - 2*_searchBar.size.height) style:UITableViewStylePlain];
    } else {
        // _timeZonesTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, _searchBar.origin.y + _searchBar.size.height, self.view.size.width, self.view.size.height - _searchBar.origin.y - _searchBar.size.height) style:UITableViewStylePlain];
        
        int margina = 4;
        CGFloat sirina = self.view.frame.size.width-1;
        CGFloat duzina = self.view.frame.size.height-CGRectGetMaxY(_searchBar.frame)+margina;
        
        self.usersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame)+margina, sirina, duzina) style:UITableViewStylePlain];
    }
    _usersTableView.dataSource = self;
    _usersTableView.delegate = self;
    _usersTableView.backgroundColor = [UIColor clearColor];
    _usersTableView.bounces = NO;
    _usersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_usersTableView];
    
    searchResults = _userOptionsList;
    _searchMode = NO;
}

#pragma mark - SearchBar

-(void)setupSearchBar {
    if(IS_IPAD) {
        _searchBar = [[MTSearchBar alloc] initWithFrame:CGRectMake(self.view.origin.x, self.view.origin.y + self.navigationController.navigationBar.size.height, self.view.size.width, kDefHeightForRow)];
    } else {
        _searchBar = [[MTSearchBar alloc] initWithFrame:CGRectMake(self.view.origin.x, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.size.width, kDefHeightForRow)];
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _searchMode = YES;
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchMode = YES;
    [self filterContentForSearchText:_searchBar.text scope:nil];
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        searchResults = _userOptionsList;
        [_usersTableView reloadData];
        _searchMode = NO;
    } else {
        _searchMode = YES;
        [self filterContentForSearchText:_searchBar.text scope:nil];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    searchResults = [_userOptionsList filteredArrayUsingPredicate:resultPredicate];
    [_usersTableView reloadData];
}


- (void)loadViewPage{
    
    CGRect frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-1);
    //CGRect frame = CGRectMake( 30, 30, 300, 300);
    self.scrollView= [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView setBackgroundColor: [UIColor blackColor]];
    [_scrollView setUserInteractionEnabled:YES];
    [_scrollView setScrollEnabled:YES];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    // _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_scrollView];
    
    
    CGFloat sirinaPolja = self.scrollView.frame.size.width * 0.7;
    int margina = 10;
    int visinaPolja = 40;
    int visina = 30;
    
    self.emailField =       [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
    self.passwordField =    [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + visinaPolja + margina , sirinaPolja, visinaPolja)];
    self.firstNameField =   [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 2*visinaPolja + 2*margina , sirinaPolja, visinaPolja)];
    self.middleNameField =  [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 3*visinaPolja + 3*margina , sirinaPolja, visinaPolja)];
    self.lastNameField =    [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 4*visinaPolja + 4*margina , sirinaPolja, visinaPolja)];
    self.dateOfBirthField = [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 5*visinaPolja + 5*margina , sirinaPolja, visinaPolja)];
    self.townField =        [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 6*visinaPolja + 6*margina , sirinaPolja, visinaPolja)];
    self.postalCodeField =  [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 7*visinaPolja + 7*margina , sirinaPolja, visinaPolja)];
    self.adressField =      [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 8*visinaPolja + 8*margina , sirinaPolja, visinaPolja)];
    self.countryField =     [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 9*visinaPolja + 9*margina , sirinaPolja, visinaPolja)];
    self.phoneField =       [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 10*visinaPolja + 10*margina , sirinaPolja, visinaPolja)];
    self.role =             [[MTTextField alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - sirinaPolja/2, visina + 11*visinaPolja + 11*margina , sirinaPolja, visinaPolja)];
    
    [self setupFields];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    //self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)setupFields{
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
}

/*
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
 }*/

#pragma mark - keyboard movements
- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height+50;
        self.view.frame = f;
    }];
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchResults.count < _userOptionsList.count) {
        return [searchResults count];
    } else {
        return _userOptionsList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell
    tableCell = [_usersTableView dequeueReusableCellWithIdentifier:cellId];
    [tableCell setAccessoryType:UITableViewCellAccessoryNone];
    // selection
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        //tableCell.textLabel.styleName = OCFontStyleLight;
    }
    if (searchResults != nil || _userOptionsList != nil) {
        if (_searchMode) {
            tableCell.textLabel.text = [searchResults objectAtIndex: indexPath.row];
        } else {
            tableCell.textLabel.text = [_userOptionsList objectAtIndex: indexPath.row];
        }
        //        if([_chosenTimeZoneName isEqualToString:tableCell.textLabel.text]) {
        //            [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        //        }
    }
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell.backgroundColor = [THEME_MANAGER getBackgroundColor];
    //cell.textLabel.textColor = [THEME_MANAGER getTextColor];
}

/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 [self resignFirstResponder];
 // cell
 tableCell = [_userTableView dequeueReusableCellWithIdentifier:cellId];
 
 if(_searchMode) {
 _chosenTimeZoneName = [searchResults objectAtIndex:indexPath.row];
 } else {
 _chosenTimeZoneName = [_timeZoneOptionsList objectAtIndex:indexPath.row];
 }
 if([currentTimeZoneName isEqualToString:_chosenTimeZoneName]) {
 doneBtn.enabled = NO;
 } else {
 doneBtn.enabled = YES;
 }
 [tableView reloadData];
 }*/

@end
