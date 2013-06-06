//
//  SwipePageView.m
//
//  Created by feng guanhua on 13-5-5.
//  Copyright (c) 2013年 feng guanhua. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SwipePageView.h"
#import "AnimateWidgetView.h"
#import "EGCoreAnimation.h"
#import "SwipeDataSource.h"
#import "AnimateImageWidgetView.h"

@implementation SwipePageView
@synthesize widgets,json_data;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 1024, 768);
        widgets = [[NSMutableArray alloc] init];
        kenView = [[KenBurnsView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
        [self addSubview:kenView];
    }
    return self;
}


-(void) clearExistingWidgets
{
    for( int i=0; i<widgets.count; i++){
        AnimateWidgetView *view = [widgets objectAtIndex:i];
        [view removeFromSuperview];
    }
    [widgets removeAllObjects];
}


-(void) resetContentWithIndex:(int)index
{    
    [self clearExistingWidgets];
    [self loadStaticShowWidgets:index forKey:Category_Widget_StaticImage];
    [self loadStaticShowWidgets:index forKey:Category_Widget_Swipings];
    [self initAnimationBackground:json_data];    
    [self timerAnimation];
}




-(AnimateWidgetView*) createViewWithJsonDict:(NSDictionary*)dict inView:(UIView*)view
{
    AnimateWidgetView *widget = nil;
    WidgetType type =  [SwipeDataSource widgetTypeFromDict:dict];
    if( type == Widget_Animation_ImageShade || type == Widget_Animation_ImageFadeIn ){
        widget = [[AnimateImageWidgetView alloc] initWithJsonDict:dict withType:type];
    } else {
         widget = [[AnimateWidgetView alloc] initWithJsonDict:dict];
    }
    [view addSubview:widget];
    return widget;
}


-(void)loadStaticShowWidgets:(int)index forKey:(NSString*)key
{
    NSString *pageName = [[SwipeDataSource instance] getPageFileNameByIndex:index];
    if( pageName.length == 0 ) return;
    NSString *filename = [pageName stringByAppendingString:@".json"];
    NSLog(@"name=%@", filename);
    
    json_data = [[SwipeDataSource instance] getPage:filename];
    
    NSArray *objs = [json_data objectForKey:key];
    for ( int i=0 ; i<[objs count]; i++ ) {
        NSDictionary *obj = [objs objectAtIndex:i];
        AnimateWidgetView *widget = [self createViewWithJsonDict:obj inView:self];
        [widgets addObject:widget];
    }
}




- (void)swipeViewDidScroll:(SwipeView *)swipeView
{
    for ( int i=0;  i<widgets.count; i++ ) {
        AnimateWidgetView *view = [widgets objectAtIndex:i];
        [view swipeViewDidScroll:[swipeView scrollOffset] withIndex:[swipeView previousItemIndex]];
    }
}



-(void)timerAnimation
{    
    [NSTimer scheduledTimerWithTimeInterval:(0.3) target:self selector:@selector(animationShowByThread) userInfo:nil repeats:NO];
}



-(void) animationShowByThread
{
//    [NSThread detachNewThreadSelector:@selector(animationGroupShow) toTarget:self withObject:nil];
    [self animationGroupShow];
}


-(UIImageView*) addImageView:(NSString*)imageName withFrame:(CGRect)frame
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:frame];
    imageview.image = [UIImage imageNamed:imageName];
    [self addSubview:imageview];
    return imageview;
}



-(void) animationGroupShow
{
    NSArray *objs = [json_data objectForKey:Category_Widget_Animations];
    for ( int i=0 ; i<[objs count]; i++ ) {
        NSDictionary *obj = [objs objectAtIndex:i];
        
        AnimateWidgetView *widget = [self createViewWithJsonDict:obj inView:self];
        [widgets addObject:widget];
        [widget animate];
    }
}


-(void)initAnimationBackground:(NSDictionary*)dict
{
    NSString *bg = [dict objectForKey:@"background"];
    NSArray *myImages = [NSArray arrayWithObjects:[UIImage imageNamed:bg], nil];
    [kenView animateWithImages:myImages transitionDuration:BACKGROUND_TRANS_DUR loop:YES isLandscape:YES];
}

@end



