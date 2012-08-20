//
//  BooksViewController.m
//  Metronome
//
//  Created by starinno-005 on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BooksViewController.h"
#import "DBParser.h"
#import "Global.h"
#import "BookObject.h"
#import "PiecesViewController.h"

@interface BooksViewController ()

@end

@implementation BooksViewController

- (void)back{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:item];
    [item release];
    
    arrBooks=[[NSArray alloc] initWithArray:GetBooks()];
    [tableMain reloadData];
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
    return [arrBooks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"PreferencesCellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    BookObject *obj=[arrBooks objectAtIndex:indexPath.row];
    
    UIImageView *imgBook=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",obj.name]]];
    [imgBook setFrame:CGRectMake(0, 0, 60, 60)];
    [cell.contentView addSubview:imgBook];
    [imgBook release];
    
    UILabel *lb=[Global createLable:CGRectMake(65, 0, 150, 30) text:obj.name textColor:[UIColor blackColor] fontSize:12];
    [cell.contentView addSubview:lb];
    [lb release];
    
    UILabel *lbAuthor=[Global createLable:CGRectMake(65, 30, 150, 30) text:obj.author textColor:[UIColor blackColor] fontSize:12];
    [cell.contentView addSubview:lbAuthor];
    [lbAuthor release];
    
    UILabel *lbTotal=[Global createLable:CGRectMake(65+150, 30, 100, 30) text:[NSString stringWithFormat:@"%d/Pieces",obj.pieces] textColor:[UIColor blackColor] fontSize:12];
    [cell.contentView addSubview:lbTotal];
    [lbTotal release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PiecesViewController *pieceVC=[[PiecesViewController alloc] init];
    BookObject *obj=[arrBooks objectAtIndex:indexPath.row];
    pieceVC.book_id=obj.ID;
    [self.navigationController pushViewController:pieceVC animated:YES];
    [pieceVC release];
}

@end
