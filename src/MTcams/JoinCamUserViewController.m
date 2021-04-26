//
//  JoinCamUserViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 6/12/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "JoinCamUserViewController.h"
#import "CoreDataManager.h"
#import "MarqueeLabel.h"
#import "MarqueeTextField.h"
#import "Camera+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "MBProgressHUD.h"
#import "NYSegmentedControl.h"

//static const float kMargin = 5 ;
static NSString *cellId = @"CellId";
typedef NS_ENUM(NSUInteger, RowTypeJoin) {
    rtCameras,
    rtUsers
};

@interface RowJoin : NSObject

@property  User *user;
@property  Camera *camera;
@property  BOOL isSelected;
@property  RowTypeJoin type;


@end

@implementation RowJoin
@end

@interface JoinCamUserViewController ()
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UITableView *customTableView;
@property(nonatomic, strong) NSMutableArray *userOptionsList;
@property(nonatomic, strong) NSMutableArray *camOptionsList;
@property(nonatomic) BOOL searchMode;
@end

@implementation JoinCamUserViewController{
    NSMutableArray *cams;
    NSMutableArray *users;
    CoreDataManager *coreDataManager;
    AppDelegate *appDelegate;
    UIAlertController *alert;
    //UISegmentedControl *segmentedControl;
    NYSegmentedControl *segmentedControl;
    RowJoin *choseFunc;
    NSArray *searchResults;
    UIButton *btnSelection, *btnEdit;
}


@synthesize customTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    coreDataManager = [[CoreDataManager alloc]init];
    
    cams = [[NSMutableArray alloc] init];
    _camOptionsList = [[NSMutableArray alloc] init];
    _userOptionsList = [[NSMutableArray alloc] init];
    searchResults = [[NSArray alloc] init];
    
    for (Camera *cam in  coreDataManager.getAllCams ) {
        RowJoin *row = [[RowJoin alloc] init];
        row.camera = cam;
        row.isSelected = NO;
        row.type = rtCameras;
        [cams addObject:row];
        [_camOptionsList addObject:row.camera.uid];
    }
    
    users = [[NSMutableArray alloc] init];
    
    for (User *user in  coreDataManager.getAllUsers ) {
        RowJoin *row = [[RowJoin alloc] init];
        row.user = user;
        row.isSelected = NO;
        row.type = rtUsers;
        [users addObject:row];
        [_userOptionsList addObject:row.user.email];
        
    }
    
    //cams = [NSMutableArray arrayWithArray: coreDataManager.getAllCams];
    //users = [NSMutableArray arrayWithArray: coreDataManager.getAllUsers];
    
    
    
    CGFloat sirinaSegmenta = self.view.frame.size.width * 0.33;
    CGFloat sirinaDugmeta = self.view.frame.size.width * 0.45;
    int visinaPolja = 40;
    int margina = 4;
    
    NSArray *itemArray = [NSArray arrayWithObjects: NSLocalizedString(@"users", nil), NSLocalizedString(@"cams", nil), nil];
 /*
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(self.view.frame.size.width/2 - sirinaSegmenta/2, CGRectGetMaxY(self.navigationController.navigationBar.frame)+kMarginDefault/6, sirinaSegmenta, 33);
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
 */
    
    segmentedControl = [[NYSegmentedControl alloc] initWithItems:itemArray];
   
    // Add desired targets/actions
    [segmentedControl addTarget:self action:@selector(segmentSwitch:) forControlEvents:UIControlEventValueChanged];
    
    // Customize and size the control
     segmentedControl.frame = CGRectMake(self.view.frame.size.width/2 - sirinaSegmenta/2, CGRectGetMaxY(self.navigationController.navigationBar.frame)+kMarginDefault/6, sirinaSegmenta, 33);
    segmentedControl.titleTextColor = [UIColor blackColor];
    segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    segmentedControl.segmentIndicatorBackgroundColor = [UIColor orangeColor];
    segmentedControl.backgroundColor = [UIColor grayColor];
    segmentedControl.borderWidth = 0.0f;
    segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    segmentedControl.segmentIndicatorInset = 2.0f;
    segmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    segmentedControl.cornerRadius = segmentedControl.intrinsicContentSize.height / 2.0f;
    segmentedControl.usesSpringAnimations = YES;

    // Add the control to your view
    //self.navigationItem.titleView = self->segmentedControl;
    [self.view addSubview:segmentedControl];
    
    
    
    // Search bar
    [self setupSearchBar];
    
    btnSelection =  [MTButton customizeButtonWithArrow:NSLocalizedString(@"selected_cam", nil) withFrame:CGRectMake(self.view.frame.size.width/2 - sirinaDugmeta/2, CGRectGetMaxY(self.searchBar.frame)+kMarginDefault/6, sirinaDugmeta, visinaPolja)];
    [btnSelection addTarget:self action:@selector(onButtonFuncClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSelection];
    
    CGFloat sirina = self.view.frame.size.width-1;
    CGFloat duzina = self.view.frame.size.height-CGRectGetMaxY(btnSelection.frame)+margina;
    
    self.customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnSelection.frame)+margina, sirina, duzina)];
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    //self.customTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.customTableView];
    
    //self.cellSelected = [NSMutableArray array];
    
    btnEdit = [MTButton createNavBarButton:NSLocalizedString(@"edit", nil)];
    [btnEdit addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _editButton = [[UIBarButtonItem alloc] initWithCustomView: btnEdit];
    
    UIButton* btnJoin = [MTButton createNavBarButton:NSLocalizedString(@"join", nil)];
    [btnJoin addTarget:self action:@selector(JoinCamUser) forControlEvents:UIControlEventTouchUpInside];
    _joinButton = [[UIBarButtonItem alloc] initWithCustomView:btnJoin];
    
    self.navigationItem.rightBarButtonItems = @[_joinButton,_editButton];
    
    if(segmentedControl.selectedSegmentIndex==0 ){
        searchResults = _userOptionsList;
    }else{
        searchResults = _camOptionsList;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
}

-(void)editButtonPressed{
    if ([btnEdit.currentTitle isEqualToString:NSLocalizedString(@"edit", nil)])
    {
        [self.customTableView setEditing:YES animated:YES];
        [btnEdit setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
    }else{
        [self.customTableView setEditing:NO animated:YES];
        [btnEdit setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
    }
}

- (void)JoinCamUser{
    
    if(segmentedControl.selectedSegmentIndex==0 ){
        
        // join cam with users
        
        NSMutableArray *eMails = [[NSMutableArray alloc]init];
        for (RowJoin *row in users){
            if (row.isSelected) {
                [eMails addObject:row.user.email];
            }
        }
        LogI(@"Camera uid: %@", choseFunc.camera.uid);
        [coreDataManager addJoinCamUsers:choseFunc.camera.uid users:eMails];
        [appDelegate saveContext];
        
        [self progressMessage:NSLocalizedString(@"successfully_join_cam",nil)];
        
    }else{
        
        // join user with cams
        NSMutableArray *uids = [[NSMutableArray alloc]init];
        for (RowJoin *row in cams){
            if (row.isSelected) {
                [uids addObject:row.camera.uid];
            }
        }
        LogI(@"User uid: %@", choseFunc.user.email);
        [coreDataManager addJoinUserCams:choseFunc.user.email cams:uids];
        [appDelegate saveContext];
        
        [self progressMessage:NSLocalizedString(@"successfully_join_user",nil)];
    }
}

- (IBAction)segmentSwitch:(NYSegmentedControl *)sender {
    
    if(segmentedControl.selectedSegmentIndex==0 ){
        [btnSelection setTitle:NSLocalizedString(@"selected_cam", nil) forState:UIControlStateNormal];
        searchResults = _userOptionsList;
        
    }else{
        [btnSelection setTitle:NSLocalizedString(@"selected_user", nil) forState:UIControlStateNormal];
        searchResults = _camOptionsList;
    }
    [customTableView reloadData];
}

- (void)onButtonFuncClicked:(UIButton *)sender{
    
    LogI(@"onButtonFuncClicked Frame segmentedControl: %@", NSStringFromCGRect(segmentedControl.frame));
    
    if(segmentedControl.selectedSegmentIndex==0 ){
        
        alert =[UIAlertController
                alertControllerWithTitle:NSLocalizedString(@"selected_cam", nil)
                message:nil
                preferredStyle:UIAlertControllerStyleActionSheet ];
        for (NSUInteger i =0; i<cams.count; i++) {
            RowJoin *row = cams[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:[row.camera uid ] style:UIAlertActionStyleDefault handler:^(UIAlertAction*  action){
                [self onFunctionSelected:(int)i];
                [alert dismissViewControllerAnimated:YES completion:nil];
                alert = nil;
            }];
            [alert addAction:action];
        }
    }else{
        alert =[UIAlertController
                alertControllerWithTitle:NSLocalizedString(@"selected_user", nil)
                message:nil
                preferredStyle:UIAlertControllerStyleActionSheet ];
        for (NSUInteger i =0; i<users.count; i++) {
            RowJoin *row = users[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:[row.user email ] style:UIAlertActionStyleDefault handler:^(UIAlertAction*  action){
                [self onFunctionSelected:(int)i];
                [alert dismissViewControllerAnimated:YES completion:nil];
                alert = nil;
            }];
            [alert addAction:action];
        }
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction*  action){
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:NO completion:nil];
    
    //LogI(@"onButtonFuncClicked END Frame segmentedControl: %@", NSStringFromCGRect(segmentedControl.frame));
}

- (void)onFunctionSelected:(int)index{
    
    if(segmentedControl.selectedSegmentIndex==0 ){
        btnSelection.titleLabel.text = ((RowJoin*)cams[index]).camera.uid;
        choseFunc = (RowJoin*)cams[index];
        NSArray *selectedUser = [coreDataManager getUsersForCam:((RowJoin*)cams[index]).camera.uid];
        
        for (RowJoin * row in users){
            row.isSelected = NO;
            for (NSString *idUser in selectedUser) {
                if ([row.user.email isEqualToString:idUser] ) {
                    row.isSelected = YES;
                    break;
                }
            }
        }
    }else{
        btnSelection.titleLabel.text = ((RowJoin*)users[index]).user.email;
        NSArray *selectedCam = [coreDataManager getCamsForUser:((RowJoin*)users[index]).user.email];
        choseFunc = (RowJoin*)users[index];
        for (RowJoin * row in cams){
            row.isSelected = NO;
            for (NSString *idCam in selectedCam) {
                if ([row.camera.uid isEqualToString:idCam] ) {
                    row.isSelected = YES;
                    break;
                }
            }
        }
    }
    [customTableView reloadData];
}

/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 if(segmentedControl.selectedSegmentIndex==0 ){
 return users.count;
 }else{
 return cams.count;
 }
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return 1;
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(segmentedControl.selectedSegmentIndex==0 ){
        if (searchResults.count < _userOptionsList.count) {
            return [searchResults count];
        } else {
            return _userOptionsList.count;
        }
    }else{
        if (searchResults.count < _camOptionsList.count) {
            return [searchResults count];
        } else {
            return _camOptionsList.count;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell
    UITableViewCell *tableCell = [self.customTableView dequeueReusableCellWithIdentifier:cellId];
    [tableCell setAccessoryType:UITableViewCellAccessoryNone];
    // selection
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    int tag = (int)(indexPath.section);
    
    if(segmentedControl.selectedSegmentIndex==0 ){
        if (searchResults != nil || _userOptionsList != nil) {
            if (_searchMode) {
                tableCell.textLabel.text = [searchResults objectAtIndex: indexPath.row];
            } else {
                RowJoin *row  = [users objectAtIndex:tag];
                tableCell.textLabel.text = row.user.email;
                tableCell.accessoryType = row.isSelected? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            }
        }
    }else{
        if (searchResults != nil || _camOptionsList != nil) {
            if (_searchMode) {
                tableCell.textLabel.text = [searchResults objectAtIndex: indexPath.row];
            } else {
                RowJoin *row  = [cams objectAtIndex:tag];
                tableCell.textLabel.text =row.camera.uid;
                tableCell.accessoryType = row.isSelected? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            }
        }
    }
    
    return tableCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    LogI(@"didSelectRowAtIndexPath inxekspath: %@, usersCount: %lu camsCount: %lu , ss: %ld", indexPath, (unsigned long)users.count, (unsigned long)cams.count, (long)segmentedControl.selectedSegmentIndex);
    
    if(segmentedControl.selectedSegmentIndex==0 ){
        RowJoin *row  = [users objectAtIndex:(int)indexPath.section];
        row.isSelected = !row.isSelected;
        cell.accessoryType = row.isSelected? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }else{
        RowJoin *row  = [cams objectAtIndex:(int)indexPath.section];
        row.isSelected = !row.isSelected;
        cell.accessoryType = row.isSelected? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}

- (CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath* )indexPath{
    return 100;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    int tag = (int)(indexPath.section);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(segmentedControl.selectedSegmentIndex==0 ){
            RowJoin *row  = [users objectAtIndex:tag];
            [users removeObjectAtIndex:tag];
            [_userOptionsList removeObjectAtIndex:tag];
            [coreDataManager removeUserWithMail:row.user.email];
            LogI(@"Removed user with email: %@", row.user.email);
        }else{
            RowJoin *row  = [cams objectAtIndex:tag];
            [cams removeObjectAtIndex:tag];
            [_camOptionsList removeObjectAtIndex:tag];
            [coreDataManager removeCameraWithUid:row.camera.uid];
            LogI(@"Removed cam with uid: %@", row.camera.uid);
        }
        [appDelegate saveContext];
        [self progressMessage:@"Deleted"];
        [self.customTableView setEditing:NO animated:YES];
        [customTableView reloadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
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

- (void)progressMessage:(NSString*)textMessage{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = NSLocalizedString(textMessage, nil);
    [hud hideAnimated:YES afterDelay:1.3f];
}

#pragma mark - SearchBar

-(void)setupSearchBar {
    if(IS_IPAD) {
        // _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.view.origin.x, self.view.origin.y + self.navigationController.navigationBar.size.height, self.view.size.width, kDefHeightForRow)];
        _searchBar = [[MTSearchBar alloc] initWithFrame:CGRectMake(self.view.origin.x, CGRectGetMaxY(self->segmentedControl.frame)+kMarginDefault, self.view.size.width, kDefHeightForRow)];
    } else {
        _searchBar = [[MTSearchBar alloc] initWithFrame:CGRectMake(self.view.origin.x, CGRectGetMaxY(self->segmentedControl.frame)+kMarginDefault/6, self.view.size.width, kDefHeightForRow)];
    }
    [self.view addSubview:_searchBar];
    _searchBar.delegate = self;
    _searchMode = NO;
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
        if(segmentedControl.selectedSegmentIndex==0 ){
            searchResults = _userOptionsList;
        }else{
            searchResults = _camOptionsList;
        }
        [customTableView reloadData];
        _searchMode = NO;
    } else {
        _searchMode = YES;
        [self filterContentForSearchText:_searchBar.text scope:nil];
    }
}

#pragma mark - Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    if(segmentedControl.selectedSegmentIndex==0 ){
        searchResults = [_userOptionsList filteredArrayUsingPredicate:resultPredicate];
    }else{
        searchResults = [_camOptionsList filteredArrayUsingPredicate:resultPredicate];
    }
    [customTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.view endEditing:YES];
}

@end

