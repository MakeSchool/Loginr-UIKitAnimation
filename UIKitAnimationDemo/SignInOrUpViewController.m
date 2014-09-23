//
//  LoginViewController.m
//  UIKitAnimationDemo
//
//  Created by Daniel Haaser on 9/17/14.
//  Copyright (c) 2014 makeschool. All rights reserved.
//

#import "SignInOrUpViewController.h"
#import "LoginButton.h"

@interface SignInOrUpViewController ()
{
    UIView* activeField;
}

// Linked from storyboard
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet LoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

// UIKit Dynamics
@property (strong, nonatomic) UIDynamicAnimator* dynamicAnimator;

@end

@implementation SignInOrUpViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerForKeyboardNotifications];
    
    switch (self.accountState)
    {
        case kStateSignIn:
            [self.loginButton.btnLogin setTitle:@"Log In" forState:UIControlStateNormal];
            self.imgBackground.image = [UIImage imageNamed:@"bg2.jpg"];
            break;
            
        case kStateSignUp:
            [self.loginButton.btnLogin setTitle:@"Create Account" forState:UIControlStateNormal];
            self.imgBackground.image = [UIImage imageNamed:@"bg3.jpg"];
            break;
    }
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Log In Button
- (IBAction)signInOrSignUpPressed:(id)sender
{
    // UIKit Dynamics
    // This is a bit much, but it's for demonstration!
    switch (self.loginButton.loginState)
    {
        case kStateValid:
        {
            // Make the UI fall off the screen
            
            NSArray* dynamicsItems = @[self.txtUsername, self.txtPassword, self.loginButton];
            
            UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:dynamicsItems];
            
            UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:dynamicsItems];
            collisionBehavior.translatesReferenceBoundsIntoBoundary = NO;
            
            UIDynamicItemBehavior* angularVelocity = [[UIDynamicItemBehavior alloc] initWithItems:dynamicsItems];
            [angularVelocity addAngularVelocity:-M_PI forItem:self.txtUsername];
            [angularVelocity addAngularVelocity:M_PI forItem:self.txtPassword];
            [angularVelocity addAngularVelocity:M_PI_2 forItem:self.loginButton];
            
            [self.dynamicAnimator addBehavior:gravityBehavior];
            [self.dynamicAnimator addBehavior:angularVelocity];
            [self.dynamicAnimator addBehavior:collisionBehavior];
        }
            break;
            
        case kStateInvalid:
        {
            // Shake the login button
            
            UIPushBehavior* pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.loginButton] mode:UIPushBehaviorModeInstantaneous];
            pushBehavior.pushDirection = CGVectorMake(25.0f, 0.0f);
            pushBehavior.active = YES;
            
            UIDynamicItemBehavior* elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.loginButton]];
            elasticityBehavior.elasticity = 0.35f;
            
            UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.loginButton]];
            collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
            
            UISnapBehavior* snapBehavior = [[UISnapBehavior alloc] initWithItem:self.loginButton snapToPoint:self.loginButton.center];
            snapBehavior.damping = 0.1f;
            
            [self.dynamicAnimator addBehavior:pushBehavior];
            [self.dynamicAnimator addBehavior:elasticityBehavior];
            [self.dynamicAnimator addBehavior:collisionBehavior];
            [self.dynamicAnimator addBehavior:snapBehavior];
        }
            break;
    }
}

#pragma mark -
#pragma mark - Tap Gesture Recognizer

- (IBAction)tapDetected:(id)sender
{
    [activeField resignFirstResponder];
}

#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self checkLoginState];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.loginButton.loginState = kStateInvalid;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

#pragma mark -
#pragma mark Login Button State

- (void)checkLoginState
{
    if ([self usernameIsValid:self.txtUsername.text] && [self passwordIsValid:self.txtPassword.text])
    {
        self.loginButton.loginState = kStateValid;
    }
    else
    {
        self.loginButton.loginState = kStateInvalid;
    }
}

- (BOOL)passwordIsValid:(NSString*)password
{
    return password.length >= 5;
}

- (BOOL)usernameIsValid:(NSString*)username
{
    return username.length >= 1;
}

#pragma mark -
#pragma mark Keyboard Stuff

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Move text fields to accomodate the keyboard covering them up

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect bkgndRect = activeField.superview.frame;
    
    if (activeField.frame.origin.y + activeField.frame.size.height > bkgndRect.size.height - kbSize.height)
    {
        bkgndRect.size.height += kbSize.height;
        [self.scrollView setFrame:bkgndRect];
        [self.scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y + activeField.frame.size.height - kbSize.height) animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
