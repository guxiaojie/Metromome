//
//  PiecesViewController.m
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PiecesViewController.h"
#import "DBParser.h"
#import "PieceObject.h"
#import "Global.h"

@interface PiecesViewController ()

@end

@implementation PiecesViewController
@synthesize book_id;

- (void)setBook_id:(int)bookID{
    if (arrPieces) {
        [arrPieces release];
        arrPieces=nil;
    }
    arrPieces=[[NSArray alloc] initWithArray:GetPieces(bookID)];
    [tableMain reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:item];
    [item release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrPieces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"PreferencesCellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    float height=cell.contentView.frame.size.height;
    PieceObject *obj=[arrPieces objectAtIndex:indexPath.row];
    UILabel *lbNumber=[Global createLable:CGRectMake(10, 0, 100, height) text:[NSString stringWithFormat:@"Number:%d",obj.ID] textColor:[UIColor blackColor] fontSize:12];
    [cell.contentView addSubview:lbNumber];
    [lbNumber release];
    
    UILabel *lbTempo=[Global createLable:CGRectMake(110, 0, 100, height) text:[NSString stringWithFormat:@"Tempo:%d",obj.tempo] textColor:[UIColor blackColor] fontSize:12];
    [cell.contentView addSubview:lbTempo];
    [lbTempo release];
    
    UILabel *lbTimeSig=[Global createLable:CGRectMake(220, 0, 100, height) text:[NSString stringWithFormat:@"TimeSignature:%d",obj.timeSignature] textColor:[UIColor blackColor] fontSize:12];
    [cell.contentView addSubview:lbTimeSig];
    [lbTimeSig release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
