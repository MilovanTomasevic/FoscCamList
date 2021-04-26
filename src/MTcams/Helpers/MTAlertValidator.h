//
//  MTAlertValidator.h
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTAlertValidator : NSObject

@property (nonatomic, assign) BOOL validateEmptyField;
@property (nonatomic, assign) BOOL validateCharacterLenght;
@property (nonatomic, assign) int characterLenght;

-(id)init;
-(id)initWithValidateEmptyAndLenght:(BOOL) validateEmptyField lenght:(BOOL)validateCharacterLenght andCharacterLenght:(int)characterLenght;

@end
