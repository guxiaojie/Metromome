//
//  NoteViewController.m
//  JDAnimation
//
//  Created by SAMMY on 19/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteViewController.h"
#import "JDImageView.h"
#import "JDItemView.h"
#import "JDPopView.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.userInteractionEnabled=YES; 
    
    NSValue *value=[NSValue valueWithCGRect:CGRectMake(10, 10, 100, 100)];
    NSValue *targetFrame=[NSValue valueWithCGRect:CGRectMake(5, 5, 200, 200)];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       value, @"frame", 
                       @"IMG_0457.JPG", @"imagename",
                       @"handleTap:",@"action", 
                       targetFrame,@"targetFrame",nil];
    
    JDItemView *img=[[JDItemView alloc] initWithDelegate:self diction:dic];
    [self.view addSubview:img];
//    [scrollView addSubview:img];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)handleTap:(UITapGestureRecognizer *)gesture{
    JDImageView *view=(JDImageView *)[gesture view];
    NSLog(@"---%s----view:%@",__func__,[view description]);
    
    JDPopView *popView=[[JDPopView alloc] initWithFrame:view.targetFrame imageName:view.imageName];
    [self.view addSubview:popView];
    [popView release];
}


@end
