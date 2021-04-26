//
//  ListCamsControlerViewController.h
//  MTcams
//
//  Created by administrator on 5/10/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CoreDataManager.h"


@interface ListCamsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *customTableView;


@end
