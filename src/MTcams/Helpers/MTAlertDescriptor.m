//
//  MTAlertDescriptor.m
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTAlertDescriptor.h"

@implementation MTAlertDescriptor{
    NSMutableArray <UIAlertAction*> *otherbuttonActions;
}

-(id)init{
    self = [super init];
    if (self) {
        self.alertValidator = nil;
        self.priority = MTAlertPriorityLow;
        otherbuttonActions = [[NSMutableArray alloc] init];
    }
    return self;
}


- (UIAlertController *)alertControllerWithCompletion:(void (^)())handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.title
                                                                             message:self.message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakController = alertController;
    __weak MTAlertDescriptor *weakSelf = self;

    MTAlertActionHandler (^actionHandler)(NSInteger) = ^MTAlertActionHandler(NSInteger buttonIndex) {
        return ^(UIAlertAction *action) {
            if (weakSelf.tapBlock) {
                weakSelf.tapBlock(weakController, action, buttonIndex);
            }
            handler();
        };
    };

    if (self.cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:self.cancelTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:actionHandler(MTAlertBlocksCancelButtonIndex)];
        [alertController addAction:cancelAction];
    }

    if (self.destructiveTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:self.destructiveTitle
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:actionHandler(MTAlertBlocksDestructiveButtonIndex)];

        [otherbuttonActions addObject:destructiveAction];
        [alertController addAction:destructiveAction];
    }

    for (NSUInteger i = 0; i < self.otherTitles.count; i++) {
        NSString *buttonTitle = self.otherTitles[i];

        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:actionHandler(MTAlertBlocksFirstOtherButtonIndex + i)];
        if (self.alertValidator.validateEmptyField) {
            [alertAction setEnabled:NO];
            [otherbuttonActions addObject:alertAction];
        }
        [alertController addAction:alertAction];
    }

    if (self.textFieldConfig) {
        [alertController addTextFieldWithConfigurationHandler:self.textFieldConfig];
        [[alertController.textFields firstObject] addTarget:self action:@selector(alertControllerTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    if(self.alertValidator.validateEmptyField || self.alertValidator.validateCharacterLenght){
        for(UIAlertAction *action in otherbuttonActions){
            [action setEnabled:NO];
        }
    }

    return alertController;
}

- (NSString *)description
{
    NSString *priorityStr = @[@"Unknown", @"Low", @"Normal", @"High"][self.priority];
    return [NSString stringWithFormat:@"%@-alert title: %@ \n msg: %@", priorityStr, self.title, self.message];
}

- (void)alertControllerTextFieldDidChange:(UITextField *)sender {
    if (self.alertValidator.validateCharacterLenght){
        if (sender.text.length > self.alertValidator.characterLenght){
            NSRange stringRange = NSMakeRange(0,self.alertValidator.characterLenght);
            stringRange = [sender.text rangeOfComposedCharacterSequencesForRange:stringRange];
            NSString *shortString = [sender.text substringWithRange:stringRange];
            sender.text = shortString;
        }
    }
    if([sender.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]].length < 1){
        sender.text = [sender.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        for(UIAlertAction *action in otherbuttonActions){
            [action setEnabled:NO];
        }
    }
    else{
        sender.text = [MTSupport replaceMultipliedSpacesWithOneFromString:sender.text];
        for(UIAlertAction *action in otherbuttonActions){
            [action setEnabled:YES];
        }
    }
}

@end
