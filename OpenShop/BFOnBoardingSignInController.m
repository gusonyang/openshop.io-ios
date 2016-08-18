//
//  BFOnBoardingSignInController.m
//  OpenShop
//
//  Created by GusonYang on 16/8/17.
//  Copyright © 2016年 Business-Factory. All rights reserved.
//

#import "BFOnBoardingSignInController.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "BFOnboardingLoginEmailViewController.h"
#import "BFOnboardingRegistrationViewController.h"
#import "BFOnboardingViewController.h"
#import "User.h"
#import "UIWindow+BFOverlays.h"
#import "UIColor+BFColor.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

/**
 * Content height.
 */
static CGFloat const contentHeight = 260.0;
/**
 * Content view fade out animation duration.
 */
static CGFloat const contentViewFadeOutDuration = 0.5;
/**
 * Content view fade in animation duration.
 */
static CGFloat const contentViewFadeInDuration = 0.5;

@implementation BFOnBoardingSignInController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    self.contentHeight = contentHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)wechatClick:(id)sender {
    [self.delegate skipOnboarding:sender];
}

- (IBAction)signupClick:(id)sender {
    
}

- (IBAction)signinClick:(id)sender {
    BFOnboardingLoginEmailViewController *emailController = (BFOnboardingLoginEmailViewController *)[self BFN_mainStoryboardClassInstanceWithClass:[BFOnboardingLoginEmailViewController class]];
    // present form sheet
    [self presentLoginFormSheetFromController:emailController];
}

- (void)presentLoginFormSheetFromController:(BFFormSheetViewController *)controller {
    // present form sheet
    [controller presentFormSheetWithSize:CGSizeMake(self.view.frame.size.width, contentHeight) optionsHandler:^(MZFormSheetPresentationViewController *formSheetController) {
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
        // disable default MZFormSheet background color
        formSheetController.presentationController.backgroundColor = [UIColor clearColor];
        
        // custom presentation options with handlers
        __weak __typeof__(self) weakSelf = self;
        formSheetController.presentationController.dismissalTransitionWillBeginCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [weakSelf setContentViewHidden:NO animated:YES];
        };
        
        formSheetController.presentationController.dismissalTransitionDidEndCompletionHandler = ^(UIViewController *presentedFSViewController, BOOL completed) {
            if ([User isLoggedIn]) {
                [weakSelf.delegate finishOnboarding];
            }
        };
        formSheetController.presentationController.presentationTransitionWillBeginCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [weakSelf setContentViewHidden:YES animated:YES];
        };
        formSheetController.presentationController.frameConfigurationHandler = ^(UIView *presentedView, CGRect currentFrame, BOOL isKeyboardVisible) {
            if (isKeyboardVisible) {
                weakSelf.onboardingController.containerDimView.backgroundColor = [UIColor BFN_darkerDimColor];
                return CGRectMake(currentFrame.origin.x,
                                  weakSelf.onboardingController.view.frame.size.height - currentFrame.size.height - weakSelf.onboardingController.containerBottomConstraint.constant,
                                  currentFrame.size.width,
                                  currentFrame.size.height);
            }
            else {
                weakSelf.onboardingController.containerDimView.backgroundColor = [UIColor BFN_dimColor];
                return CGRectMake(currentFrame.origin.x,
                                  weakSelf.onboardingController.view.frame.size.height - currentFrame.size.height,
                                  currentFrame.size.width,
                                  currentFrame.size.height);
            }
        };
    } animated:YES fromSender:self];
}

#pragma mark - Form Sheet Presentation Helpers

- (void)setContentViewHidden:(BOOL)hidden animated:(BOOL)animated{
    if (animated) {
        // fade out
        if (hidden) {
            [UIView animateWithDuration:contentViewFadeOutDuration animations:^{
                [self setContentViewAlpha:0.0];
            } completion: ^(BOOL finished) {
                [self setContentViewHidden:finished];
            }];
        }
        // fade in
        else {
            [self setContentViewAlpha:0.0];
            [self setContentViewHidden:NO];
            [UIView animateWithDuration:contentViewFadeInDuration animations:^{
                [self setContentViewAlpha:1.0];
            }];
        }
    }
    else {
        [self setContentViewHidden:YES animated:NO];
    }
}

- (void)setContentViewAlpha:(CGFloat)alpha {
    self.wechatLoginButton.alpha = alpha;
    self.signinButton.alpha = alpha;
    self.signupButton.alpha = alpha;
    self.onboardingController.pageControlAlpha = alpha;
}

- (void)setContentViewHidden:(BOOL)hidden {
    self.wechatLoginButton.hidden = hidden;
    self.signinButton.hidden = hidden;
    self.signupButton.hidden = hidden;
    self.onboardingController.pageControlHidden = hidden;
}

@end
