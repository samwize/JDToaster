//
//  JDToasterView.h
//  JDLibrary
//
//  Created by Junda on 11/1/10.
//  Copyright 2010 Just2me. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_TOASTER_DISPLAY_DURATION		5
#define DEFAULT_TOASTER_LEVEL					0.5

@interface JDToasterView : UIView {

	UIView *borderView;
	UIView *innerView;
	UILabel *messageLabel;
	
	float _level;
}

+(void)showToasterWithMessage:(NSString*)message;
+(void)showToasterWithMessage:(NSString*)message forDuration:(int)seconds;
+(void)showToasterWithMessage:(NSString*)message forDuration:(int)seconds inView:(UIView*)view atLevel:(float)level;



@end
