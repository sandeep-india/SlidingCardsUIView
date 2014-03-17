//
//  AVViewController.m
//  SlidingCardUIView
//
//  Created by Stenio Ferreira on 3/14/14.
//  Copyright (c) 2014 AvocadoRunner. All rights reserved.
//

#import "SlidingCardsUIView.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface SlidingCardsUIView (){
	CGFloat firstX;
	CGFloat firstY;
    
    //if user drags view below this threshold, it will disapear
    int disapearingYThreshold;
    CGFloat rotatingAngle;
    bool rotatingAngleClockwise;
    
    UIViewController *viewController;
    NSArray *arrayOfViews;
    int _visibleViewFromArray;
    
    //can only be associated with one view at a time
    UIPanGestureRecognizer *panRecognizer;
    
}


@end

@implementation SlidingCardsUIView

- (void)showViewsFromArray:(NSArray *)views forViewController:(UIViewController *)controller {

	panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionMove:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	//[panRecognizer setDelegate:self];
    
    viewController = controller;
    
    disapearingYThreshold = 300;
    
    if (!views){
        [self initializeDefaultValuesForViews];
    } else {
        arrayOfViews = views;
    }
    
    if (arrayOfViews.count > 0){
        UIView *_tempView = (UIView *)[arrayOfViews objectAtIndex:0];
        firstX = _tempView.bounds.origin.x;
        firstY = _tempView.bounds.origin.y;
        
        [_tempView addGestureRecognizer:panRecognizer];
        [viewController.view addSubview:_tempView];
    }else {
        NSLog(@"Error on SlidingCardsUIView.showViewsFromArray -> please use either nil or an array with at least one UIView.");
    }
    
}

-(void)initializeDefaultValuesForViews {
    CGRect _defaultFrame = CGRectMake(20, 90, 280, 170);
    UIView *_viewOne = [[UIView alloc]initWithFrame:_defaultFrame];
    [_viewOne setBackgroundColor:[UIColor greenColor]];
    [_viewOne.layer setCornerRadius:5];
    [_viewOne.layer setMasksToBounds:YES];
    
    UIView *_viewTwo = [[UIView alloc]initWithFrame:_defaultFrame];
    [_viewTwo setBackgroundColor:[UIColor redColor]];
    [_viewTwo.layer setCornerRadius:5];
    [_viewTwo.layer setMasksToBounds:YES];
    
    UIView *_viewThree = [[UIView alloc]initWithFrame:_defaultFrame];
    [_viewThree setBackgroundColor:[UIColor blueColor]];
    [_viewThree.layer setCornerRadius:5];
    [_viewThree.layer setMasksToBounds:YES];
    
    arrayOfViews = @[_viewOne, _viewTwo, _viewThree];
    _visibleViewFromArray = 0;
}

-(void) actionMove:(id)sender{
    [viewController.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    UIView * _touchedView = [(UIPanGestureRecognizer*)sender view];
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:viewController.view];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        rotatingAngle = 0;
        CGPoint _touchedPoint = [(UIPanGestureRecognizer*)sender locationInView:viewController.view];
        if (_touchedPoint.x > _touchedView.center.x) {
            rotatingAngleClockwise = YES;
        } else {
            rotatingAngleClockwise = NO;
        }
        
	}
    
    if (rotatingAngle < 25)  { //selected just for the look, can be any value depending on how much you want the view to rotate.
        if (rotatingAngleClockwise) {
            rotatingAngle = rotatingAngle + 0.1;
        } else {
            rotatingAngle = rotatingAngle - 0.1 ;
        }
    }
    
    CGAffineTransform transformRotate = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(rotatingAngle));
    //here I use "0" for x because I don't want to move from x position, so no need to add anything.
    CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(0, translatedPoint.y);
    
    if (translatedPoint.y > 0) { //if drag going down
        [[(UIPanGestureRecognizer*)sender view] setTransform:CGAffineTransformConcat(transformTranslate, transformRotate)];
    }else { //if drag going up
        [[(UIPanGestureRecognizer*)sender view] setTransform:transformTranslate];
    }
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        CGFloat finalY = translatedPoint.y;
    
        if (finalY < disapearingYThreshold) {
            [UIView animateWithDuration:0.35
                                  delay:0.05
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [[(UIPanGestureRecognizer*)sender view] setTransform:CGAffineTransformIdentity];
                             }
                             completion:^(BOOL finished){
                             }];
        }else {
            [UIView animateWithDuration:0.35
                                  delay:0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 //the commented below does not work. Possible solution either animate a curve, move center or capture screen as mentioned on http://stackoverflow.com/questions/5995923/cgaffinetransform-reset
                               //  CGAffineTransform transformTranslate2 = CGAffineTransformTranslate(transformRotate, 0, 1025);
                                 //[_touchedView setTransform:transformTranslate2];
                                 _touchedView.alpha = 0;
                             }
                             completion:^(BOOL finished){
                                 [_touchedView removeFromSuperview];
                                 _touchedView.alpha = 1;
                                 [_touchedView setTransform:CGAffineTransformIdentity];
                                 if(_visibleViewFromArray < arrayOfViews.count-1) {
                                     _visibleViewFromArray++;
                                 } else {
                                     _visibleViewFromArray = 0;
                                 }
                                 UIView *tempView = [arrayOfViews objectAtIndex:_visibleViewFromArray];
                                 [tempView addGestureRecognizer:panRecognizer];
                                 
                                 CGFloat _originX = tempView.frame.origin.x;
                                 CGFloat _originY = tempView.frame.origin.y;
                                 CGFloat _width = CGRectGetWidth(tempView.frame);
                                 CGFloat _height = CGRectGetHeight(tempView.frame);
                                 
                                 tempView.frame = CGRectMake(tempView.center.x, tempView.center.y, 0, 0);
                                 [viewController.view addSubview:tempView];
                                 
                                 [UIView animateWithDuration:0.35
                                                       delay:0
                                                     options: UIViewAnimationOptionCurveEaseOut
                                                  animations:^{
                                                     tempView.frame = CGRectMake(_originX, _originY, _width, _height);
                                                  }
                                                  completion:^(BOOL finished){
                                                  }];
                             }];

        }
    
    }
}


@end
