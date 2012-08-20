//
//  BookObject.h
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookObject : NSObject
{
    int ID;
    NSString *name;
    int price;
    int pieces;
    NSString *author;
    NSString *description;
}

@property(nonatomic)int ID;
@property(nonatomic,retain)NSString *name;
@property(nonatomic)int price;
@property(nonatomic)int pieces;
@property(nonatomic,retain)NSString *author;
@property(nonatomic,retain)NSString *description;

@end
