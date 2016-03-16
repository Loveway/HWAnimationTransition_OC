//
//  HWNavigationDelegate.m
//  HWAnimationTransition_OC
//
//  Created by HenryCheng on 16/3/16.
//  Copyright © 2016年 www.igancao.com. All rights reserved.
//

#import "HWNavigationDelegate.h"
#import "HWTransitionAnimator.h"
#import "ViewController.h"

@interface HWNavigationDelegate ()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;

@end

@implementation HWNavigationDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {

    return (id)[HWTransitionAnimator new];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
   return self.interactionController;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIPanGestureRecognizer *panGeature = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panned:)];
    [self.navigationController.view addGestureRecognizer:panGeature];
}

- (void)panned:(UIPanGestureRecognizer *)panGesture {
    
    switch (panGesture.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc]init];
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.navigationController.topViewController performSegueWithIdentifier:@"PushSegue" sender:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            CGPoint transition = [panGesture translationInView:self.navigationController.view];
            CGFloat completionProgress = transition.x / CGRectGetWidth(self.navigationController.view.bounds);
            [self.interactionController updateInteractiveTransition:completionProgress];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            if ([panGesture velocityInView:self.navigationController.view].x > 0) {
                NSLog(@"----=====%f",[panGesture velocityInView:self.navigationController.view].x);
                [self.interactionController finishInteractiveTransition];
            } else {
                [self.interactionController cancelInteractiveTransition];
            }
            self.interactionController = nil;

            break;
        }
        default:
            [self.interactionController cancelInteractiveTransition];
            self.interactionController = nil;
            break;
    }
}

@end
