//
//  LoginButton.h
//  UIKitAnimationDemo
//
//  Created by Daniel Haaser on 9/17/14.
//  Copyright (c) 2014 makeschool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ENUM(NSInteger, LoginButtonState)
{
    kStateInvalid,
    kStateValid
};

@interface LoginButton : UIView

@property (nonatomic, assign) enum LoginButtonState loginState;

// These should probably be private...
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;
@property (nonatomic, weak) IBOutlet UIImageView *lilSprite;

@end
