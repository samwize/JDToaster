//
//  JDToasterView.m
//  JDLibrary
//
//  Created by Junda on 11/1/10.
//  Copyright 2010 Just2me. All rights reserved.
//

#import "JDToasterView.h"
#import <QuartzCore/QuartzCore.h>

#define TOASTER_FONT_SIZE				16
#define TOASTER_FADE_DURATION			0.5
#define TOASTER_BORDER_CORNER_RADIUS	15
#define TOASTER_INNER_CORNER_RADIUS		12
#define TOASTER_WIDTH_PADDING			40
#define TOASTER_HEIGHT					30
#define TOASTER_BORDER					3


@interface JDToasterView (Private)
-(id)initToasterWithMessage:(NSString*)message inView:(UIView*)view atLevel:(float)level;
-(void)animateShow;
-(void)animateHide;
-(UIColor *)colorWithRGBHex:(UInt32)hex;
@end



@implementation JDToasterView


+(void)showToasterWithMessage:(NSString*)message {
	return [self showToasterWithMessage:message forDuration:DEFAULT_TOASTER_DISPLAY_DURATION];
}


+(void)showToasterWithMessage:(NSString*)message forDuration:(int)seconds {
	return [self showToasterWithMessage:message forDuration:seconds inView:[[UIApplication sharedApplication] keyWindow] atLevel:DEFAULT_TOASTER_LEVEL];
}


+(void)showToasterWithMessage:(NSString*)message forDuration:(int)seconds inView:(UIView*)view atLevel:(float)level {
	JDToasterView *toaster = [[JDToasterView alloc] initToasterWithMessage:message inView:view atLevel:level];
	[toaster animateShow];
	[toaster performSelector:@selector(animateHide) withObject:nil afterDelay:seconds];
	[toaster performSelector:@selector(destroy) withObject:nil afterDelay:seconds+3];	// Destroy
}


-(id)initToasterWithMessage:(NSString*)message inView:(UIView*)view atLevel:(float)level {
	if (!(self = [super initWithFrame:CGRectZero]))
		return nil;
	
	_level = level;

	messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	messageLabel.text = message;
	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.font = [UIFont boldSystemFontOfSize:TOASTER_FONT_SIZE];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textAlignment = UITextAlignmentCenter;
	
	borderView = [[UIView alloc] initWithFrame:CGRectZero];
	borderView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
	borderView.layer.cornerRadius = TOASTER_BORDER_CORNER_RADIUS;

	innerView = [[UIView alloc] initWithFrame:CGRectZero];
	innerView.backgroundColor = [[self colorWithRGBHex:0x555555] colorWithAlphaComponent:1];
	innerView.layer.cornerRadius = TOASTER_INNER_CORNER_RADIUS;
	
	[self addSubview:borderView];
	[self addSubview:innerView];
	[self addSubview:messageLabel];
	[view addSubview:self];
	
	[messageLabel release];
	[borderView release];
	[innerView release];
    
	// Set hidden first
	self.alpha = 0;
	
	return self;
}


- (void)layoutSubviews;
{
    CGSize textSize = [messageLabel.text sizeWithFont:[UIFont systemFontOfSize:TOASTER_FONT_SIZE]];
	
	float superviewWidth = self.superview.frame.size.width;
	float superviewHeight = self.superview.frame.size.height;
	float y;
	if (_level == 1) {
		y = superviewHeight - TOASTER_HEIGHT;
	} else if (_level == 0) {
		y = 0;
	} else {
		y = superviewHeight * _level - TOASTER_HEIGHT/2;
	}
			   
	// Setup message frame
	float totalWidth = textSize.width + 2*TOASTER_WIDTH_PADDING;
	if (totalWidth > superviewWidth)
		totalWidth = superviewWidth;
	CGRect messageRect = CGRectMake((superviewWidth-totalWidth)/2, y, totalWidth, TOASTER_HEIGHT);
	messageLabel.frame = messageRect;
	
	// Same frame
	borderView.frame = messageRect;

	// Slightly smaller frame
	CGRect innerRect = CGRectMake(messageRect.origin.x+TOASTER_BORDER, 
								  messageRect.origin.y+TOASTER_BORDER, 
								  messageRect.size.width-2*TOASTER_BORDER, 
								  messageRect.size.height-2*TOASTER_BORDER);
	innerView.frame = innerRect;
}


//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}


-(void)animateShow {
	[UIView beginAnimations:@"fade in toaster" context:nil];
	[UIView setAnimationDuration:TOASTER_FADE_DURATION];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	self.alpha = 1;
	[UIView commitAnimations];
}


-(void)animateHide {
	[UIView beginAnimations:@"fade out toaster" context:nil];
	[UIView setAnimationDuration:TOASTER_FADE_DURATION];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	self.alpha = 0;
	[UIView commitAnimations];	
}

-(void)destroy {
	[self removeFromSuperview];
	[self release];
}



- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Getting a UIColor from RGB. From "UIColor-Expanded.h"

- (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}


@end
