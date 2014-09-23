//
//  ViewController.m
//  UIKitAnimationDemo
//
//  Created by Daniel Haaser on 9/16/14.
//  Copyright (c) 2014 makeschool. All rights reserved.
//

#import "InitialViewController.h"
#import "SignInOrUpViewController.h"

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateAccount;

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self doSomeFancyBlockBasedAnimations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SignInOrUpViewController* signInOrSignUpViewController =  segue.destinationViewController;
    
    if (sender == self.btnSignIn)
    {
        signInOrSignUpViewController.accountState = kStateSignIn;
    }
    else if (sender == self.btnCreateAccount)
    {
        signInOrSignUpViewController.accountState = kStateSignUp;
    }
}

- (void)doSomeFancyBlockBasedAnimations {
    
    // We're going to move the title and the two buttons off the screen and animate them in
    // We're also going to do an alpha fade for good measure
    
    // Save the original positions of the elements
    CGRect originalTitleFrame = self.lblTitle.frame;
    CGRect originalSignInFrame = self.btnSignIn.frame;
    CGRect originalCreateAccountFrame = self.btnCreateAccount.frame;
    
    // Create the offscreen positions based on their original positions
    CGRect offscreenTitleFrame = CGRectMake(originalTitleFrame.origin.x,
                                            originalTitleFrame.origin.y - self.view.frame.size.height / 2.0f,
                                            originalTitleFrame.size.width,
                                            originalTitleFrame.size.height);
    
    CGRect offscreenSignInFrame = CGRectMake(originalSignInFrame.origin.x + self.view.frame.size.width,
                                             originalSignInFrame.origin.y,
                                             originalSignInFrame.size.width,
                                             originalSignInFrame.size.height);
    
    CGRect offscreenCreateAccountFrame = CGRectMake(originalCreateAccountFrame.origin.x - self.view.frame.size.width,
                                                    originalCreateAccountFrame.origin.y,
                                                    originalCreateAccountFrame.size.width,
                                                    originalCreateAccountFrame.size.height);
    
    // Set the UI elements to their pre-animation state
    self.lblTitle.alpha = 0.0f;
    self.btnSignIn.alpha = 0.0f;
    self.btnCreateAccount.alpha = 0.0f;
    
    self.lblTitle.frame = offscreenTitleFrame;
    self.btnSignIn.frame = offscreenSignInFrame;
    self.btnCreateAccount.frame = offscreenCreateAccountFrame;
    
    [UIView animateWithDuration:1.0f delay:0.0f usingSpringWithDamping:0.75f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.lblTitle.alpha = 1.0f;
        self.btnSignIn.alpha = 1.0f;
        self.btnCreateAccount.alpha = 1.0f;
        
        self.lblTitle.frame = originalTitleFrame;
        self.btnSignIn.frame = originalSignInFrame;
        self.btnCreateAccount.frame = originalCreateAccountFrame;
    } completion:^(BOOL finished) {
        NSLog(@"Fancy animation complete!");
    }];
}

@end
