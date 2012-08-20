 
#import "MetronomeViewController.h"
#import "MetronomeView.h"
#import "PreferencesViewController.h"
#import "BooksViewController.h"

@implementation MetronomeViewController

#pragma mark -
#pragma mark === Show Preferences View ===
#pragma mark -

@synthesize metronomeView;


- (void)loadView {
	
	self.wantsFullScreenLayout = YES;
	MetronomeView *view = [[MetronomeView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.metronomeViewController = self;
	self.view = view;
    self.metronomeView = view;
	
    [view release];
}

- (void)showBooks{
    BooksViewController *booksVC=[[BooksViewController alloc] init];
    UINavigationController *navigation=[[UINavigationController alloc] initWithRootViewController:booksVC];
    [booksVC release];
	[self presentModalViewController:navigation animated:YES];
//    [self.navigationController pushViewController:navigation animated:YES];
    [navigation release];
}

- (IBAction)showInfo {    
    
	PreferencesViewController *controller = [[PreferencesViewController alloc] initWithNibName:@"PreferencesView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)preferencesViewControllerDidFinish:(PreferencesViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
