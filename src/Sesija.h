//
//  Sesija.h
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, connType) {
    local,
    cloud
};

@interface Sesija : NSObject

@property(nonatomic,strong)NSString *sUID;
@property(nonatomic,strong)NSString *sIp;
@property(nonatomic,strong)NSString *sPort;
@property(nonatomic,strong)NSString *sUn;
@property(nonatomic,strong)NSString *sPass;
@property(nonatomic,assign)connType connectionType;



@end
