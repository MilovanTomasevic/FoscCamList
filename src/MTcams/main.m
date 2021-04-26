//
//  main.m
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


#import "AppDelegate.h"
#import "FosCom.h"
#import "FosDef.h"
#import "FosNvrDef.h"
#import "fosnvrsdk.h"
#import "fossdk.h"

int main(int argc, char * argv[]) {
    
    int ret = 0;
    FosSdk_Init();
    
    @autoreleasepool {
        ret =  UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    
    FosSdk_DeInit();
    return ret;
}
