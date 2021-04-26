//
//  MTAlertValidator.m
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTAlertValidator.h"

@implementation MTAlertValidator

-(id)init{
    self = [super init];
    if (self) {
        self.validateEmptyField = NO;
        self.validateCharacterLenght = NO;
        self.characterLenght = 0;
    }
    return self;
}

-(id)initWithValidateEmptyAndLenght:(BOOL) validateEmptyField lenght:(BOOL)validateCharacterLenght andCharacterLenght:(int)characterLenght{
    self = [super init];
    if (self) {
        self.validateEmptyField = validateEmptyField;
        self.validateCharacterLenght = validateCharacterLenght;
        self.characterLenght = characterLenght;
    }
    return self;
}

@end
