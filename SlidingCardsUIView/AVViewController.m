//
//  AVViewController.m
//  SlidingCardsUIView
//
//  Created by Stenio Ferreira on 3/17/14.
//  Copyright (c) 2014 AvocadoRunner. All rights reserved.
//

#import "AVViewController.h"

@interface AVViewController () {
    
    SlidingCardsUIView *slidingCardsUIView;
}

@end

@implementation AVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	slidingCardsUIView = [[SlidingCardsUIView alloc] init];
    //you can either pass "nil" for an example, or an array of views you created programmatically
    [slidingCardsUIView showViewsFromArray:nil forViewController:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
