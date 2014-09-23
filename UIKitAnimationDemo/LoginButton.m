//
//  LoginButton.m
//  UIKitAnimationDemo
//
//  Created by Daniel Haaser on 9/17/14.
//  Copyright (c) 2014 makeschool. All rights reserved.
//

#import "LoginButton.h"

@implementation LoginButton


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setLoginState:(enum LoginButtonState)loginState
{
    if (_loginState != loginState)
    {
        _loginState = loginState;
        [self animateStateChangeToState:loginState];
    }
}
- (void)animateStateChangeToState:(enum LoginButtonState)loginState
{
    UIColor* targetColor;
    NSString* newLilSpriteImage;
    
    switch (loginState)
    {
        case kStateInvalid:
            targetColor = [UIColor colorWithRed:0.811764f green:0.0f blue:0.1098f alpha:1.0f];
            newLilSpriteImage = @"ios7-close-outline-white.png";
            break;
            
        case kStateValid:
            targetColor = [UIColor colorWithRed:0.0f green:0.811764f blue:0.1098f alpha:1.0f];
            newLilSpriteImage = @"ios7-checkmark-outline-white.png";
            break;
    }
    
    // Core Animation
    // Animate background
    CABasicAnimation* bgColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    bgColorAnimation.fromValue = (id) self.btnLogin.backgroundColor.CGColor;
    bgColorAnimation.toValue = (id) targetColor.CGColor;
    bgColorAnimation.duration = 0.5f;
    
    [self.btnLogin.layer addAnimation:bgColorAnimation forKey:@"bgColor"];
    self.btnLogin.layer.backgroundColor = targetColor.CGColor;
    
    // UIView Block Animations
    [UIView animateWithDuration:0.25f animations:^{
        self.lilSprite.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        
    } completion:^(BOOL finished) {
        self.lilSprite.image = [UIImage imageNamed:newLilSpriteImage];
        
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.lilSprite.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

@end
