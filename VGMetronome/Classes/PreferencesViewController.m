 
#import "PreferencesViewController.h"
#import "MetronomeViewController.h"
#import "MetronomeAppDelegate.h"

@implementation PreferencesViewController


@synthesize delegate;


#pragma mark -
#pragma mark === Action method ===
#pragma mark -

- (IBAction)done {
	[self.delegate preferencesViewControllerDidFinish:self];	
}


#pragma mark -
#pragma mark === View configuration ===
#pragma mark -

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
	
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		self.wantsFullScreenLayout = YES;
	}
	return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark === TableView datasource and delegate methods ===
#pragma mark -

/*
 Provide cells for the table, with each showing one of the available time signatures.
 */

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	MetronomeAppDelegate *appDelegate = (MetronomeAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.timeSignatures count];
}


- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifier = @"PreferencesCellIdentifier";
	
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
	
	MetronomeAppDelegate *appDelegate = (MetronomeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    cell.textLabel.text = [appDelegate.timeSignatures objectAtIndex:indexPath.row];
	if (([appDelegate timeSignature] - 2) == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // This table has only one section.
    return NSLocalizedString(@"Time Signature", @"Title for table that display time signatures");
}



- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {

	// When a new selection is made, display a check mark on the newly-selected time signature and remove check mark from old time signature.

	MetronomeAppDelegate *appDelegate = (MetronomeAppDelegate *)[[UIApplication sharedApplication] delegate];

	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:([appDelegate timeSignature] - 2) inSection:0];
	
    [[table cellForRowAtIndexPath:oldIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    [[table cellForRowAtIndexPath:newIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    [table deselectRowAtIndexPath:newIndexPath animated:YES];
	
    if (newIndexPath.row == 0) {
        [appDelegate setTimeSignature:TimeSignatureTwoFour];
    }
	else if (newIndexPath.row == 1) {
        [appDelegate setTimeSignature:TimeSignatureThreeFour];
    }
	else {
        [appDelegate setTimeSignature:TimeSignatureFourFour];
    }
}


@end
