//
//  MTTextField.m
//  MTcams
//
//  Created by Milovan Tomasevic on 06/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTTextField.h"

@implementation MTTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark Init

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        /*
         Default Text Field appearance
         */
        self.frame = CGRectMake(self.origin.x, self.origin.y, self.size.width, self.size.height);
        //background
        self.backgroundColor = [UIColor whiteColor];
        //round edges around field
        self.layer.cornerRadius = kButtonDefCornerRadius;
        self.layer.masksToBounds = YES;
        //text
        //self.font = [THEME_MANAGER fontWithStyleName:OCFontStyleLight size:kFontSizeDefIPhone];
        self.textColor = [UIColor blackColor];
        //border style
        self.borderStyle = UITextBorderStyleNone;
        //Keyboard
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
        self.rightButton = nil;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self = [self initWithFrame:self.frame];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andStyle:(MTTextFieldStyle)style
{
    if (self = [self initWithFrame:frame]){
        if(style == OLTextFieldStyleLight) {
            //background color
            self.backgroundColor = [UIColor whiteColor];
            //border
            self.layer.borderColor = [UIColor orangeColor].CGColor;
            self.layer.borderWidth = kBorderDefWidth;
            self.borderStyle = UITextBorderStyleNone;
            //text color
            self.textColor = [UIColor blackColor];
        } else if(style == OLTextFieldStyleLightBlue){
            //background color
            self.backgroundColor = [UIColor whiteColor];
            //border
            self.layer.borderColor = [UIColor orangeColor].CGColor;
            self.layer.borderWidth = kBorderDefWidth/2;
            //left padding
            [self addLeftPadding];
        }
    }
    return self;
}

#pragma mark Overriden methods

-(void)setPlaceholder:(NSString *)placeholder
{
    if(placeholder == nil) {
        placeholder = @"";
    }
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [[UIColor grayColor] colorWithAlphaComponent:kAlphaComponent]}];
}

#pragma mark Public methods

-(void)addLeftImage:(UIImage *)image
{
    UIView *paddingView;
    UIView *behindImg;
    if(IS_IPHONE) {
        paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPaddingViewWidth, kPaddingViewHeightIPhone)];
        behindImg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kPaddingViewWidthIPhone, kPaddingViewHeightIPhone)];
    } else {
        paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPaddingViewWidth + kMarginDefault/2, kPaddingViewHeight)];
        behindImg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kPaddingViewWidth, kPaddingViewHeight)];
    }
    
    //[THEME_MANAGER setLoginBoxColorToView:behindImg];
    
    //round edges around field
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:behindImg.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(kButtonDefCornerRadius, kButtonDefCornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = behindImg.bounds;
    maskLayer.path  = maskPath.CGPath;
    behindImg.layer.mask = maskLayer;
    
    //image for field
    UIImageView *textFieldImage = [[UIImageView alloc]initWithFrame:CGRectMake(kMarginDefault/4, kMarginDefault/4, behindImg.frame.size.height - kMarginDefault/2, behindImg.frame.size.width - kMarginDefault/2)];
    
    //scale image
    textFieldImage.image = [MTSupport scaleImage:image toSize:CGSizeMake(kImageScaleConstant, kImageScaleConstant)];
    textFieldImage.backgroundColor = [UIColor clearColor];
    
    if(image != nil) {
        //setup image on the left of textfield
        [behindImg addSubview:textFieldImage];
        [paddingView addSubview:behindImg];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = paddingView;
    } else {
        self.layer.sublayerTransform = CATransform3DMakeTranslation(k3DTransform, 0, 0);
    }
}

-(void)addLeftPadding
{
    //padding
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMarginDefault/2, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)textFieldIsEnabled:(BOOL)enabled
{
    if(!enabled) {
       // self.backgroundColor = [THEME_MANAGER getBackgroundColor];
    }
    //self.layer.borderColor = [THEME_MANAGER getNeutralStrokeColor].CGColor;
    self.layer.borderWidth = kBorderDefWidth/2;
}


-(void)customizeField:(UITextField*)field withView:(UIView*)view andPlaceholder:(NSString*)placeholder{
    
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.font = [UIFont systemFontOfSize:15];
    field.placeholder = placeholder;
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.keyboardType = UIKeyboardTypeDefault;
    field.returnKeyType = UIReturnKeyDone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    /*
    if([field.text isEqualToString:@""]){
        field.backgroundColor = [UIColor whiteColor];
    }else{
        field.backgroundColor = [UIColor grayColor];
    }*/
    [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    field.delegate = self;
    [view addSubview:field];
}

-(void)textFieldDidChange:(UITextField *)theTextField{
    LogI( @"backgroundColor changed: %@", theTextField.text);
    
    if (theTextField.text.length < 1){
        theTextField.backgroundColor = [UIColor whiteColor];
    }
    else{
        theTextField.backgroundColor = [UIColor grayColor];
    }
}


/*
//custom dont used now
-(void)checkFieldBackground:(UITextField*)field{
    if([field.text isEqualToString:@""]){
        field.backgroundColor = [UIColor whiteColor];
    }else{
        field.backgroundColor = [UIColor grayColor];
    }
}
*/

-(void)addRightPasswordButton{
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    self.secureTextEntry = YES;
    
    UIButton *showTextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    showTextBtn.frame = CGRectMake(0, 0, kImageShowHidePassword, kImageShowHidePassword);
    [showTextBtn setImage:[UIImage imageNamed:@"password_icon"] forState:UIControlStateNormal];
    showTextBtn.titleLabel.textColor = [UIColor blackColor];
    
    [showTextBtn addTarget:self action:@selector(showHidePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:showTextBtn];
}

- (IBAction)showHidePassword:(id)sender {
    self.secureTextEntry = !self.secureTextEntry;
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:(@"password_icon")] forState:UIControlStateNormal];;
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:(@"unlock")] forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)addLeftIcon:(UITextField*)field withImage:(NSString *)imageName{
    
    UIView *vwContainer = [[UIView alloc] init];
    [vwContainer setFrame:CGRectMake(0.0f, 0.0f, 40, 40.0f)];
    [vwContainer setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:[UIImage imageNamed:imageName]];
    [icon setFrame:CGRectMake(0.0f, 0.0f, 40.0f,40.0f)];
    [icon setBackgroundColor:[UIColor lightGrayColor]];
    
    [vwContainer addSubview:icon];
    
    [field setLeftView:vwContainer];
    [field setLeftViewMode:UITextFieldViewModeAlways];
}

/*
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor whiteColor];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor grayColor];
    if([textField.text isEqualToString:@""]){
        textField.backgroundColor = [UIColor whiteColor];
    }
}
*/

@end
