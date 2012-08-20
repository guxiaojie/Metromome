//
//  JDItemView.m
//  JDAnimation
//
//  Created by SAMMY on 19/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JDItemView.h"
#import "JDImageView.h"

@implementation JDItemView


- (JDImageView *)createImageWithFrame:(CGRect)frame imageName:(NSString *)imageName delegate:(id)delegate action:(SEL)action{
    JDImageView *imgView=[[JDImageView alloc] initWithFrame:frame];
    imgView.imageName=imageName;
    [imgView setImage:[UIImage imageNamed:imageName]];
    imgView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:delegate action:action];
    [imgView addGestureRecognizer:tap];
    [tap release];
    
    return imgView;    
}

- (id)initWithDelegate:(id)delegate diction:(NSDictionary *)diction
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor blueColor];
        
        CGRect frame=[[diction valueForKey:@"frame"] CGRectValue];
        SEL selector=NSSelectorFromString([diction valueForKey:@"action"]);
        self.frame=frame;
        
        JDImageView *imgView=[self createImageWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) 
                                                  imageName:[diction valueForKey:@"imagename"]
                                               delegate:delegate
                                                 action:selector];
        CGRect targetFrame=[[diction valueForKey:@"targetFrame"] CGRectValue];
        imgView.targetFrame=targetFrame;
        
        [self addSubview:imgView];
        [imgView release]; 
    }
    return self;
}


@end
