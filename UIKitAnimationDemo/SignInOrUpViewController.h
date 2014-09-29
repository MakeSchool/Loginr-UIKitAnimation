//
//  LoginViewController.h
//  UIKitAnimationDemo
//
//  Created by Daniel Haaser on 9/17/14.
//  Copyright (c) 2014 makeschool. All rights reserved.
//

#import "InitialViewController.h"

NS_ENUM(NSInteger, AccountState)
{
    kStateSignIn,
    kStateSignUp
};

@interface SignInOrUpViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) enum AccountState accountState;

@end
