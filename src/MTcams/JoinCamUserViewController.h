//
//  JoinCamUserViewController.h
//  MTcams
//
//  Created by Milovan Tomasevic on 6/12/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinCamUserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UISearchBarDelegate>


//@property (nonatomic, strong) UIStackView *stackView;

@property (strong, nonatomic) UIBarButtonItem *editButton;
@property (strong, nonatomic) UIBarButtonItem *joinButton;


@end

