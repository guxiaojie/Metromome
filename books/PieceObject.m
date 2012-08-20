//
//  PieceObject.m
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PieceObject.h"

@implementation PieceObject
@synthesize ID;
@synthesize bookID;
@synthesize tempo;
@synthesize timeSignature;
@synthesize description;

-(void)dealloc{
    if (description) {
        [description release];
    }
    [super dealloc];
}

@end
