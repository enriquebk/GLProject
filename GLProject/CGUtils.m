//
//  CGUtils.m
//  GLProject
//
//  Created by Enrique Bermudez on 14/09/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGUtils.h"

@implementation CGUtils


+ (BOOL) isRetinaDisplay
{
	int scale = 1.0;
	UIScreen *screen = [UIScreen mainScreen];
	if([screen respondsToSelector:@selector(scale)])
        scale = screen.scale;
    
	if(scale == 2.0f) return YES;
	else return NO;
}

@end
