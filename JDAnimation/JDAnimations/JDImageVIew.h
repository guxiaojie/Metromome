//
//  JDImageVIew.h
//  JDAnimation
//
//  Created by SAMMY on 19/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDImageView : UIImageView{
    NSString *imageName;
    CGRect targetFrame;
    int animationID;
}

@property(nonatomic,retain) NSString *imageName;
@property(nonatomic,assign) CGRect targetFrame;
@property(nonatomic,assign) int animationID;

@end
