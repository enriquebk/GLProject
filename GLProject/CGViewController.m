//
//  CGViewController.m
//  GLProject
//
//  Created by Enrique Bermudez on 20/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGViewController.h"
#import "CGView.h"

@interface CGViewController ()
@end

@implementation CGViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	CGView * cgview = [[CGView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:cgview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
