//
//  TimeSignatureView.h
//  Metronome
//
//  Created by starinno-005 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeSignatureDelegate;

@interface TimeSignatureView : UIView
{
    id <TimeSignatureDelegate> delegate;
}
@property(assign) id <TimeSignatureDelegate> delegate;

@end

@protocol TimeSignatureDelegate <NSObject>

- (void)timeSignatureChanged:(TimeSignatureView *)view timeSignature:(int)timeSignature;

@end