//
//  BookObject.m
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookObject.h"

@implementation BookObject
@synthesize ID;
@synthesize name;
@synthesize price;
@synthesize pieces;
@synthesize author;
@synthesize description;

-(void)dealloc{
    if (name) {
        [name release];
    }
    if (author) {
        [author release];
    }
    if (description) {
        [description release];
    }
    [super dealloc];
}

@end
