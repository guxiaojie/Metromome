//
//  DBParser.m
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DBParser.h"
#import "BookObject.h"
#import "PieceObject.h"

static FMDatabase *database = NULL;

FMDatabase *OpenDatabase(void){
    if (database == nil) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *document = [paths objectAtIndex:0];
        NSString *path = [document stringByAppendingPathComponent:SQLITEFILE];
        NSString *strFilePathName = path;
        
        BOOL success = [fileManager fileExistsAtPath:strFilePathName];
        if (!success) {
            [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:SQLITEFILE ofType:nil] toPath:strFilePathName error:nil];
        }

        database=[[FMDatabase alloc] initWithPath:strFilePathName];
        if (![database open]) {
        }
    }
    return database;
}

void CloseAllDatabase(void){
    [database dealloc];
}

NSMutableArray* GetBooks(void){
    OpenDatabase();
    FMResultSet *rs=[database executeQuery:@"select * from book"];
    NSMutableArray *arrReturn=[NSMutableArray array];
    while ([rs next]) {
        BookObject *obj=[[BookObject alloc] init];
        obj.ID=[rs intForColumnIndex:0];
        obj.name=[rs stringForColumnIndex:1];
        obj.price=[rs intForColumnIndex:2];
        obj.pieces=[rs intForColumnIndex:3];
        obj.author=[rs stringForColumnIndex:4];
        obj.description=[rs stringForColumnIndex:5];
        [arrReturn addObject:obj];
        [obj release];
    }
    NSLog(@"arrReturn:%@",arrReturn);
    return arrReturn;
}

NSMutableArray* GetPieces(int bookID){
    OpenDatabase();
    FMResultSet *rs=[database executeQuery:@"select * from piece where book_id = ?",[NSNumber numberWithInt:bookID]];
    NSMutableArray *arrReturn=[NSMutableArray array];
    while ([rs next]) {
        PieceObject *obj=[[PieceObject alloc] init];
        obj.ID=[rs intForColumnIndex:0];
        obj.bookID=[rs intForColumnIndex:1];
        obj.tempo=[rs intForColumnIndex:2];
        obj.timeSignature=[rs intForColumnIndex:3];
        obj.description=[rs stringForColumnIndex:4];
        [arrReturn addObject:obj];
        [obj release];
    }
    NSLog(@"arrReturn:%@",arrReturn);
    return arrReturn;
}

@implementation DBParser

@end
