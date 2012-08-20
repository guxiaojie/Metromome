 

#import "MetronomeView.h"
#import "MetronomeAppDelegate.h"
#import "Global.h"

#define kDisplacementAngle 20
#define kMaxBPM 225
#define kMinBPM 1
#define kDefaultBPM 80

// These dimensions are based on the artwork for the arm.
// They're used to keep the weight from being dragged off either end of the arm.
// They're also used to calculate a rotational angle given a horizontal drag, see touchesMoved:.
#define kArmBaseX    160.0
#define kArmBaseY    440.0
#define kArmTopY     100.0
#define kWeightHeight 40.0
#define kWeightOffset 14.0
#define kUpperWeightLocationLimit kArmTopY + (kWeightHeight / 2)
#define kLowerWeightLocationLimit kArmBaseY

#define kYMinMinusBPMMin (kArmTopY - kMinBPM)
#define kBPMRange (kMaxBPM - kMinBPM)
#define kYRange (kArmBaseY - kArmTopY)

CGFloat WeightYCoordinateForBPM(NSInteger bpm) {
    CGFloat yCoord = (bpm + kWeightOffset) * (kYRange/kBPMRange) + kArmTopY;
    return yCoord;
}

CGFloat bpmForWeightYCoordinate(NSInteger yCoord) {
    CGFloat bpm = (yCoord - kArmTopY) * (kBPMRange/kYRange) - kWeightOffset;
    return bpm;
}

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

// Setter is private, so redeclare property here in a class extension.
@interface MetronomeView () 
@property CGFloat duration;
@end

// Private interface, methods used only internally.
@interface MetronomeView (PrivateMethods)

@property CGFloat duration;

- (void)stopArm:(id)sender;
- (void)stopSoundAndArm;
- (void)stopDriverThread;
- (void)startSoundAndAnimateArmToRight:(BOOL)startToRight;
- (void)updateWeightPosition;
- (void)dragWeightByYDisplacement:(CGFloat)yDisplacement;
- (void)updateBPMFromWeightLocation;
- (void)rotateArmToDegree:(CGFloat)positionInDegrees;
@end


@implementation MetronomeView

@synthesize duration, metronomeViewController, tickPlayer, tockPlayer, soundPlayerThread;


#pragma mark -
#pragma mark === Initialization and dealloc ===
#pragma mark -

- (UIButton *)createButtonWithFram:(CGRect)frame image:(NSString *)image target:(id)target selector:(SEL)selector{
    UIButton *btnAdd = [[UIButton alloc] initWithFrame:frame];
    [btnAdd setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btnAdd addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAdd];
    return btnAdd;
}

- (id)initWithFrame:(CGRect)frame {

	if (self = [super initWithFrame:frame]) {
		
		// Set up default state
		armIsAnimating = NO;
		tempoChangeInProgress = NO;
		self.bpm = kDefaultBPM;
		
		/*
		 Set up sounds and views.
		*/
		// Create and prepare audio players for tick and tock sounds
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSError *error;
		
		NSURL *tickURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"tick" ofType:@"caf"]];
		
		tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tickURL error:&error];
		if (!tickPlayer) {
			NSLog(@"no tickPlayer: %@", [error localizedDescription]);	
		}
		[tickPlayer prepareToPlay];
		
		NSURL *tockURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"tock" ofType:@"caf"]];
		tockPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tockURL error:&error];
		if (!tockPlayer) {
			NSLog(@"no tockPlayer: %@", [error localizedDescription]);	
		}
		[tockPlayer prepareToPlay];
		
		self.backgroundColor = [UIColor blackColor];
		
		// set up front view
		UIImageView *metronomeFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"metronomeBody.png"]];
		metronomeFront.center = self.center;
		metronomeFront.opaque = YES; 
        
		// Set up the metronome arm.
		metronomeArm = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"metronomeArm.png"]];
		
		// Move the anchor point to the bottom middle of the metronomeArm bounds, so rotations occur around that point.
		metronomeArm.layer.anchorPoint = CGPointMake(0.5, 1.0);
		
		CGFloat centerY = self.center.y + (self.bounds.size.height/2);
		metronomeArm.center = CGPointMake(self.center.x, centerY);
		
		// Set up the metronome weight.
		metronomeWeight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"metronomeWeight.png"]];
		metronomeWeight.center=CGPointMake(self.center.x, centerY);
		 
		// Add 'i' button
		UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
		infoButton.frame = CGRectMake(256, 432, 44, 44);
		[infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
        
		// Add the views in proper order and location.
		[self addSubview:metronomeFront];
		[self addSubview:tempoDisplay];
		[metronomeFront addSubview:metronomeArm];
		[metronomeArm addSubview:metronomeWeight];
		[self addSubview:infoButton];
		
		// Release views we no longer need to address.
		[metronomeFront release];
		
        tempoDisplay=[Global createLable:CGRectMake(10, 88-20, 42, 20) text:[NSString stringWithFormat:@"%d", self.bpm] textColor:[UIColor colorWithRed:23/255.0 green:207/255.0 blue:1 alpha:1] fontSize:14];
        [self addSubview:tempoDisplay];
        tempoDisplay.textAlignment = UITextAlignmentCenter;

        UIButton *btnTop = [self createButtonWithFram:CGRectMake(10, 5, 42, 42) image:@"READING_ICON.png" target:self selector:@selector(showBooks)];
		[self addSubview:btnTop];
        [btnTop release];
        
        UIButton *btnAdd = [self createButtonWithFram:CGRectMake(10, 88, 42, 42) image:@"ADD_ICON.png" target:self selector:@selector(addTempo)];
		[self addSubview:btnAdd];
        [btnAdd release];
		
        UIButton *btnLess = [self createButtonWithFram:CGRectMake(10, 88+47, 42, 42) image:@"LESS_ICON.png" target:self selector:@selector(reduceTempo)];
		[self addSubview:btnLess];
        [btnLess release];
        
        UIButton *bookButton = [self createButtonWithFram:CGRectMake(256, 88, 43, 43) image:@"TIME_ICON.png" target:self selector:@selector(showTimeSignature)];
		[self addSubview:bookButton];
        [bookButton release]; 
        
        MetronomeAppDelegate *appDelegate = (MetronomeAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *strTimeSig = [appDelegate.timeSignatures objectAtIndex:0];
        lbTimeSignature=[Global createLable:CGRectMake(256, 88-20, 42, 20) text:strTimeSig textColor:[UIColor colorWithRed:23/255.0 green:207/255.0 blue:1 alpha:1] fontSize:14];
        [self addSubview:lbTimeSignature];
        lbTimeSignature.textAlignment = UITextAlignmentCenter;
        
		UIImageView *bottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom.png"]];
		bottom.center=CGPointMake(self.center.x, 438);
        [self addSubview:bottom];
        [bottom release];

		// Make sure weight position represents current BPM setting.
		[self updateWeightPosition];
	}
	return self;
}


- (void)dealloc {
    [metronomeArm release];
    [metronomeWeight release];
    [tempoDisplay release];
    [lbTimeSignature release];
    
    [tickPlayer release];
    [tockPlayer release];
    [super dealloc];
}


#pragma mark -
#pragma mark === Touch handling ===
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    lastLocation = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
        
    CGFloat xDisplacement = location.x - lastLocation.x;
    CGFloat yDisplacement = location.y - lastLocation.y;
    CGFloat xDisplacementAbs = fabs(xDisplacement);
    CGFloat yDisplacementAbs = fabs(yDisplacement);

    // If the displacement is vertical, drag the weight up or down. This will impact the speed of the oscillation.
    if ((xDisplacementAbs < yDisplacementAbs) && (yDisplacementAbs > 1)) {  
        [self stopSoundAndArm];
        [self dragWeightByYDisplacement:yDisplacement];
        lastLocation = location;
        tempoChangeInProgress = YES;
    } else if (xDisplacementAbs >= yDisplacementAbs) {  
        // If displacement is horizontal, drag arm left or right. This will start oscillation when the touch ends.
        CGFloat radians = atan2f(location.y - kArmBaseY, location.x - kArmBaseX);
        CGFloat rotation = RadiansToDegrees(radians) + 90.0;
        [self rotateArmToDegree:rotation];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGFloat xDisplacement = location.x - lastLocation.x;
    CGFloat yDisplacement = location.y - lastLocation.y;
    CGFloat xDisplacementAbs = fabs(xDisplacement);
    CGFloat yDisplacementAbs = fabs(yDisplacement);
    
    [self stopSoundAndArm];

    if (tempoChangeInProgress) {  
        [self dragWeightByYDisplacement:yDisplacement];
        [self startSoundAndAnimateArmToRight:YES];
        tempoChangeInProgress = NO;
    } else if (xDisplacementAbs > yDisplacementAbs) {
        // horizontal displacement, start oscillation
        BOOL startToRight = (xDisplacement >= 0.0) ? YES : NO;
        [self startSoundAndAnimateArmToRight:startToRight];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    tempoChangeInProgress = NO;
    [self stopSoundAndArm];
}


#pragma mark -
#pragma mark === Actions ===
- (void)updateWeightPosition {
    CGFloat yLocation = WeightYCoordinateForBPM(self.bpm);
    CGPoint weightPosition = metronomeWeight.center;
    CGPoint newPosition = CGPointMake(weightPosition.x, yLocation);
    metronomeWeight.center=newPosition;
    tempoDisplay.text = [NSString stringWithFormat:@"%d", self.bpm];
    [self setNeedsDisplay];
}

- (void)dragWeightByYDisplacement:(CGFloat)yDisplacement {
    CGPoint weightPosition = metronomeWeight.center;
    CGFloat newYPos = weightPosition.y + yDisplacement;
    
    if (newYPos > kLowerWeightLocationLimit) {
        newYPos = kLowerWeightLocationLimit;
    } else if (newYPos < kUpperWeightLocationLimit) {
        newYPos = kUpperWeightLocationLimit;
    }
    
    CGPoint newPosition = CGPointMake(weightPosition.x, newYPos);
    metronomeWeight.center=newPosition;
    
    [self updateBPMFromWeightLocation];

    tempoDisplay.text = [NSString stringWithFormat:@"%d", self.bpm];
    [self setNeedsDisplay];
}

- (void)updateBPMFromWeightLocation {
    CGFloat weightYPosition = metronomeWeight.center.y;
    NSUInteger newBPM = ceil(bpmForWeightYCoordinate(weightYPosition));
    self.bpm = newBPM;
}

- (void)playSound {
    AVAudioPlayer *currentPlayer = tickPlayer;
	
	MetronomeAppDelegate *appDelegate = (MetronomeAppDelegate *)[[UIApplication sharedApplication] delegate];
	int timeSig=[appDelegate timeSignature];
    NSLog(@"~~~~beatNumber:%d~~~timeSig:%d",beatNumber,timeSig);
    if (beatNumber == 1) {
		currentPlayer = tockPlayer;
    }
	else if (beatNumber == timeSig) {
        beatNumber = 0;
    }
    
    [currentPlayer play];
    beatNumber++;
}

- (void)startDriverTimer:(id)info {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Give the sound thread high priority to keep the timing steady.
    [NSThread setThreadPriority:1.0];
    BOOL continuePlaying = YES;
    
    while (continuePlaying) {  // Loop until cancelled.
		
        // An autorelease pool to prevent the build-up of temporary objects.
        NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init]; 
        
        [self playSound];
        [self performSelectorOnMainThread:@selector(animateArmToOppositeExtreme) withObject:nil waitUntilDone:NO];
        NSDate *curtainTime = [[NSDate alloc] initWithTimeIntervalSinceNow:self.duration];
        NSDate *currentTime = [[NSDate alloc] init];
        
        // Wake up periodically to see if we've been cancelled.
        while (continuePlaying && ([currentTime compare:curtainTime] != NSOrderedDescending)) { 
            if ([soundPlayerThread isCancelled] == YES) {
                continuePlaying = NO;
            }
            [NSThread sleepForTimeInterval:0.01];
			[currentTime release];
            currentTime = [[NSDate alloc] init];
        }
		[curtainTime release];		
		[currentTime release];		
        
        [loopPool drain];
    }
    [pool drain];
}

- (void)waitForSoundDriverThreadToFinish {
    while (soundPlayerThread && ![soundPlayerThread isFinished]) { // Wait for the thread to finish.
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)startDriverThread {
    if (soundPlayerThread != nil) {
        [soundPlayerThread cancel];
        [self waitForSoundDriverThreadToFinish];
    }
    
    NSThread *driverThread = [[NSThread alloc] initWithTarget:self selector:@selector(startDriverTimer:) object:nil];
    self.soundPlayerThread = driverThread;
    [driverThread release];
    
    [self.soundPlayerThread start];
}

- (void)stopDriverThread {
    [self.soundPlayerThread cancel];
    [self waitForSoundDriverThreadToFinish];
    self.soundPlayerThread = nil;
}

- (void)showInfo {
	[metronomeViewController showInfo];	
}

- (void)showBooks{
    [metronomeViewController showBooks];	
}

- (void)showTimeSignature{
    TimeSignatureView *view=[[TimeSignatureView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self addSubview:view];
    view.delegate=self;
    [view release];
}

- (void)addTempo{
    [self dragWeightByYDisplacement:-5];
}

- (void)reduceTempo{
    [self dragWeightByYDisplacement:+5];
}

#pragma mark -
#pragma mark === Oscillation Animation Starts Here ===
#pragma mark -

// Animation creates a separate thread.
- (void)startSoundAndAnimateArmToRight:(BOOL)startToRight {
    if (armIsAnimating == YES) {
        return;
    }
    
    // Start by animating arm to full extent of swing in the swiped direction.
    if (startToRight == YES) {
        [self rotateArmToDegree:kDisplacementAngle];
        armIsAtRightExtreme = YES;
    } else {
        [self rotateArmToDegree:-kDisplacementAngle];
        armIsAtRightExtreme = NO;
    }
    
    beatNumber = 1;
    [self startDriverThread];
    armIsAnimating = YES;
}

- (void)stopSoundAndArm {
    [self stopArm:self];
    [self stopDriverThread];
}

- (void)rotateArmToDegree:(CGFloat)positionInDegrees {
    [metronomeArm.layer removeAllAnimations];
	
    // Keep arm from being dragged beyond the maximum displacement.
    if (positionInDegrees > kDisplacementAngle) {
        positionInDegrees = kDisplacementAngle;
    } else if (positionInDegrees < -kDisplacementAngle) {
        positionInDegrees = -kDisplacementAngle;
    }
	
    CATransform3D rotationTransform = CATransform3DIdentity;
    rotationTransform = CATransform3DRotate(rotationTransform, DegreesToRadians(positionInDegrees), 0.0, 0.0, 1.0);
    metronomeArm.layer.transform = rotationTransform;
}

- (void)animateArmToOppositeExtreme {
    int signValue = (armIsAtRightExtreme) ? -1 : 1;
    
    // Create rotation animation around z axis.
    CABasicAnimation *rotateAnimation = [CABasicAnimation animation];
    rotateAnimation.keyPath = @"transform.rotation.z";
    rotateAnimation.fromValue = [NSNumber numberWithFloat:DegreesToRadians(signValue * -kDisplacementAngle)];
    rotateAnimation.toValue = [NSNumber numberWithFloat:DegreesToRadians(signValue * kDisplacementAngle)];
    rotateAnimation.duration = (self.duration);
    rotateAnimation.removedOnCompletion = NO;
    // leaves presentation layer in final state; preventing snap-back to original state
    rotateAnimation.fillMode = kCAFillModeBoth; 
    rotateAnimation.repeatCount = 0;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Add the animation to the selection layer. This causes it to begin animating. 
    [metronomeArm.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    armIsAnimating = YES;
    armIsAtRightExtreme = (armIsAtRightExtreme) ? NO : YES;
}

- (IBAction)updateAnimation:(id)sender {
    if (armIsAnimating) {
        [self stopSoundAndArm];
        [self startSoundAndAnimateArmToRight:YES];
    }
}


- (void)stopArm:(id)sender {
    if (armIsAnimating == NO) {
        return;
    }
    [self rotateArmToDegree:0.0];
    armIsAnimating = NO;
}


#pragma mark -
#pragma mark === bpm ===
#pragma mark -

- (NSUInteger)bpm {
    return lrint(ceil(60.0 / (self.duration)));
}


- (void)setBpm:(NSUInteger)bpm {
    if (bpm >= kMaxBPM) {
        bpm = kMaxBPM;
    } else if (bpm <= kMinBPM) {
        bpm = kMinBPM;
    }    
    self.duration = (60.0 / bpm);
}

#pragma mark -
#pragma mark === time signature ===
#pragma mark -
- (void)timeSignatureChanged:(TimeSignatureView *)view timeSignature:(int)timeSignature{
    
}


@end
