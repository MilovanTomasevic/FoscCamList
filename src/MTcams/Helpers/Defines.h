//
//  Defines.h
//  MTcams
//
//  Created by Milovan Tomasevic on 06/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

//get signleton instance
#define APP_SETTINGS [Settings sharedInstance]
#define ALERT_PRESENTER [MTAlertPresenter sharedPresenter]
#define THEME_MANAGER [MTThemeManager sharedInstance].theme


// Universal date time constants
static const int kMinutesInHour = 60;
static const int kSecondsInMinute = 60;
static const int kMilisecondsInSecond = 1000;
static const long kSecondsInDay = 86400;

// Network close dialog constants
static const NSString* kZeroTimeString = @"0:00";
static const NSTimeInterval kTimeoutIntervalForNetworkClose = 5.0;//seconds

/*  Images & icons  */
static const float kDeviceBgdImgDefAlpha = 0.15f;
static const int kDeviceTypeIconWidth = 64;
static const int kDeviceTypeIconHeight = 64;
static const int kDeviceCellBgdImgWidth = 150;
static const int kDeviceCellBgdImgHeight = 150;
static const int kBatteryImgWidth = 27;
static const int kBatteryImgHeight = 17;
static const int kImageShowHidePassword = 30;

// this const are used in controlls with 4+ cells
static const int kSmallControllIconWidth = kDeviceTypeIconWidth*3/4;
static const int kSmallControllIconHeight = kDeviceTypeIconHeight*3/4;
// Global margin defaults [points]
static const int kMarginDefault = 20;


/*  BATTERY LEVELS for battery indicatior image  */
static const int kBatteryLevelFull = 80;
static const int kBatteryLevelMedium = 60;
static const int kBatteryLevelLow = 30;

/*  UI elements contants                         */
static const int kUICellDefHeight = 45;
static const int kUISwitchDefWidth = 40;
static const int kUISwitchDefHeight = 40;
static const int kUISliderDefHeight = 20;
// default with of image + margin inside button (arrow_back)
static const int kUIButtonDefHeight = 20;
static const int kUIButtonDialogDefHeight = 36;
static const int kUIButtonNavBarDefHeight = 32;
static const int kUIButtonVolumeHeight = 40;
static const int kUIButtonPlaybackHeight = 50;
static const int kUIButtonUnosrtedIPhoneHeight = 44;
static const int kUIButtonArrowImgWidth = 20;
static const NSInteger kImageScaleConstant = 50;
// labels
static const int kUILabelDefHeight = 40;
static const int kUILabelWoltageDefWidth = 100;
static const int kUILabelValueQuickControlDefWidth = 110;

//device header view
static const int kDeviceHeaderServiceWidth = 80;


// This 2 const shold be removed when home_icon img size is standardized
static const int kImgHomeIconWidth = 93;
static const int kImgHomeIconHeight = 81;

static const int kPopOverDefHeight = 300;
static const int kNavigationBarDefHeight = 44;

static const float kSliderSendCommandDefInterval = 0.5f;

static const float kButtonDefCornerRadius = 7.0f;
static const float kBorderDefWidth = 1.0f;

static const CGFloat kDefaultAnimationDurationInterval = 0.3;
static const CFTimeInterval kMinimumPressDuration = 0.5;

static const int kDefaultKeybordMovedUIDistanceIPhone = 140;
static const int kDefaultKeybordMovedUIDistanceIPad = 280;

static const int kDefaultLineDeviderThickness = 1;

static const int kPaddingViewWidth = 48;
static const int kPaddingViewHeight = 48;

static const int kPaddingViewWidthIPhone = 42;
static const int kPaddingViewHeightIPhone = 42;

static const int kUIImageViewWidth = 32;
static const int kUIImageViewHeight = 32;

static const CGFloat kAlphaComponent = 0.5;
static const CGFloat kShadowViewAlpha = 0.3f;

static const int kMovedUpPositionIPad_NewAccount = 350;
static const int kMovedUpPositionIPad = 600;
static const int kMovedUpPositionIPhone = 70;

static const int cellHeightForEditingiPad = 140;

static const int kDatePickerHeightIPhone = 200;
static const int kDatePickerHeightIPad = 220;
static const int kDatePickerWidthIPad = 300;

static const float kStartColorGradEditWiz = 0.1;
static const float kEndColorGradEditWiz = 0.1;

static const int kSceneCellWidthIpad = 320;
static const int kSceneCellHeightIpad = 220;

static const float kDefHeightForRow = 50.0;

static const float kHomeSetupRoomCellWidth = 220.0;
static const float kHomeSetupRoomCellHeight = 150.0;

static const int kHomeSetupWizardGridWidth = 1000;
static const int kHomeSetupWizardGridHeight = 600;

static const NSTimeInterval kTimerWithTimeInterval = 1.0;

static const int kLabelDescriptionHeight = 270;
static const int kLabelDescriptionWidht = 460;

static const int kDeviceImageSize = 100;

static const float kLocationTableCellHeightiPhone = 44.0;
static const float kLocationTableCellHeightiPad = 40.0;

static const int kBackgroundOfGWWidth = 255;
static const int kBackgroundOfGWHeight = 150;

static const NSTimeInterval kHideProgresAfterDelay = 5;
static const NSTimeInterval kWaitForCamera = 5;

static const int kMinNumOfItemsToScrollMenu = 10;
static const int kMaxNumOfItemsToShowAllInMenu = 3;

static const int kMaxNumberOfTypesOnScreen = 13;

static const float kGWListItemWidth = 280;
static const float kGWListItemHeight = 150;

static const float kSyncIconRotationSpeed = 1.1;

static const CGFloat kDefRearViewRevealDisplacement = 40;
static const CGFloat kDefRearViewRevealOverdraw = 60;

static const int kLastTabBarItemIndex = 3;
// App navigation stack must be: ->SplashController->MainMenuController->..
static const int kMainMenuControllerIndex = 1;

static const int kDiffDrawerWidth = 60;

static const float kScrollContentSizeCellHeight = 224;
static const CGFloat kMarqueeScrollDuration = 7.0;
static const float kLabelMarqueeSpeed = 1.0;

static const CGFloat kMaxWidthiPhone6S = 5461.0;

static const CGFloat kGradMaskStartPointY = 0.5;
static const CGFloat kGradMaskEndPointx = 1.0;
static const CGFloat kGradMaskEndPointY = 0.5;

//Scenes
static const CGFloat kGradScenesEndPointx = 1.0;
static const CGFloat kGradScenesEndPointy = 1.0;

static const NSInteger kNumberOfSections = 1;

static const CGFloat kArrowImageAlpha = 0.9;
static const CGFloat kLabelNumOfUnsortDevWidth = 50;
static const CGFloat kLabelNumOfUnsortDevWidthiPad = 80;
static const CGFloat kArrowImageHeight = 23;
static const CGFloat kLeftMarginUnsortedDevicesView = -1;

static const CGFloat kSceneCellHeigtiPhone = 42;
static const CGFloat kSceneSelectedCellHeightiPhone = 260;

static const CGFloat kRectImageWithColorSize = 1.0;

static const CGFloat kSceneSliderWidth = 177;
static const CGFloat kSceneSliderValueLabelWidth = 50;
static const CGFloat kDevTrigTextFieldHeight = 36;

static const CGFloat kBlueArrowHeight = 6;
static const CGFloat kBlueArrowWidth = 14;
static const CGFloat kBlueArrowYPosition = 17;
static const CGFloat kBlueArrowXPosition = 157;

static const NSInteger kDeleteSceneOkButton = 1;
static const NSInteger kRunSceneYesButton = 1;

static const int kLocationTable = 1;
static const int kTypeTable = 0;

static const int kStatusTitleHeight = 50;

static const int kTabBarItemNumber = 3;

static const int kSideMenuClosedWidth = 50;
static const float kCorrectionHeightDiffiPad = 100;
static const float kCorrectionHeightDiffiPhone = 80;
//
static const NSInteger kSetupLabelSubtextFieldTag = 700;
static const int kFloorButtonInsets = 12;
static const int k3DTransform = 5;
static const float kTableRowHeight = 30.0;

static const CGFloat kRightInsentBackArrow = 50;

static const NSInteger kHomeSetupBottomHelpHeight = 140;

//Push Notifications
static const NSInteger kTitleCellHeightiPhone = 44;
static const NSInteger kTitleCellHeightiPad = 60;

//slider max value
static const int kSliderMaxValue = 99.0;
static const int kDefaultSliderStep = 1.0;

//light tempreture service
static const int kLightTempSliderMin = 2700;
static const int kLightTempSliderMax = 6500;


static const int kPropTypeText = 0;
static const int kPropTypeNumber = 1;
static const int kPropTypeBool = 2;
static const int kPropTypeRange = 3;
static const int kPropTypeOption = 4;
static const int kPropTypeColor = 7;

static const int kPropMinValueIndex = 0;
static const int kPropMaxValueIndex = 1;
static const int kPropStepIndex = 2;


//Color constants
static const CGFloat kAlternativeColorAlpha = 0.4f;

//Characters length limitation
static const int kPinCodeLength = 4;
static const int kNamesMaxLength = 30;

//ssid
static NSString* const kSSIDString = @"SSID";

#endif /* Defines_h */
