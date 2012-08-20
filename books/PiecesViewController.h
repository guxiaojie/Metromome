//
//  PiecesViewController.h
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseTableViewController.h"

@interface PiecesViewController : UseTableViewController
{
    int book_id;
    NSArray *arrPieces;
}
@property(nonatomic)int book_id;
@end
