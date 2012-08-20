//
//  DBParser.h
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBParser.h"
#define SQLITEFILE @"metronome.sqlite"

FMDatabase *OpenDatabase(void);
void CloseAllDatabase(void);

NSMutableArray* GetBooks(void);
NSMutableArray* GetPieces(int bookID);

@interface DBParser : NSObject

@end
