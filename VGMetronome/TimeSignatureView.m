//
//  TimeSignatureView.m
//  Metronome
//
//  Created by starinno-005 on 12-7-3.               
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TimeSignatureView.h"

@implementation TimeSignatureView
@synthesize delegate;

- (void)timeSignatureAction:(id)sender{
    UIButton *btn=(UIButton *)sender;
    if ([self respondsToSelector:@selector(timeSignatureChanged:timeSignature:)]) {
        [delegate timeSignatureChanged:self timeSignature:btn.tag];
    }
    [self removeFromSuperview];
}

- (void)close{
    [self removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIButton *btnBG=[[UIButton alloc] initWithFrame:CGRectMake(0,0,320,370)];
        [btnBG addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBG];
        [btnBG release];
        
        for (int i=0; i<12; i++) {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(i%4*80, 370+i/4*35, 80, 35)];
            [btn setTitle:[NSString stringWithFormat:@"i:%d",i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(timeSignatureAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i;
            [self addSubview:btn];
            [btn setBackgroundColor:[UIColor blackColor]];
            [btn setTintColor:[UIColor whiteColor]];
            [btn release];
        }
        
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
}

@end
