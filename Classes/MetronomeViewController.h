 
#import "PreferencesViewController.h"
@class MetronomeView;

@interface MetronomeViewController : UIViewController <PreferencesViewControllerDelegate> {
	MetronomeView *metronomeView;
}

@property (nonatomic, assign) IBOutlet MetronomeView *metronomeView;
- (IBAction)showInfo;   
- (void)showBooks;
@end
