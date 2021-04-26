//
//  BasePageViewController.m
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "BasePageViewController.h"



@interface BasePageViewController ()

@end

@implementation BasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadPageControl];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[self loadPageControl];
}


-(void) loadPageControl{

    int pagesCount = 3;
   
    _pControl = [[UIPageControl alloc]init];
    [_pControl setPageIndicatorTintColor:[UIColor whiteColor]];
    [_pControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [_pControl setBackgroundColor:[UIColor clearColor]];
    [_pControl setNumberOfPages:pagesCount];
    [_pControl setCurrentPage:0];
    
    //  bottom position
    //[_pControl setFrame:CGRectMake(0, self.view.frame.size.height - 55, self.view.frame.size.width, 55)];
    
    // top position
    [_pControl setFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
    [_pControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
     /*
    self.pControl = [[ZJPageControl alloc] initWithFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
    _pControl.numberOfPages = pagesCount;
    _pControl.padding = 15;
    _pControl.radius = 5;
    _pControl.lineWidth = 2;
    _pControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    //[pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // set current page
    //_pControl.currentPage = 2;
    
    // set current page with animation
    //[pageControl setCurrentPage:2 animated:YES];
     */
    [self.view addSubview:_pControl];
}



-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            [_pControl setFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
            break;
        }
            
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            [_pControl setFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
            break;
        }
        default: {
            break;
        }
    }
}


@end
