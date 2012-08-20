//
//  JDImageVIew.m
//  JDAnimation
//
//  Created by SAMMY on 19/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JDImageView.h"

@implementation JDImageView
@synthesize imageName;
@synthesize targetFrame;
@synthesize animationID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [imageName release];
    [super dealloc];
}

@end
