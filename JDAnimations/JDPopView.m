//
//  JDPopView.m
//  JDAnimation
//
//  Created by SAMMY on 19/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JDPopView.h"

@implementation JDPopView

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        UIImage *image=[UIImage imageNamed:imageName];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self addSubview:imageView];
        
        self.contentSize=image.size;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
