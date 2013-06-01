//
//  SwipePageWidgetView.h
//  EGCoreFrameworkDemo
//
//  Created by feng guanhua on 13-5-28.
//  Copyright (c) 2013年 feng guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WIDGET_SWIPING,
    WIDGET_ANIMATION,
    WIDGET_ANIMATION_SWIPING,
}WidgetType;


typedef enum {
    MOVE_X,
    MOVE_Y,
}AnimationType;



@interface SwipePageWidgetView : UIView{
    WidgetType widgetType;
    AnimationType animationType;
    int   destination;
    float durnation;
    float delay;
}
@property (nonatomic, strong) NSString *name;



- (id)initWithParams:(CGRect)widgetFrame dest:(int)xy animateType:(AnimationType)atype image:(NSString*)name durnation:(float)dur delay:(float)del withMainViewFrame:(CGRect)mainFrame ofType:(WidgetType)wtype;
- (id)initWithJsonFile:(NSString *)filename;

+(SwipePageWidgetView*) addWidgetView:(CGRect)widgetFrame toDestX:(int)x animateType:(AnimationType)atype withImage:(NSString*)image durcation:(float)dur delay:(float)time ofType:(WidgetType)type withMainViewFrame:(CGRect)mainFrame inView:(UIView *)view;
+(SwipePageWidgetView*) initWithJsonFile:(NSString *)filename inView:(UIView *)view;

- (void)swipeViewDidScroll:(float)offset withIndex:(int) index;
@end

