//
//  Global.m
//  Metronome
//
//  Created by starinno-005 on 12-7-16.
//
//

#import "Global.h"

@implementation Global

#pragma mark document
+ (NSString*)getDocument:(NSString *)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *document = [paths objectAtIndex:0];
	NSString *path = [document stringByAppendingPathComponent:fileName];
	return path;
}

#pragma mark -
+ (UITextField *)createTextField:(CGRect)frame
                       textColor:(UIColor *)textColor
                        fontSize:(float)fontSize
                             pla:(NSString *)pla
                         keyType:(UIReturnKeyType)keyType
                            mode:(UITextFieldViewMode)mode
                        keyBoard:(UIKeyboardType)keyBoard
                             sel:(SEL)sel
                             del:(UIViewController *)del
{
	UITextField *tfTemp=[[UITextField alloc] initWithFrame:frame];
	[tfTemp setBackgroundColor:[UIColor clearColor]];
	[tfTemp setTextColor:textColor];
	[tfTemp setFont:[UIFont systemFontOfSize:fontSize]];
    [tfTemp setPlaceholder:pla];
	[tfTemp addTarget:del action:sel forControlEvents:UIControlEventEditingDidBegin];
	[tfTemp setReturnKeyType:keyType];
	[tfTemp setEnablesReturnKeyAutomatically:NO];
    [tfTemp setBorderStyle:UITextBorderStyleNone];
    [tfTemp setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [tfTemp setClearButtonMode:mode];
	[tfTemp setKeyboardType:keyBoard];
	return tfTemp;
}

+ (UITextView *)createTextView:(CGRect)frame
                     textColor:(UIColor *)textColor
                      fontSize:(float)fontSize
{
    UITextView *tvTemp=[[UITextView alloc] initWithFrame:frame];
    [tvTemp setBackgroundColor:[UIColor clearColor]];
    [tvTemp setFont:[UIFont systemFontOfSize:fontSize]];
    [tvTemp setTextColor:textColor];
    return tvTemp;
}

+ (UILabel *)createLable:(CGRect)frame
                    text:(NSString *)text
               textColor:(UIColor *)textColor
                fontSize:(float)fontSize
{
    UILabel *lable=[[UILabel alloc] initWithFrame:frame];
    lable.backgroundColor=[UIColor clearColor];
    lable.textColor=textColor;
    lable.text=text;
    lable.font=[UIFont systemFontOfSize:fontSize];
    return  lable;
}

+(UIColor *)getColor:(NSString *)hexColor alpha:(float)alpha{
	unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	range.location = 0;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	range.location = 2;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	range.location = 4;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}

@end
