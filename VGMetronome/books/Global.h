//
//  Global.h
//  Metronome
//
//  Created by starinno-005 on 12-7-16.
//
//

#import <Foundation/Foundation.h>

@interface Global : NSObject
+ (NSString*)getDocument:(NSString *)fileName;

+ (UITextField *)createTextField:(CGRect)frame
                       textColor:(UIColor *)textColor
                        fontSize:(float)fontSize
                             pla:(NSString *)pla
                         keyType:(UIReturnKeyType)keyType
                            mode:(UITextFieldViewMode)mode
                        keyBoard:(UIKeyboardType)keyBoard
                             sel:(SEL)sel
                             del:(UIViewController *)del;

+ (UILabel *)createLable:(CGRect)frame
                    text:(NSString *)text
               textColor:(UIColor *)textColor
                fontSize:(float)fontSize;

+ (UITextView *)createTextView:(CGRect)frame
                     textColor:(UIColor *)textColor
                      fontSize:(float)fontSize;

+ (UIColor *)getColor:(NSString *)hexColor alpha:(float)alpha;

@end
