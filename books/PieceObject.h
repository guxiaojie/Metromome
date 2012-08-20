//
//  PieceObject.h
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PieceObject : NSObject
{
    int ID;
    int bookID;
    int tempo;
    int timeSignature;
    NSString *description;
}

@property(nonatomic)int ID;
@property(nonatomic)int bookID;
@property(nonatomic)int tempo;
@property(nonatomic)int timeSignature;
@property(nonatomic,retain)NSString *description;

@end
